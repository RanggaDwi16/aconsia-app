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

function normalizeRole(role) {
  const raw = String(role || "")
    .trim()
    .toLowerCase();
  if (raw === "doctor" || raw === "dokter") return "dokter";
  if (raw === "patient" || raw === "pasien") return "pasien";
  if (raw === "admin") return "admin";
  return raw;
}

function ensurePhone(raw) {
  const phone = String(raw || "").trim();
  const ok = /^(\+62|62|0)[0-9]{9,12}$/.test(phone);
  return ok ? phone : "081234567890";
}

async function ensureApp() {
  if (admin.apps.length > 0) return;
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const apply = String(args.apply || "false").toLowerCase() === "true";

  await ensureApp();
  const db = admin.firestore();
  const now = admin.firestore.FieldValue.serverTimestamp();

  const usersSnap = await db.collection("users").get();
  const plans = [];

  for (const userDoc of usersSnap.docs) {
    const uid = userDoc.id;
    const user = userDoc.data() || {};
    const role = normalizeRole(user.role);

    const baseUserPatch = {
      uid,
      role: role || "pasien",
      updatedAt: now,
    };

    if (!user.createdAt) {
      baseUserPatch.createdAt = now;
    }

    if (role === "dokter") {
      const profileSnap = await db.collection("dokter_profiles").doc(uid).get();
      const profile = profileSnap.exists ? profileSnap.data() || {} : {};

      const fullName =
        String(user.name || user.displayName || profile.fullName || profile.nama || "Dokter")
          .trim();
      const email = String(user.email || profile.email || "").trim().toLowerCase();
      const phone = ensurePhone(user.phone || profile.phoneNumber || profile.noTelepon);
      const hospital = String(
        user.hospital || profile.hospitalName || profile.namaRumahSakit || "RS Aconsia",
      ).trim();
      const sip = String(user.sipNumber || profile.sipNumber || "SIP/UNKNOWN").trim();
      const str = String(user.strNumber || profile.strNumber || "STR/UNKNOWN").trim();

      const userPatch = {
        ...baseUserPatch,
        email,
        name: fullName,
        displayName: fullName,
        status: "active",
        phone,
        hospital,
        specialization: "Anestesiologi",
        sipNumber: sip,
        strNumber: str,
        isProfileCompleted: true,
      };

      const profilePatch = {
        uid,
        email,
        fullName,
        nama: fullName,
        phoneNumber: phone,
        noTelepon: phone,
        hospitalName: hospital,
        namaRumahSakit: hospital,
        specialization: "Anestesiologi",
        sipNumber: sip,
        strNumber: str,
        status: "active",
        updatedAt: now,
      };

      if (!profile.createdAt) {
        profilePatch.createdAt = now;
      }

      plans.push({
        uid,
        role,
        userPatch,
        profilePatch,
      });
      continue;
    }

    if (role === "pasien") {
      const fullName = String(user.name || user.displayName || "Pasien").trim();
      const email = String(user.email || "").trim().toLowerCase();
      const userPatch = {
        ...baseUserPatch,
        email,
        name: fullName,
        displayName: fullName,
        status: String(user.status || "active"),
        isProfileCompleted: Boolean(user.isProfileCompleted),
      };

      plans.push({
        uid,
        role,
        userPatch,
      });
      continue;
    }

    if (role === "admin") {
      const fullName = String(user.name || user.displayName || "Admin").trim();
      const email = String(user.email || "").trim().toLowerCase();
      const userPatch = {
        ...baseUserPatch,
        email,
        name: fullName,
        displayName: fullName,
        status: "active",
      };

      plans.push({
        uid,
        role,
        userPatch,
      });
    }
  }

  console.log("=======================================");
  console.log(`MODE   : ${apply ? "APPLY" : "DRY-RUN"}`);
  console.log(`USERS  : ${usersSnap.size}`);
  console.log(`PLANS  : ${plans.length}`);
  for (const plan of plans) {
    console.log(`- ${plan.uid} (${plan.role || "unknown"})`);
  }
  console.log("=======================================");

  if (!apply) return;

  const batch = db.batch();
  for (const plan of plans) {
    batch.set(db.collection("users").doc(plan.uid), plan.userPatch, { merge: true });
    if (plan.profilePatch) {
      batch.set(db.collection("dokter_profiles").doc(plan.uid), plan.profilePatch, {
        merge: true,
      });
    }
  }
  await batch.commit();

  console.log(`APPLY DONE: ${plans.length} plan(s) committed.`);
}

main().catch((error) => {
  console.error("normalize-mobile-web-contract failed:", error?.message || error);
  process.exit(1);
});

