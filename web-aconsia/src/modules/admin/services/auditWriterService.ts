import { addDoc, collection, serverTimestamp } from "firebase/firestore";
import { httpsCallable } from "firebase/functions";
import { firebaseFunctions, firestore } from "../../../core/firebase/client";

type AuditRole = "patient" | "doctor" | "admin";

const writeAdminAuditLogCallable = httpsCallable(
  firebaseFunctions,
  "writeAdminAuditLog",
);

function legacyAuditFallbackEnabled() {
  return import.meta.env.VITE_ALLOW_LEGACY_AUDIT_FALLBACK === "true";
}

export async function writeAuditLog(params: {
  actorUid: string;
  actorRole: AuditRole;
  actorName: string;
  actionType: string;
  entityType: string;
  entityId?: string;
  message: string;
  status?: "success" | "failed";
}) {
  const {
    actorUid,
    actorRole,
    actorName,
    actionType,
    entityType,
    entityId,
    message,
    status = "success",
  } = params;

  try {
    await writeAdminAuditLogCallable({
      actorUid,
      actorRole,
      actorName,
      actionType,
      entityType,
      entityId: entityId || null,
      message,
      status,
    });
  } catch (error) {
    if (!legacyAuditFallbackEnabled()) {
      // Non-blocking: workflow should continue, but immutable audit requires backend function
      console.warn(
        "[AuditWriter] Callable audit write failed and fallback disabled",
        error,
      );
      return;
    }

    try {
      await addDoc(collection(firestore, "admin_audit_logs"), {
        actorUid,
        actorRole,
        actorName,
        actionType,
        entityType,
        entityId: entityId || null,
        message,
        status,
        createdAt: serverTimestamp(),
        // compatibility fields for current admin UI
        userId: actorUid,
        userRole: actorRole,
        userName: actorName,
        action: actionType,
        target: entityType,
        details: message,
        timestamp: new Date().toISOString(),
      });
    } catch (fallbackError) {
      console.warn(
        "[AuditWriter] Fallback direct audit write failed",
        fallbackError,
      );
    }
  }
}
