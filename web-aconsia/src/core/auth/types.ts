export type DesktopRole = "doctor" | "admin";

export interface DesktopSessionUser {
  uid: string;
  email: string;
  role: DesktopRole;
  displayName?: string;
}
