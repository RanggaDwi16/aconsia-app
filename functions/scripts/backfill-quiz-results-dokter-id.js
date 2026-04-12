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

function pickDokterId(data) {
  if (!data || typeof data !== "object") return "";
  const primary = String(data.dokterId || "").trim();
  if (primary) return primary;
  const fallback = String(data.assignedDokterId || "").trim();
  if (fallback) return fallback;
  return "";
}

async function resolveDokterIdByPasienId(db, pasienId) {
  const safePasienId = String(pasienId || "").trim();
  if (!safePasienId) return { dokterId: "", source: "missing_pasien_id" };

  const directDoc = await db.collection("pasien_profiles").doc(safePasienId).get();
  if (directDoc.exists) {
    const dokterId = pickDokterId(directDoc.data() || {});
    if (dokterId) {
      return {
        dokterId,
        source: "doc_id",
        profileDocId: directDoc.id,
      };
    }
  }

  const byUidSnap = await db
    .collection("pasien_profiles")
    .where("uid", "==", safePasienId)
    .limit(20)
    .get();
  for (const doc of byUidSnap.docs) {
    const dokterId = pickDokterId(doc.data() || {});
    if (dokterId) {
      return {
        dokterId,
        source: "uid_query",
        profileDocId: doc.id,
      };
    }
  }

  return { dokterId: "", source: "not_found" };
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const apply = String(args.apply || "false").toLowerCase() === "true";

  await ensureApp();
  const db = admin.firestore();

  const quizSnapshot = await db.collection("quiz_results").get();
  const patches = [];

  let alreadyFilled = 0;
  let missingPasienId = 0;
  let unresolvedDokter = 0;
  let ambiguousCandidates = 0;
  const anomalies = [];

  for (const doc of quizSnapshot.docs) {
    const data = doc.data() || {};
    const existingDokterId = String(data.dokterId || "").trim();
    if (existingDokterId) {
      alreadyFilled += 1;
      continue;
    }

    const pasienId = String(data.pasienId || "").trim();
    if (!pasienId) {
      missingPasienId += 1;
      anomalies.push({
        quizResultId: doc.id,
        issue: "missing_pasien_id",
      });
      continue;
    }

    const byUidCount = await db
      .collection("pasien_profiles")
      .where("uid", "==", pasienId)
      .count()
      .get();
    if ((byUidCount.data().count || 0) > 1) {
      ambiguousCandidates += 1;
    }

    const resolved = await resolveDokterIdByPasienId(db, pasienId);
    if (!resolved.dokterId) {
      unresolvedDokter += 1;
      anomalies.push({
        quizResultId: doc.id,
        pasienId,
        issue: resolved.source,
      });
      continue;
    }

    patches.push({
      ref: doc.ref,
      patch: {
        dokterId: resolved.dokterId,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      meta: {
        quizResultId: doc.id,
        pasienId,
        source: resolved.source,
      },
    });
  }

  console.log("=======================================");
  console.log(`MODE                     : ${apply ? "APPLY" : "DRY-RUN"}`);
  console.log(`QUIZ_RESULTS_TOTAL       : ${quizSnapshot.size}`);
  console.log(`ALREADY_HAS_DOKTER_ID    : ${alreadyFilled}`);
  console.log(`PATCHABLE_ROWS           : ${patches.length}`);
  console.log(`MISSING_PASIEN_ID        : ${missingPasienId}`);
  console.log(`UNRESOLVED_DOKTER_ID     : ${unresolvedDokter}`);
  console.log(`AMBIGUOUS_UID_CANDIDATES : ${ambiguousCandidates}`);
  console.log("=======================================");

  if (!apply) {
    patches.slice(0, 20).forEach((item) => {
      console.log(
        `- quiz=${item.meta.quizResultId} pasien=${item.meta.pasienId} source=${item.meta.source} dokterId=${item.patch.dokterId}`,
      );
    });
    if (patches.length > 20) {
      console.log(`... and ${patches.length - 20} more`);
    }
    if (anomalies.length > 0) {
      console.log("ANOMALIES (sample):");
      anomalies.slice(0, 20).forEach((row) => console.log(`- ${JSON.stringify(row)}`));
    }
    return;
  }

  let committed = 0;
  let failed = 0;
  for (let i = 0; i < patches.length; i += 400) {
    const chunk = patches.slice(i, i + 400);
    const batch = db.batch();
    for (const item of chunk) {
      batch.set(item.ref, item.patch, { merge: true });
    }
    try {
      await batch.commit();
      committed += chunk.length;
      console.log(`Committed ${committed}/${patches.length}`);
    } catch (error) {
      failed += chunk.length;
      console.error(`Commit chunk failed index=${i}:`, error?.message || error);
    }
  }

  console.log("=======================================");
  console.log(`UPDATED_OK               : ${committed}`);
  console.log(`UPDATED_FAILED           : ${failed}`);
  console.log(`ANOMALY_COUNT            : ${anomalies.length}`);
  if (anomalies.length > 0) {
    console.log("ANOMALIES (sample):");
    anomalies.slice(0, 50).forEach((row) => console.log(`- ${JSON.stringify(row)}`));
  }
  console.log("=======================================");
  console.log("DONE");
}

main().catch((error) => {
  console.error("backfill-quiz-results-dokter-id failed:", error?.message || error);
  process.exit(1);
});
