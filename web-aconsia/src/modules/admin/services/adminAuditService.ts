import { collection, getDocs, orderBy, query, limit } from "firebase/firestore";
import { firestore } from "../../../core/firebase/client";

export interface AdminAuditLog {
  id: string;
  timestamp: string;
  userId: string;
  userRole: "patient" | "doctor" | "admin";
  userName: string;
  action: string;
  target: string;
  details: string;
  ipAddress?: string;
  sessionId?: string;
  status: "success" | "failed";
}

export async function getAdminAuditLogs(maxRows = 500): Promise<AdminAuditLog[]> {
  const logsRef = collection(firestore, "admin_audit_logs");
  const logsQuery = query(logsRef, orderBy("createdAt", "desc"), limit(maxRows));
  const snapshot = await getDocs(logsQuery);

  return snapshot.docs.map((docSnap) => {
    const data = docSnap.data() as Record<string, unknown>;

    const roleRaw = String(data.userRole || data.actorRole || "admin");
    const role =
      roleRaw === "patient" || roleRaw === "doctor" || roleRaw === "admin"
        ? roleRaw
        : "admin";

    const statusRaw = String(data.status || "success");
    const status = statusRaw === "failed" ? "failed" : "success";

    return {
      id: docSnap.id,
      timestamp: String(data.timestamp || data.createdAt || new Date().toISOString()),
      userId: String(data.userId || data.actorUid || "-"),
      userRole: role,
      userName: String(data.userName || data.actorName || "System"),
      action: String(data.action || data.actionType || "UNKNOWN"),
      target: String(data.target || data.entityType || "-"),
      details: String(data.details || data.message || "-"),
      ipAddress: data.ipAddress ? String(data.ipAddress) : undefined,
      sessionId: data.sessionId ? String(data.sessionId) : undefined,
      status,
    };
  });
}
