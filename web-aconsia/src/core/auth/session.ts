import type { DesktopSessionUser, DesktopRole } from "./types";

const SESSION_KEY = "aconsia_desktop_session";

export function saveDesktopSession(user: DesktopSessionUser) {
  localStorage.setItem(SESSION_KEY, JSON.stringify(user));
  // Backward compatibility for existing pages
  localStorage.setItem("userRole", user.role);

  if (user.role === "doctor") {
    localStorage.setItem(
      "currentDoctor",
      JSON.stringify({
        id: user.uid,
        email: user.email,
        name: user.displayName || "Dokter",
      }),
    );
  }

  if (user.role === "admin") {
    localStorage.setItem("userId", user.uid);
  }
}

export function getDesktopSession(): DesktopSessionUser | null {
  const raw = localStorage.getItem(SESSION_KEY);
  if (!raw) return null;

  try {
    return JSON.parse(raw) as DesktopSessionUser;
  } catch {
    clearDesktopSession();
    return null;
  }
}

export function hasDesktopRole(allowedRoles: DesktopRole[]): boolean {
  const session = getDesktopSession();
  return !!session && allowedRoles.includes(session.role);
}

export function clearDesktopSession() {
  localStorage.removeItem(SESSION_KEY);
  localStorage.removeItem("userRole");
  localStorage.removeItem("userId");
  localStorage.removeItem("currentDoctor");
}
