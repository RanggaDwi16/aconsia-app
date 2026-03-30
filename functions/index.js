const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { setGlobalOptions, logger } = require("firebase-functions/v2");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

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

logger.info("ACONSIA functions loaded", { region: process.env.FUNCTIONS_REGION || "us-central1" });
