import { userMessages } from "../../app/copy/userMessages";

const REQUIRED_FIREBASE_ENV_KEYS = [
  "VITE_FIREBASE_API_KEY",
  "VITE_FIREBASE_AUTH_DOMAIN",
  "VITE_FIREBASE_PROJECT_ID",
  "VITE_FIREBASE_APP_ID",
] as const;

export type RequiredFirebaseEnvKey = (typeof REQUIRED_FIREBASE_ENV_KEYS)[number];

function getEnvValue(key: RequiredFirebaseEnvKey): string {
  const value = import.meta.env[key];
  return typeof value === "string" ? value.trim() : "";
}

export function getMissingFirebaseEnvKeys(): RequiredFirebaseEnvKey[] {
  return REQUIRED_FIREBASE_ENV_KEYS.filter((key) => !getEnvValue(key));
}

export function isFirebaseEnvReady(): boolean {
  return getMissingFirebaseEnvKeys().length === 0;
}

export function buildFirebaseMissingEnvMessage(): string {
  const missing = getMissingFirebaseEnvKeys();
  if (missing.length === 0) {
    return "";
  }

  return userMessages.auth.missingConfig;
}
