import { httpsCallable } from "firebase/functions";
import { firebaseFunctions } from "../../../core/firebase/client";

type AuditRole = "patient" | "doctor" | "admin";

const writeAdminAuditLogCallable = httpsCallable(
  firebaseFunctions,
  "writeAdminAuditLog",
);

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
    // Non-blocking: workflow should continue, immutable audit is server-side callable only
    console.warn(
      "[AuditWriter] Callable audit write failed",
      error,
    );
  }
}
