import { initializeApp, type FirebaseApp } from "firebase/app";
import { getAuth, type Auth } from "firebase/auth";
import {
  connectFunctionsEmulator,
  getFunctions,
  type Functions,
} from "firebase/functions";
import { getFirestore, type Firestore } from "firebase/firestore";
import {
  buildFirebaseMissingEnvMessage,
  getMissingFirebaseEnvKeys,
  isFirebaseEnvReady,
} from "./env";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
};

const missingEnvKeys = getMissingFirebaseEnvKeys();
if (missingEnvKeys.length > 0 && import.meta.env.DEV) {
  console.warn(
    `[ACONSIA] Firebase env belum lengkap: ${missingEnvKeys.join(", ")}. ` +
      "Desktop auth mungkin tidak berjalan sampai .env dilengkapi.",
  );
}

let appInstance: FirebaseApp | null = null;
let firebaseAuthInstance: Auth | null = null;
let firestoreInstance: Firestore | null = null;
let firebaseFunctionsInstance: Functions | null = null;
let firebaseInitErrorMessage = "";

function initFirebaseSafely() {
  if (!isFirebaseEnvReady()) {
    firebaseInitErrorMessage = buildFirebaseMissingEnvMessage();
    return;
  }

  try {
    appInstance = initializeApp(firebaseConfig);
    firebaseAuthInstance = getAuth(appInstance);
    firestoreInstance = getFirestore(appInstance);
    firebaseFunctionsInstance = getFunctions(
      appInstance,
      import.meta.env.VITE_FIREBASE_FUNCTIONS_REGION || "us-central1",
    );

    if (import.meta.env.VITE_USE_FIREBASE_EMULATORS === "true") {
      connectFunctionsEmulator(firebaseFunctionsInstance, "127.0.0.1", 5001);
    }
  } catch (error) {
    firebaseInitErrorMessage =
      error instanceof Error
        ? error.message
        : "Firebase init error tidak diketahui.";

    if (import.meta.env.DEV) {
      console.error("[ACONSIA] Firebase init failed:", error);
    }
  }
}

initFirebaseSafely();

export function getFirebaseInitErrorMessage(): string {
  return firebaseInitErrorMessage;
}

export function isFirebaseClientReady(): boolean {
  return !!appInstance && !!firebaseAuthInstance && !!firestoreInstance && !!firebaseFunctionsInstance;
}

export const firebaseAuth = firebaseAuthInstance as Auth;
export const firestore = firestoreInstance as Firestore;
export const firebaseFunctions = firebaseFunctionsInstance as Functions;
