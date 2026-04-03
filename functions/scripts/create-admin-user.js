#!/usr/bin/env node
/* eslint-disable no-console */
const admin = require("firebase-admin");

function parseArgs(argv) {
  const args = {};
  for (const raw of argv) {
    const [key, value] = raw.split("=");
    if (!key.startsWith("--")) continue;
    args[key.slice(2)] = value ?? "true";
  }
  return args;
}

async function ensureApp() {
  if (admin.apps.length > 0) return;
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });
}

async function getOrCreateUser(auth, { email, password, displayName }) {
  try {
    const user = await auth.getUserByEmail(email);
    return { user, created: false };
  } catch (error) {
    if (error?.code !== "auth/user-not-found") {
      throw error;
    }
  }

  const user = await auth.createUser({
    email,
    password,
    displayName,
    emailVerified: true,
    disabled: false,
  });
  return { user, created: true };
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const email = String(args.email || "").trim().toLowerCase();
  const password = String(args.password || "").trim();
  const name = String(args.name || "Admin Aconsia").trim();
  const uidArg = String(args.uid || "").trim();

  if (!email && !uidArg) {
    throw new Error(
      "Wajib isi salah satu: --email=<email> atau --uid=<uid>.",
    );
  }

  await ensureApp();
  const auth = admin.auth();
  const db = admin.firestore();

  let userRecord;
  let created = false;

  if (uidArg) {
    userRecord = await auth.getUser(uidArg);
  } else {
    if (!password) {
      throw new Error(
        "Jika pakai --email, parameter --password juga wajib diisi (min 6 karakter).",
      );
    }
    const result = await getOrCreateUser(auth, {
      email,
      password,
      displayName: name,
    });
    userRecord = result.user;
    created = result.created;
  }

  const uid = userRecord.uid;
  const normalizedEmail = (userRecord.email || email || "").toLowerCase();
  const displayName = userRecord.displayName || name;

  // Set custom claim so Firestore rules `request.auth.token.role` becomes admin.
  const existingClaims = userRecord.customClaims || {};
  await auth.setCustomUserClaims(uid, {
    ...existingClaims,
    role: "admin",
  });

  // Upsert users/{uid} profile to keep desktop app role lookup consistent.
  await db.collection("users").doc(uid).set(
    {
      uid,
      email: normalizedEmail,
      name: displayName,
      displayName,
      role: "admin",
      status: "active",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  console.log("=======================================");
  console.log("Admin account siap dipakai.");
  console.log(`UID      : ${uid}`);
  console.log(`Email    : ${normalizedEmail}`);
  console.log(`Created? : ${created ? "yes" : "no (existing user updated)"}`);
  console.log("Role claim: admin");
  console.log("Firestore : users/{uid}.role = admin");
  console.log("=======================================");
  console.log(
    "Jika user sedang login, lakukan logout/login ulang agar token baru (custom claim) terbaca.",
  );
}

main().catch((error) => {
  console.error("Gagal membuat/upgrade admin:", error?.message || error);
  process.exit(1);
});
