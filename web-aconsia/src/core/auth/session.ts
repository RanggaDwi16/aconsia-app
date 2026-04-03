import type { DesktopSessionUser, DesktopRole } from "./types";
import { onAuthStateChanged } from "firebase/auth";
import { doc, getDoc } from "firebase/firestore";
import { firebaseAuth, firestore, isFirebaseClientReady } from "../firebase/client";
import { isFirebaseEnvReady } from "../firebase/env";

const SESSION_KEY = "aconsia_desktop_session";

function mapRole(role: unknown): DesktopRole | null {
  if (role === "dokter" || role === "doctor") return "doctor";
  if (role === "admin") return "admin";
  return null;
}

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

export async function hydrateDesktopSessionFromFirebaseAuth(): Promise<DesktopSessionUser | null> {
  const existingSession = getDesktopSession();

  if (!isFirebaseEnvReady() || !isFirebaseClientReady()) {
    return existingSession;
  }

  const firebaseUser = firebaseAuth.currentUser;
  if (!firebaseUser) {
    clearDesktopSession();
    return null;
  }

  try {
    let role: DesktopRole | null = null;
    let profileData: Record<string, unknown> = {};

    // 1) Prefer token claim role when available (admin bootstrap path).
    const tokenResult = await firebaseUser.getIdTokenResult();
    role = mapRole(tokenResult.claims?.role);

    // 2) Fallback to users/{uid}.role (doctor self-register path).
    if (!role) {
      const userSnap = await getDoc(doc(firestore, "users", firebaseUser.uid));
      if (userSnap.exists()) {
        profileData = userSnap.data() as Record<string, unknown>;
        role = mapRole(profileData.role);
      }
    }

    // 3) Keep existing role if same uid and still valid.
    if (!role && existingSession?.uid === firebaseUser.uid) {
      role = existingSession.role;
    }

    if (!role) {
      clearDesktopSession();
      return null;
    }

    const hydratedSession: DesktopSessionUser = {
      uid: firebaseUser.uid,
      email:
        String(
          profileData.email ||
            firebaseUser.email ||
            existingSession?.email ||
            "",
        ),
      role,
      displayName: String(
        profileData.name ||
          profileData.displayName ||
          firebaseUser.displayName ||
          existingSession?.displayName ||
          "",
      ),
    };

    saveDesktopSession(hydratedSession);
    return hydratedSession;
  } catch {
    // Keep existing session on transient network/read failures.
    return existingSession;
  }
}

export async function resolveDesktopSession(): Promise<DesktopSessionUser | null> {
  const localSession = getDesktopSession();
  if (!isFirebaseEnvReady() || !isFirebaseClientReady()) {
    return localSession;
  }

  if (firebaseAuth.currentUser) {
    return hydrateDesktopSessionFromFirebaseAuth();
  }

  // Wait for the first auth state restoration event to avoid race on refresh/new tab.
  await new Promise<void>((resolve) => {
    const timeout = setTimeout(() => {
      unsubscribe();
      resolve();
    }, 2000);

    const unsubscribe = onAuthStateChanged(firebaseAuth, () => {
      clearTimeout(timeout);
      unsubscribe();
      resolve();
    });
  });

  return hydrateDesktopSessionFromFirebaseAuth();
}

export function subscribeDesktopSessionSync() {
  if (!isFirebaseEnvReady() || !isFirebaseClientReady()) {
    return () => {};
  }

  return onAuthStateChanged(firebaseAuth, async (firebaseUser) => {
    if (!firebaseUser) {
      clearDesktopSession();
      return;
    }

    await hydrateDesktopSessionFromFirebaseAuth();
  });
}
