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
  const actorUid = String(args.actorUid || "system-cleanup").trim();

  await ensureApp();
  const db = admin.firestore();
  const now = admin.firestore.FieldValue.serverTimestamp();

  const assignmentSnap = await db.collection("assignments").get();
  let scanned = 0;
  const targets = [];

  for (const assignmentDoc of assignmentSnap.docs) {
    scanned += 1;
    const assignment = assignmentDoc.data() || {};
    const status = String(assignment.status || "").toLowerCase();
    if (status !== "assigned" && status !== "active") continue;

    const kontenId = String(assignment.kontenId || "").trim();
    if (!kontenId) continue;

    const kontenSnap = await db.collection("konten").doc(kontenId).get();
    if (!kontenSnap.exists) {
      targets.push({
        assignmentId: assignmentDoc.id,
        kontenId,
        reason: "konten_not_found",
      });
      continue;
    }

    const kontenStatus = String(kontenSnap.data()?.status || "")
      .trim()
      .toLowerCase();
    if (kontenStatus !== "published") {
      targets.push({
        assignmentId: assignmentDoc.id,
        kontenId,
        reason: `konten_status_${kontenStatus || "unknown"}`,
      });
    }
  }

  console.log("=======================================");
  console.log(`MODE     : ${apply ? "APPLY" : "DRY-RUN"}`);
  console.log(`SCANNED  : ${scanned}`);
  console.log(`TARGETS  : ${targets.length}`);
  targets.slice(0, 20).forEach((item) => {
    console.log(`- ${item.assignmentId} | ${item.kontenId} | ${item.reason}`);
  });
  if (targets.length > 20) {
    console.log(`... ${targets.length - 20} more`);
  }
  console.log("=======================================");

  if (!apply || targets.length === 0) return;

  let updated = 0;
  for (let i = 0; i < targets.length; i += 400) {
    const batch = db.batch();
    const chunk = targets.slice(i, i + 400);
    for (const item of chunk) {
      const ref = db.collection("assignments").doc(item.assignmentId);
      batch.set(
        ref,
        {
          status: "cancelled",
          cancelledAt: now,
          cancelledBy: actorUid,
          cancelReason: "linked_content_not_published",
          updatedAt: now,
        },
        { merge: true },
      );
      updated += 1;
    }
    await batch.commit();
  }

  console.log(`APPLY DONE: ${updated} assignment(s) cancelled.`);
}

main().catch((error) => {
  console.error("cancel-draft-assignments failed:", error?.message || error);
  process.exit(1);
});

