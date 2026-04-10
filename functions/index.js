const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { setGlobalOptions, logger } = require("firebase-functions/v2");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();
const openAiApiKeySecret = defineSecret("OPENAI_API_KEY");

setGlobalOptions({
  region: process.env.FUNCTIONS_REGION || "us-central1",
  maxInstances: 10,
});

function tokenRoleRaw(auth) {
  const role = auth?.token?.role;
  if (role === "dokter" || role === "doctor") return "dokter";
  if (role === "pasien" || role === "patient") return "pasien";
  if (role === "admin") return "admin";
  return null;
}

function normalizeRoleRaw(role) {
  if (!role) return null;
  if (role === "dokter" || role === "doctor") return "dokter";
  if (role === "pasien" || role === "patient") return "pasien";
  if (role === "admin") return "admin";
  return null;
}

function roleRawToAuditRole(rawRole) {
  if (rawRole === "dokter") return "doctor";
  if (rawRole === "pasien") return "patient";
  if (rawRole === "admin") return "admin";
  return null;
}

function ensureSignedIn(auth) {
  if (!auth?.uid) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }
}

function parseBoolean(value, fallback = false) {
  if (typeof value === "boolean") return value;
  if (typeof value === "string") {
    const normalized = value.trim().toLowerCase();
    if (normalized === "true") return true;
    if (normalized === "false") return false;
  }
  return fallback;
}

function normalizeMessageList(rawMessages) {
  if (!Array.isArray(rawMessages)) {
    throw new HttpsError("invalid-argument", "messages must be an array.");
  }

  if (rawMessages.length == 0 || rawMessages.length > 80) {
    throw new HttpsError("invalid-argument", "messages length must be between 1 and 80.");
  }

  const validRoles = new Set(["system", "user", "assistant"]);
  return rawMessages.map((item, index) => {
    const role = String(item?.role || "").trim();
    const content = String(item?.content || "").trim();

    if (!validRoles.has(role)) {
      throw new HttpsError("invalid-argument", `messages[${index}].role is invalid.`);
    }
    if (!content || content.length > 8000) {
      throw new HttpsError("invalid-argument", `messages[${index}].content is invalid.`);
    }

    return { role, content };
  });
}

function normalizeModel(rawModel) {
  const model = String(rawModel || "gpt-4o-mini").trim();
  if (!model) return "gpt-4o-mini";
  if (model.length > 100) {
    throw new HttpsError("invalid-argument", "model is too long.");
  }
  return model;
}

function normalizeMaxTokens(rawValue) {
  const parsed = Number(rawValue);
  if (!Number.isFinite(parsed)) return 500;
  const rounded = Math.round(parsed);
  if (rounded < 1) return 1;
  if (rounded > 2000) return 2000;
  return rounded;
}

function normalizeTemperature(rawValue) {
  const parsed = Number(rawValue);
  if (!Number.isFinite(parsed)) return 0.7;
  if (parsed < 0) return 0;
  if (parsed > 1.5) return 1.5;
  return parsed;
}

async function callOpenAiChatCompletion({
  apiKey,
  messages,
  model,
  maxTokens,
  temperature,
  jsonMode,
}) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 45000);

  const payload = {
    model,
    messages,
    max_tokens: maxTokens,
    temperature,
  };
  if (jsonMode) {
    payload.response_format = { type: "json_object" };
  }

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify(payload),
      signal: controller.signal,
    });

    const rawText = await response.text();
    const body = rawText ? JSON.parse(rawText) : {};

    if (!response.ok) {
      const upstreamMessage = body?.error?.message || "OpenAI request failed.";
      if (response.status === 401 || response.status === 403) {
        throw new HttpsError("failed-precondition", upstreamMessage, {
          errorCode: "unauthorized",
          statusCode: response.status,
        });
      }
      if (response.status === 429) {
        throw new HttpsError("resource-exhausted", upstreamMessage, {
          errorCode: "rate_limited",
          statusCode: response.status,
        });
      }
      throw new HttpsError("unavailable", upstreamMessage, {
        errorCode: "upstream_error",
        statusCode: response.status,
      });
    }

    const content = String(body?.choices?.[0]?.message?.content || "").trim();
    if (!content) {
      throw new HttpsError("internal", "OpenAI returned empty content.", {
        errorCode: "empty_response",
      });
    }
    return content;
  } catch (error) {
    if (error instanceof HttpsError) {
      throw error;
    }
    if (error?.name === "AbortError") {
      throw new HttpsError("deadline-exceeded", "OpenAI request timeout.", {
        errorCode: "timeout",
      });
    }
    logger.error("ai_gateway_upstream_exception", {
      message: error?.message || String(error),
    });
    throw new HttpsError("unavailable", "AI service unavailable.", {
      errorCode: "service_unavailable",
    });
  } finally {
    clearTimeout(timeout);
  }
}

async function resolveRoleRaw(auth) {
  const claimRole = tokenRoleRaw(auth);
  if (claimRole) {
    return claimRole;
  }

  const uid = auth?.uid;
  if (!uid) {
    return null;
  }

  const userSnap = await db.collection("users").doc(uid).get();
  if (!userSnap.exists) {
    return null;
  }

  const userData = userSnap.data() || {};
  return normalizeRoleRaw(String(userData.role || ""));
}

async function ensureDoctorOrAdmin(auth) {
  const role = await resolveRoleRaw(auth);
  if (role !== "dokter" && role !== "admin") {
    throw new HttpsError("permission-denied", "Only doctor/admin can perform this action.");
  }
  return role;
}

async function ensureAdmin(auth) {
  const role = await resolveRoleRaw(auth);
  if (role !== "admin") {
    throw new HttpsError("permission-denied", "Only admin can perform this action.");
  }
  return role;
}

async function writeImmutableAuditLog(params) {
  const {
    actorUid,
    actorRole,
    actorName,
    actionType,
    entityType,
    entityId = null,
    message,
    status = "success",
    meta = null,
  } = params;

  await db.collection("admin_audit_logs").add({
    actorUid,
    actorRole,
    actorName,
    actionType,
    entityType,
    entityId,
    message,
    status,
    meta,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    // compatibility fields for current admin UI
    userId: actorUid,
    userRole: actorRole,
    userName: actorName,
    action: actionType,
    target: entityType,
    details: message,
    timestamp: new Date().toISOString(),
  });
}

exports.writeAdminAuditLog = onCall(async (request) => {
  ensureSignedIn(request.auth);

  const roleRaw = await resolveRoleRaw(request.auth);
  const role = roleRawToAuditRole(roleRaw);
  if (role !== "doctor" && role !== "admin") {
    throw new HttpsError("permission-denied", "Only doctor/admin can write admin audit logs.");
  }

  const payload = request.data || {};
  const actionType = String(payload.actionType || "UNKNOWN");
  const entityType = String(payload.entityType || "unknown");
  const message = String(payload.message || "-");

  await writeImmutableAuditLog({
    actorUid: request.auth.uid,
    actorRole: role,
    actorName: String(payload.actorName || request.auth.token.name || request.auth.token.email || request.auth.uid),
    actionType,
    entityType,
    entityId: payload.entityId ? String(payload.entityId) : null,
    message,
    status: payload.status === "failed" ? "failed" : "success",
    meta: payload.meta && typeof payload.meta === "object" ? payload.meta : null,
  });

  return { ok: true };
});

exports.approvePasienProfile = onCall(async (request) => {
  ensureSignedIn(request.auth);
  const role = await ensureDoctorOrAdmin(request.auth);

  const pasienId = String(request.data?.pasienId || "").trim();
  const diagnosis = String(request.data?.diagnosis || "").trim();
  const surgeryType = String(request.data?.surgeryType || "").trim();
  const anesthesiaType = String(request.data?.anesthesiaType || "").trim();

  if (!pasienId || !diagnosis || !surgeryType || !anesthesiaType) {
    throw new HttpsError("invalid-argument", "pasienId, diagnosis, surgeryType, and anesthesiaType are required.");
  }

  const pasienRef = db.collection("pasien_profiles").doc(pasienId);
  const pasienSnap = await pasienRef.get();

  if (!pasienSnap.exists) {
    throw new HttpsError("not-found", "Pasien profile not found.");
  }

  const pasienData = pasienSnap.data() || {};
  const assignedDokterId = pasienData.assignedDokterId ? String(pasienData.assignedDokterId) : null;

  if (role === "dokter" && assignedDokterId && assignedDokterId !== request.auth.uid) {
    throw new HttpsError("permission-denied", "You are not assigned to this patient.");
  }

  const actorRole = role === "dokter" ? "doctor" : "admin";
  const actorName = String(request.auth.token.name || request.auth.token.email || request.auth.uid);

  const batch = db.batch();
  batch.update(pasienRef, {
    diagnosis,
    jenisOperasi: surgeryType,
    jenisAnestesi: anesthesiaType,
    status: "approved",
    approvalDate: admin.firestore.FieldValue.serverTimestamp(),
    approvedByUid: request.auth.uid,
    approvedByRole: role,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const auditRef = db.collection("admin_audit_logs").doc();
  batch.set(auditRef, {
    actorUid: request.auth.uid,
    actorRole,
    actorName,
    actionType: "APPROVE_PATIENT",
    entityType: "pasien_profiles",
    entityId: pasienId,
    message: `Approved patient ${pasienId} with anesthesia ${anesthesiaType}`,
    status: "success",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    userId: request.auth.uid,
    userRole: actorRole,
    userName: actorName,
    action: "APPROVE_PATIENT",
    target: "pasien_profiles",
    details: `Approved patient ${pasienId}`,
    timestamp: new Date().toISOString(),
  });

  await batch.commit();

  return { ok: true };
});

exports.assignPasienAnesthesia = onCall(async (request) => {
  ensureSignedIn(request.auth);
  const role = await ensureDoctorOrAdmin(request.auth);

  const pasienId = String(request.data?.pasienId || "").trim();
  const anesthesiaType = String(request.data?.anesthesiaType || "").trim();

  if (!pasienId || !anesthesiaType) {
    throw new HttpsError("invalid-argument", "pasienId and anesthesiaType are required.");
  }

  const pasienRef = db.collection("pasien_profiles").doc(pasienId);
  const pasienSnap = await pasienRef.get();

  if (!pasienSnap.exists) {
    throw new HttpsError("not-found", "Pasien profile not found.");
  }

  const pasienData = pasienSnap.data() || {};
  const assignedDokterId = pasienData.assignedDokterId ? String(pasienData.assignedDokterId) : null;

  if (role === "dokter" && assignedDokterId && assignedDokterId !== request.auth.uid) {
    throw new HttpsError("permission-denied", "You are not assigned to this patient.");
  }

  const actorRole = role === "dokter" ? "doctor" : "admin";
  const actorName = String(request.auth.token.name || request.auth.token.email || request.auth.uid);

  const batch = db.batch();
  batch.update(pasienRef, {
    jenisAnestesi: anesthesiaType,
    status: "in_progress",
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    assignedByUid: request.auth.uid,
    assignedByRole: role,
  });

  const auditRef = db.collection("admin_audit_logs").doc();
  batch.set(auditRef, {
    actorUid: request.auth.uid,
    actorRole,
    actorName,
    actionType: "ASSIGN_ANESTHESIA",
    entityType: "pasien_profiles",
    entityId: pasienId,
    message: `Assigned anesthesia ${anesthesiaType} to patient ${pasienId}`,
    status: "success",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    userId: request.auth.uid,
    userRole: actorRole,
    userName: actorName,
    action: "ASSIGN_ANESTHESIA",
    target: "pasien_profiles",
    details: `Assigned anesthesia ${anesthesiaType} to patient ${pasienId}`,
    timestamp: new Date().toISOString(),
  });

  await batch.commit();

  return { ok: true };
});

exports.rejectPasienProfile = onCall(async (request) => {
  ensureSignedIn(request.auth);
  const role = await ensureDoctorOrAdmin(request.auth);

  const pasienId = String(request.data?.pasienId || "").trim();
  const reason = String(request.data?.reason || "Ditolak oleh dokter").trim();

  if (!pasienId) {
    throw new HttpsError("invalid-argument", "pasienId is required.");
  }

  const pasienRef = db.collection("pasien_profiles").doc(pasienId);
  const pasienSnap = await pasienRef.get();

  if (!pasienSnap.exists) {
    throw new HttpsError("not-found", "Pasien profile not found.");
  }

  const pasienData = pasienSnap.data() || {};
  const assignedDokterId = pasienData.assignedDokterId ? String(pasienData.assignedDokterId) : null;

  if (role === "dokter" && assignedDokterId && assignedDokterId !== request.auth.uid) {
    throw new HttpsError("permission-denied", "You are not assigned to this patient.");
  }

  const actorRole = role === "dokter" ? "doctor" : "admin";
  const actorName = String(request.auth.token.name || request.auth.token.email || request.auth.uid);

  const batch = db.batch();
  batch.update(pasienRef, {
    status: "rejected",
    rejectionReason: reason || "Ditolak oleh dokter",
    rejectionDate: admin.firestore.FieldValue.serverTimestamp(),
    rejectedByUid: request.auth.uid,
    rejectedByRole: role,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const auditRef = db.collection("admin_audit_logs").doc();
  batch.set(auditRef, {
    actorUid: request.auth.uid,
    actorRole,
    actorName,
    actionType: "REJECT_PATIENT",
    entityType: "pasien_profiles",
    entityId: pasienId,
    message: `Rejected patient ${pasienId}`,
    status: "success",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    userId: request.auth.uid,
    userRole: actorRole,
    userName: actorName,
    action: "REJECT_PATIENT",
    target: "pasien_profiles",
    details: `Rejected patient ${pasienId}: ${reason}`,
    timestamp: new Date().toISOString(),
  });

  await batch.commit();

  return { ok: true };
});

exports.aiGatewayChat = onCall(
  {
    timeoutSeconds: 60,
    memory: "256MiB",
    secrets: [openAiApiKeySecret],
  },
  async (request) => {
    ensureSignedIn(request.auth);
    const role = await resolveRoleRaw(request.auth);
    if (!["pasien", "dokter", "admin"].includes(String(role))) {
      throw new HttpsError("permission-denied", "Role is not allowed to use AI gateway.");
    }

    if (parseBoolean(process.env.AI_GATEWAY_ENABLED, true) === false) {
      throw new HttpsError("failed-precondition", "AI gateway is disabled by configuration.", {
        errorCode: "missing_config",
      });
    }

    const apiKey = String(openAiApiKeySecret.value() || "").trim();
    if (!apiKey) {
      throw new HttpsError("failed-precondition", "OPENAI_API_KEY secret is missing.", {
        errorCode: "missing_config",
      });
    }

    const data = request.data || {};
    const traceId = String(data.traceId || `${request.auth.uid}-${Date.now()}`).trim();
    const action = String(data.action || "chat").trim();
    const messages = normalizeMessageList(data.messages);
    const model = normalizeModel(data.model);
    const maxTokens = normalizeMaxTokens(data.maxTokens);
    const temperature = normalizeTemperature(data.temperature);
    const jsonMode = parseBoolean(data.jsonMode, false);

    logger.info("ai_request_started", {
      uid: request.auth.uid,
      role,
      action,
      traceId,
      messageCount: messages.length,
      model,
      jsonMode,
      maxTokens,
    });

    try {
      const reply = await callOpenAiChatCompletion({
        apiKey,
        messages,
        model,
        maxTokens,
        temperature,
        jsonMode,
      });

      logger.info("ai_request_succeeded", {
        uid: request.auth.uid,
        role,
        action,
        traceId,
      });

      return {
        reply,
        source: "openai_gateway",
        errorCode: null,
        traceId,
      };
    } catch (error) {
      const errorCode = error instanceof HttpsError
        ? (error.details?.errorCode || error.code || "service_unavailable")
        : "service_unavailable";
      logger.error("ai_request_failed", {
        uid: request.auth.uid,
        role,
        action,
        traceId,
        errorCode,
      });
      throw error;
    }
  },
);

exports.setUserLifecycleStatus = onCall(async (request) => {
  ensureSignedIn(request.auth);
  await ensureAdmin(request.auth);

  const userId = String(request.data?.userId || "").trim();
  const targetStatus = String(request.data?.targetStatus || "").trim();
  const reasonRaw = String(request.data?.reason || "").trim();

  if (!userId || (targetStatus !== "active" && targetStatus !== "suspended")) {
    throw new HttpsError("invalid-argument", "userId and valid targetStatus (active|suspended) are required.");
  }

  const userRef = db.collection("users").doc(userId);
  const userSnap = await userRef.get();
  if (!userSnap.exists) {
    throw new HttpsError("not-found", "User not found.");
  }

  const actorName = String(request.auth.token.name || request.auth.token.email || request.auth.uid);
  const reason = reasonRaw || (targetStatus === "suspended" ? "Suspended by admin" : "Activated by admin");

  const batch = db.batch();
  batch.update(userRef, {
    status: targetStatus,
    statusReason: reason,
    statusUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    statusUpdatedByUid: request.auth.uid,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const auditRef = db.collection("admin_audit_logs").doc();
  const actionType = targetStatus === "suspended" ? "SUSPEND_USER" : "ACTIVATE_USER";
  batch.set(auditRef, {
    actorUid: request.auth.uid,
    actorRole: "admin",
    actorName,
    actionType,
    entityType: "users",
    entityId: userId,
    message: `${actionType} ${userId}: ${reason}`,
    status: "success",
    meta: {
      targetStatus,
      reason,
    },
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    userId: request.auth.uid,
    userRole: "admin",
    userName: actorName,
    action: actionType,
    target: "users",
    details: `${actionType} ${userId}: ${reason}`,
    timestamp: new Date().toISOString(),
  });

  await batch.commit();

  try {
    await admin.auth().updateUser(userId, { disabled: targetStatus === "suspended" });
  } catch (error) {
    logger.error("Failed to sync Firebase Auth disabled state", { userId, targetStatus, error });
  }

  return { ok: true, userId, status: targetStatus };
});

exports.setKontenPublishStatus = onCall(async (request) => {
  ensureSignedIn(request.auth);
  await ensureAdmin(request.auth);

  const kontenId = String(request.data?.kontenId || "").trim();
  const targetStatus = String(request.data?.targetStatus || "").trim();
  const reasonRaw = String(request.data?.reason || "").trim();

  if (!kontenId || (targetStatus !== "draft" && targetStatus !== "published")) {
    throw new HttpsError("invalid-argument", "kontenId and valid targetStatus (draft|published) are required.");
  }

  const kontenRef = db.collection("konten").doc(kontenId);
  const kontenSnap = await kontenRef.get();
  if (!kontenSnap.exists) {
    throw new HttpsError("not-found", "Konten not found.");
  }

  const actorName = String(request.auth.token.name || request.auth.token.email || request.auth.uid);
  const reason = reasonRaw || (targetStatus === "published" ? "Published by admin" : "Set to draft by admin");
  const actionType = targetStatus === "published" ? "PUBLISH_CONTENT" : "UNPUBLISH_CONTENT";

  const updatePayload = {
    status: targetStatus,
    moderationReason: reason,
    moderatedByUid: request.auth.uid,
    moderatedByRole: "admin",
    moderatedAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    publishedAt: targetStatus === "published" ? admin.firestore.FieldValue.serverTimestamp() : null,
  };

  const batch = db.batch();
  batch.update(kontenRef, updatePayload);

  const auditRef = db.collection("admin_audit_logs").doc();
  batch.set(auditRef, {
    actorUid: request.auth.uid,
    actorRole: "admin",
    actorName,
    actionType,
    entityType: "konten",
    entityId: kontenId,
    message: `${actionType} ${kontenId}: ${reason}`,
    status: "success",
    meta: {
      targetStatus,
      reason,
    },
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    userId: request.auth.uid,
    userRole: "admin",
    userName: actorName,
    action: actionType,
    target: "konten",
    details: `${actionType} ${kontenId}: ${reason}`,
    timestamp: new Date().toISOString(),
  });

  await batch.commit();

  return { ok: true, kontenId, status: targetStatus };
});

logger.info("ACONSIA functions loaded", { region: process.env.FUNCTIONS_REGION || "us-central1" });
