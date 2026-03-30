// AUDIT TRAIL SYSTEM
// Track all user activities for security & legal compliance

export interface AuditLog {
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

class AuditTrailSystem {
  private storageKey = "auditLogs";
  private sessionId: string;

  constructor() {
    this.sessionId = this.generateSessionId();
  }

  private generateSessionId(): string {
    return `session-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }

  private generateId(): string {
    return `audit-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Log user activity
   */
  log(params: {
    userId: string;
    userRole: "patient" | "doctor" | "admin";
    userName: string;
    action: string;
    target: string;
    details: string;
    status?: "success" | "failed";
  }): void {
    const log: AuditLog = {
      id: this.generateId(),
      timestamp: new Date().toISOString(),
      userId: params.userId,
      userRole: params.userRole,
      userName: params.userName,
      action: params.action,
      target: params.target,
      details: params.details,
      ipAddress: this.getMockIPAddress(),
      sessionId: this.sessionId,
      status: params.status || "success",
    };

    this.saveToDB(log);
  }

  /**
   * Save log to localStorage (simulate database)
   */
  private saveToDB(log: AuditLog): void {
    const existingLogs = this.getAllLogs();
    existingLogs.unshift(log); // Latest first

    // Keep only last 1000 logs to prevent storage overflow
    const trimmedLogs = existingLogs.slice(0, 1000);

    localStorage.setItem(this.storageKey, JSON.stringify(trimmedLogs));

    // Also log to console for debugging
    console.log(`[AUDIT] ${log.action}`, log);
  }

  /**
   * Get all audit logs
   */
  getAllLogs(): AuditLog[] {
    const logs = localStorage.getItem(this.storageKey);
    return logs ? JSON.parse(logs) : [];
  }

  /**
   * Get logs by user
   */
  getLogsByUser(userId: string): AuditLog[] {
    return this.getAllLogs().filter((log) => log.userId === userId);
  }

  /**
   * Get logs by role
   */
  getLogsByRole(userRole: "patient" | "doctor" | "admin"): AuditLog[] {
    return this.getAllLogs().filter((log) => log.userRole === userRole);
  }

  /**
   * Get logs by action
   */
  getLogsByAction(action: string): AuditLog[] {
    return this.getAllLogs().filter((log) => log.action === action);
  }

  /**
   * Get logs by date range
   */
  getLogsByDateRange(startDate: Date, endDate: Date): AuditLog[] {
    return this.getAllLogs().filter((log) => {
      const logDate = new Date(log.timestamp);
      return logDate >= startDate && logDate <= endDate;
    });
  }

  /**
   * Export logs as JSON
   */
  exportLogsAsJSON(): string {
    return JSON.stringify(this.getAllLogs(), null, 2);
  }

  /**
   * Export logs as CSV
   */
  exportLogsAsCSV(): string {
    const logs = this.getAllLogs();
    if (logs.length === 0) return "";

    const headers = [
      "Timestamp",
      "User ID",
      "User Role",
      "User Name",
      "Action",
      "Target",
      "Details",
      "Status",
      "IP Address",
      "Session ID",
    ];

    const rows = logs.map((log) => [
      new Date(log.timestamp).toLocaleString("id-ID"),
      log.userId,
      log.userRole,
      log.userName,
      log.action,
      log.target,
      log.details,
      log.status,
      log.ipAddress || "-",
      log.sessionId || "-",
    ]);

    const csvContent = [headers, ...rows].map((row) => row.map((cell) => `"${cell}"`).join(",")).join("\n");

    return csvContent;
  }

  /**
   * Clear all logs (admin only)
   */
  clearAllLogs(): void {
    localStorage.removeItem(this.storageKey);
    console.warn("[AUDIT] All logs cleared!");
  }

  /**
   * Get mock IP address (for demo purposes)
   */
  private getMockIPAddress(): string {
    return `192.168.${Math.floor(Math.random() * 255)}.${Math.floor(Math.random() * 255)}`;
  }

  /**
   * Get activity summary
   */
  getActivitySummary(): {
    totalLogs: number;
    byRole: Record<string, number>;
    byAction: Record<string, number>;
    recentActivity: AuditLog[];
  } {
    const logs = this.getAllLogs();

    const byRole: Record<string, number> = {};
    const byAction: Record<string, number> = {};

    logs.forEach((log) => {
      byRole[log.userRole] = (byRole[log.userRole] || 0) + 1;
      byAction[log.action] = (byAction[log.action] || 0) + 1;
    });

    return {
      totalLogs: logs.length,
      byRole,
      byAction,
      recentActivity: logs.slice(0, 10),
    };
  }
}

// Singleton instance
export const auditTrail = new AuditTrailSystem();

// ========================================
// PREDEFINED ACTION TYPES
// ========================================

export const AUDIT_ACTIONS = {
  // Authentication
  LOGIN: "LOGIN",
  LOGOUT: "LOGOUT",
  LOGIN_FAILED: "LOGIN_FAILED",
  REGISTER: "REGISTER",

  // Patient Actions
  VIEW_MATERIAL: "VIEW_MATERIAL",
  COMPLETE_MATERIAL: "COMPLETE_MATERIAL",
  START_QUIZ: "START_QUIZ",
  COMPLETE_QUIZ: "COMPLETE_QUIZ",
  CHAT_AI: "CHAT_AI",
  SCHEDULE_CONSENT: "SCHEDULE_CONSENT",
  COMPLETE_ASSESSMENT: "COMPLETE_ASSESSMENT",
  VIEW_PROFILE: "VIEW_PROFILE",
  UPDATE_PROFILE: "UPDATE_PROFILE",
  CONTACT_DOCTOR: "CONTACT_DOCTOR",

  // Doctor Actions
  APPROVE_PATIENT: "APPROVE_PATIENT",
  REJECT_PATIENT: "REJECT_PATIENT",
  ASSIGN_ANESTHESIA: "ASSIGN_ANESTHESIA",
  VIEW_PATIENT_LIST: "VIEW_PATIENT_LIST",
  VIEW_PATIENT_DETAIL: "VIEW_PATIENT_DETAIL",
  UPDATE_PATIENT_DATA: "UPDATE_PATIENT_DATA",
  ADD_CONTENT: "ADD_CONTENT",
  EDIT_CONTENT: "EDIT_CONTENT",
  DELETE_CONTENT: "DELETE_CONTENT",
  MONITOR_PATIENT: "MONITOR_PATIENT",

  // Admin Actions
  VIEW_DASHBOARD: "VIEW_DASHBOARD",
  VIEW_REPORTS: "VIEW_REPORTS",
  EXPORT_DATA: "EXPORT_DATA",
  VIEW_AUDIT_LOG: "VIEW_AUDIT_LOG",
  MANAGE_USERS: "MANAGE_USERS",
  SYSTEM_CONFIG: "SYSTEM_CONFIG",

  // Data Actions
  CREATE: "CREATE",
  READ: "READ",
  UPDATE: "UPDATE",
  DELETE: "DELETE",
  EXPORT: "EXPORT",
  IMPORT: "IMPORT",
};

// ========================================
// HELPER FUNCTIONS FOR COMMON LOGS
// ========================================

export function logLogin(userId: string, userRole: "patient" | "doctor" | "admin", userName: string) {
  auditTrail.log({
    userId,
    userRole,
    userName,
    action: AUDIT_ACTIONS.LOGIN,
    target: "System",
    details: `${userRole} logged in successfully`,
    status: "success",
  });
}

export function logLogout(userId: string, userRole: "patient" | "doctor" | "admin", userName: string) {
  auditTrail.log({
    userId,
    userRole,
    userName,
    action: AUDIT_ACTIONS.LOGOUT,
    target: "System",
    details: `${userRole} logged out`,
    status: "success",
  });
}

export function logMaterialView(
  userId: string,
  userName: string,
  materialId: string,
  materialTitle: string
) {
  auditTrail.log({
    userId,
    userRole: "patient",
    userName,
    action: AUDIT_ACTIONS.VIEW_MATERIAL,
    target: `Material: ${materialId}`,
    details: `Viewed material: ${materialTitle}`,
    status: "success",
  });
}

export function logMaterialComplete(
  userId: string,
  userName: string,
  materialId: string,
  materialTitle: string
) {
  auditTrail.log({
    userId,
    userRole: "patient",
    userName,
    action: AUDIT_ACTIONS.COMPLETE_MATERIAL,
    target: `Material: ${materialId}`,
    details: `Completed material: ${materialTitle}`,
    status: "success",
  });
}

export function logDoctorApproval(
  doctorId: string,
  doctorName: string,
  patientId: string,
  patientName: string,
  anesthesiaType: string
) {
  auditTrail.log({
    userId: doctorId,
    userRole: "doctor",
    userName: doctorName,
    action: AUDIT_ACTIONS.APPROVE_PATIENT,
    target: `Patient: ${patientId}`,
    details: `Approved patient ${patientName} with ${anesthesiaType}`,
    status: "success",
  });
}

export function logScheduleConsent(
  userId: string,
  userName: string,
  scheduledDate: string
) {
  auditTrail.log({
    userId,
    userRole: "patient",
    userName,
    action: AUDIT_ACTIONS.SCHEDULE_CONSENT,
    target: "Informed Consent",
    details: `Scheduled consent signature for ${scheduledDate}`,
    status: "success",
  });
}

export function logAssessmentComplete(userId: string, userName: string) {
  auditTrail.log({
    userId,
    userRole: "patient",
    userName,
    action: AUDIT_ACTIONS.COMPLETE_ASSESSMENT,
    target: "Pre-operative Assessment",
    details: "Completed pre-operative assessment form",
    status: "success",
  });
}

export function logExportData(
  userId: string,
  userRole: "doctor" | "admin",
  userName: string,
  dataType: string
) {
  auditTrail.log({
    userId,
    userRole,
    userName,
    action: AUDIT_ACTIONS.EXPORT_DATA,
    target: `Data: ${dataType}`,
    details: `Exported ${dataType} data`,
    status: "success",
  });
}
