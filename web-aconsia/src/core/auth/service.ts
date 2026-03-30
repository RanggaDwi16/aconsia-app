import { signInWithEmailAndPassword, signOut } from "firebase/auth";
import { doc, getDoc } from "firebase/firestore";
import { firebaseAuth, firestore } from "../firebase/client";
import { saveDesktopSession, clearDesktopSession } from "./session";
import type { DesktopRole } from "./types";

export class DesktopAuthError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "DesktopAuthError";
  }
}

function mapRole(role: unknown): DesktopRole | null {
  if (role === "dokter") return "doctor";
  if (role === "admin") return "admin";
  if (role === "doctor") return "doctor";
  return null;
}

export async function signInDesktop(params: {
  email: string;
  password: string;
  expectedRole: DesktopRole;
}) {
  const { email, password, expectedRole } = params;

  const credential = await signInWithEmailAndPassword(
    firebaseAuth,
    email,
    password,
  );

  const uid = credential.user.uid;
  const userDocRef = doc(firestore, "users", uid);
  const userSnap = await getDoc(userDocRef);

  if (!userSnap.exists()) {
    await signOut(firebaseAuth);
    throw new DesktopAuthError(
      "Profil user tidak ditemukan di Firestore. Hubungi admin.",
    );
  }

  const data = userSnap.data();
  const role = mapRole(data.role);

  if (!role) {
    await signOut(firebaseAuth);
    throw new DesktopAuthError("Role user tidak valid.");
  }

  if (role !== expectedRole) {
    await signOut(firebaseAuth);
    throw new DesktopAuthError(
      expectedRole === "doctor"
        ? "Akun ini bukan role dokter."
        : "Akun ini bukan role admin.",
    );
  }

  saveDesktopSession({
    uid,
    email: data.email || credential.user.email || email,
    role,
    displayName: data.name || data.displayName,
  });

  return role;
}

export async function signOutDesktop() {
  await signOut(firebaseAuth);
  clearDesktopSession();
}
