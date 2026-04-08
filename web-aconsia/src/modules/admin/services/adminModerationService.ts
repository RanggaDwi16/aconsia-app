import {
  addDoc,
  collection,
  doc,
  getDoc,
  serverTimestamp,
  updateDoc,
} from "firebase/firestore";
import { httpsCallable } from "firebase/functions";
import { firestore, firebaseFunctions } from "../../../core/firebase/client";
import { getDesktopSession } from "../../../core/auth/session";
import { userMessages } from "../../../app/copy/userMessages";

export type UserLifecycleStatus = "active" | "suspended";
export type ContentLifecycleStatus = "draft" | "published";
export type ModerationCallableErrorCode =
  | "unauthenticated"
  | "permission-denied"
  | "not-found"
  | "invalid-argument"
  | "unknown";
type ModerationActionContext = "content_publish" | "user_lifecycle";

const setUserLifecycleStatusCallable = httpsCallable(
  firebaseFunctions,
  "setUserLifecycleStatus",
);

function normalizeCallableErrorCode(error: unknown): ModerationCallableErrorCode {
  const rawCode =
    typeof error === "object" &&
    error !== null &&
    "code" in error &&
    typeof (error as { code?: unknown }).code === "string"
      ? String((error as { code?: string }).code)
      : "";

  const normalized = rawCode.includes("/") ? rawCode.split("/").pop() || "" : rawCode;
  if (normalized === "unauthenticated") return "unauthenticated";
  if (normalized === "permission-denied") return "permission-denied";
  if (normalized === "not-found") return "not-found";
  if (normalized === "invalid-argument") return "invalid-argument";
  return "unknown";
}

export function mapCallableErrorToUserMessage(
  context: ModerationActionContext,
  code: ModerationCallableErrorCode,
): string {
  if (context === "content_publish") {
    if (code === "unauthenticated") return userMessages.admin.publishUnauthenticated;
    if (code === "permission-denied") return userMessages.admin.publishAccessDenied;
    if (code === "not-found") return userMessages.admin.publishNotFound;
    if (code === "invalid-argument") return userMessages.admin.publishInvalidArgument;
    return userMessages.admin.publishUnknown;
  }

  if (code === "unauthenticated") return userMessages.admin.lifecycleUnauthenticated;
  if (code === "permission-denied") return userMessages.admin.lifecycleAccessDenied;
  if (code === "not-found") return userMessages.admin.lifecycleNotFound;
  if (code === "invalid-argument") return userMessages.admin.lifecycleInvalidArgument;
  return userMessages.admin.lifecycleUnknown;
}

function extractDebugMessage(error: unknown): string {
  if (error instanceof Error) return error.message;
  if (typeof error === "string") return error;
  return "unknown_error";
}

export class ModerationActionError extends Error {
  readonly code: ModerationCallableErrorCode;
  readonly userMessage: string;
  readonly debugMessage: string;
  readonly context: ModerationActionContext;

  constructor(params: {
    context: ModerationActionContext;
    code: ModerationCallableErrorCode;
    userMessage: string;
    debugMessage: string;
  }) {
    super(params.debugMessage);
    this.name = "ModerationActionError";
    this.context = params.context;
    this.code = params.code;
    this.userMessage = params.userMessage;
    this.debugMessage = params.debugMessage;
  }
}

function toModerationActionError(
  context: ModerationActionContext,
  error: unknown,
): ModerationActionError {
  const code = normalizeCallableErrorCode(error);
  return new ModerationActionError({
    context,
    code,
    userMessage: mapCallableErrorToUserMessage(context, code),
    debugMessage: extractDebugMessage(error),
  });
}

export async function setUserLifecycleStatus(params: {
  userId: string;
  targetStatus: UserLifecycleStatus;
  reason?: string;
}) {
  try {
    await setUserLifecycleStatusCallable({
      userId: params.userId,
      targetStatus: params.targetStatus,
      reason: params.reason || null,
    });
  } catch (error) {
    throw toModerationActionError("user_lifecycle", error);
  }
}

export async function setKontenPublishStatus(params: {
  kontenId: string;
  targetStatus: ContentLifecycleStatus;
  reason?: string;
}) {
  if (!params.kontenId.trim() || !["draft", "published"].includes(params.targetStatus)) {
    throw new ModerationActionError({
      context: "content_publish",
      code: "invalid-argument",
      userMessage: mapCallableErrorToUserMessage("content_publish", "invalid-argument"),
      debugMessage: "invalid kontenId/targetStatus",
    });
  }

  const kontenId = params.kontenId.trim();
  const targetStatus = params.targetStatus;

  try {
    const kontenRef = doc(firestore, "konten", kontenId);
    const kontenSnap = await getDoc(kontenRef);
    if (!kontenSnap.exists()) {
      throw new ModerationActionError({
        context: "content_publish",
        code: "not-found",
        userMessage: mapCallableErrorToUserMessage("content_publish", "not-found"),
        debugMessage: `konten/${kontenId} not found`,
      });
    }

    const session = getDesktopSession();
    const actorUid = session?.uid || "unknown";
    const actorName = session?.displayName || session?.email || "Admin";
    const reason =
      params.reason?.trim() ||
      (targetStatus === "published" ? "Published by admin desktop" : "Unpublished by admin desktop");
    const actionType = targetStatus === "published" ? "PUBLISH_CONTENT" : "UNPUBLISH_CONTENT";

    await updateDoc(kontenRef, {
      status: targetStatus,
      moderationReason: reason,
      moderatedByUid: actorUid,
      moderatedByRole: "admin",
      moderatedAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
      publishedAt: targetStatus === "published" ? serverTimestamp() : null,
    });

    await addDoc(collection(firestore, "admin_audit_logs"), {
      actorUid,
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
      createdAt: serverTimestamp(),
      userId: actorUid,
      userRole: "admin",
      userName: actorName,
      action: actionType,
      target: "konten",
      details: `${actionType} ${kontenId}: ${reason}`,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    if (error instanceof ModerationActionError) {
      throw error;
    }
    throw toModerationActionError("content_publish", error);
  }
}
