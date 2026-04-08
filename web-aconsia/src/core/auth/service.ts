import { signInWithEmailAndPassword, signOut } from "firebase/auth";
import { FirebaseError } from "firebase/app";
import { doc, getDoc } from "firebase/firestore";
import {
  firebaseAuth,
  firestore,
  getFirebaseInitErrorMessage,
  isFirebaseClientReady,
} from "../firebase/client";
import { saveDesktopSession, clearDesktopSession } from "./session";
import type { DesktopRole } from "./types";
import {
  buildFirebaseMissingEnvMessage,
  isFirebaseEnvReady,
} from "../firebase/env";
import { userMessages } from "../../app/copy/userMessages";

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

function mapFirebaseSignInError(error: unknown): string | null {
  if (!(error instanceof FirebaseError)) return null;

  switch (error.code) {
    case "auth/invalid-credential":
    case "auth/wrong-password":
    case "auth/user-not-found":
      return "Email atau password tidak sesuai.";
    case "auth/invalid-email":
      return "Format email tidak valid.";
    case "auth/user-disabled":
      return "Akun ini dinonaktifkan. Hubungi admin.";
    case "auth/too-many-requests":
      return "Terlalu banyak percobaan login. Coba lagi beberapa saat.";
    case "auth/network-request-failed":
      return "Koneksi internet bermasalah. Coba periksa jaringan Anda.";
    case "permission-denied":
      return userMessages.auth.accessDenied;
    default:
      return null;
  }
}

export async function signInDesktop(params: {
  email: string;
  password: string;
  expectedRole: DesktopRole;
}) {
  if (!isFirebaseEnvReady()) {
    throw new DesktopAuthError(buildFirebaseMissingEnvMessage());
  }

  if (!isFirebaseClientReady()) {
    const initErrorMessage = getFirebaseInitErrorMessage();
    if (initErrorMessage.includes("auth/invalid-api-key")) {
      throw new DesktopAuthError(userMessages.auth.serviceUnavailable);
    }

    throw new DesktopAuthError(initErrorMessage || userMessages.auth.serviceUnavailable);
  }

  const { email, password, expectedRole } = params;

  try {
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
      throw new DesktopAuthError(userMessages.auth.profileNotFound);
    }

    const data = userSnap.data();
    const role = mapRole(data.role);

    if (!role) {
      await signOut(firebaseAuth);
      throw new DesktopAuthError(userMessages.auth.invalidRole);
    }

    if (role !== expectedRole) {
      await signOut(firebaseAuth);
      throw new DesktopAuthError(
        expectedRole === "doctor"
          ? userMessages.auth.wrongDoctorRole
          : userMessages.auth.wrongAdminRole,
      );
    }

    saveDesktopSession({
      uid,
      email: data.email || credential.user.email || email,
      role,
      displayName: data.name || data.displayName,
    });

    return role;
  } catch (error) {
    if (error instanceof DesktopAuthError) {
      throw error;
    }

    const mappedErrorMessage = mapFirebaseSignInError(error);
    if (mappedErrorMessage) {
      throw new DesktopAuthError(mappedErrorMessage);
    }

    throw error;
  }
}

export async function signOutDesktop() {
  await signOut(firebaseAuth);
  clearDesktopSession();
}
