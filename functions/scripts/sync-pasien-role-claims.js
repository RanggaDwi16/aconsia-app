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

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const apply = String(args.apply || "false").toLowerCase() === "true";

  await ensureApp();
  const db = admin.firestore();
  const auth = admin.auth();

  const usersSnap = await db
    .collection("users")
    .where("role", "in", ["pasien", "patient"])
    .get();

  const uids = usersSnap.docs.map((doc) => doc.id);

  console.log("=======================================");
  console.log(`MODE               : ${apply ? "APPLY" : "DRY-RUN"}`);
  console.log(`PASIEN FROM users  : ${usersSnap.size}`);
  console.log(`UNIQUE PASIEN UID  : ${uids.length}`);
  console.log("=======================================");

  if (!apply) {
    for (const uid of uids) console.log(`- ${uid}`);
    return;
  }

  let updated = 0;
  let skipped = 0;
  const failed = [];

  for (const uid of uids) {
    try {
      const user = await auth.getUser(uid);
      const existingClaims = user.customClaims || {};
      if (existingClaims.role === "pasien") {
        skipped += 1;
        continue;
      }

      await auth.setCustomUserClaims(uid, {
        ...existingClaims,
        role: "pasien",
      });
      updated += 1;
      console.log(`UPDATED claim role=pasien => ${uid}`);
    } catch (error) {
      failed.push({
        uid,
        error: error?.message || String(error),
      });
      console.error(`FAILED ${uid}: ${error?.message || error}`);
    }
  }

  console.log("=======================================");
  console.log(`UPDATED : ${updated}`);
  console.log(`SKIPPED : ${skipped}`);
  console.log(`FAILED  : ${failed.length}`);
  if (failed.length > 0) {
    console.log("FAILED UID LIST:");
    failed.forEach((item) => console.log(`- ${item.uid}: ${item.error}`));
  }
  console.log("=======================================");
}

main().catch((error) => {
  console.error("sync-pasien-role-claims failed:", error?.message || error);
  process.exit(1);
});
