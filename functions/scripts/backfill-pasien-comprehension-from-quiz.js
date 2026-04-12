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

function toMillis(value) {
  if (!value) return 0;
  if (typeof value === "object" && typeof value.toMillis === "function") {
    try {
      return value.toMillis();
    } catch {
      return 0;
    }
  }
  if (typeof value === "string") {
    const parsed = Date.parse(value);
    return Number.isFinite(parsed) ? parsed : 0;
  }
  return 0;
}

function readMeta(questionResults) {
  if (!Array.isArray(questionResults) || questionResults.length === 0) {
    return {};
  }
  const maybeLast = questionResults[questionResults.length - 1];
  if (!maybeLast || typeof maybeLast !== "object") return {};
  const meta = maybeLast._meta;
  if (!meta || typeof meta !== "object") return {};
  return meta;
}

function parseScore(data) {
  const candidates = [
    data?.overallScore,
    data?.finalScore,
    data?.score,
    data?.comprehensionScore,
    data?.lastQuizScore,
  ];
  let fallback = 0;
  for (const candidate of candidates) {
    const parsed = Number(candidate);
    if (!Number.isFinite(parsed)) continue;
    const safe = Math.round(Math.max(0, Math.min(100, parsed)));
    if (safe > 0) return safe;
    fallback = safe;
  }
  return fallback;
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

  const quizSnap = await db.collection("quiz_results").get();
  const latestByPasien = new Map();
  let skippedMissingPasienId = 0;
  let skippedInvalidCompletedAt = 0;
  let invalidScoreRows = 0;

  for (const doc of quizSnap.docs) {
    const data = doc.data() || {};
    const pasienId = String(data.pasienId || "").trim();
    if (!pasienId) {
      skippedMissingPasienId += 1;
      continue;
    }

    const completedAtMs = toMillis(data.completedAt);
    if (completedAtMs <= 0) {
      skippedInvalidCompletedAt += 1;
    }
    const safeScore = parseScore(data);
    if (!Number.isFinite(safeScore)) {
      invalidScoreRows += 1;
    }
    const existing = latestByPasien.get(pasienId);
    if (!existing || completedAtMs > existing.completedAtMs) {
      latestByPasien.set(pasienId, {
        docId: doc.id,
        sessionId: String(data.sessionId || ""),
        overallScore: safeScore,
        completedAtMs,
        completedAt: data.completedAt || null,
        meta: readMeta(data.questionResults),
      });
    }
  }

  const plans = [];
  for (const [pasienId, latest] of latestByPasien.entries()) {
    const safeScore = Math.round(Math.max(0, Math.min(100, latest.overallScore || 0)));
    plans.push({
      pasienId,
      patch: {
        comprehensionScore: safeScore,
        lastQuizScore: safeScore,
        lastQuizCompletedAt: latest.completedAt || admin.firestore.FieldValue.serverTimestamp(),
        lastQuizSessionId: latest.sessionId || "",
        lastQuizSource: String(latest.meta.source || "backfill_quiz_results"),
        lastQuizScoringModelVersion: String(
          latest.meta.scoringModelVersion || "normalized_v1",
        ),
        lastQuizResultId: latest.docId,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
    });
  }

  console.log("=======================================");
  console.log(`MODE             : ${apply ? "APPLY" : "DRY-RUN"}`);
  console.log(`QUIZ_RESULTS     : ${quizSnap.size}`);
  console.log(`PASIEN_TO_UPDATE : ${plans.length}`);
  console.log(`SKIP_NO_PASIENID : ${skippedMissingPasienId}`);
  console.log(`SKIP_BAD_DATE    : ${skippedInvalidCompletedAt}`);
  console.log(`BAD_SCORE_ROWS   : ${invalidScoreRows}`);
  console.log("=======================================");

  if (!apply) {
    plans.slice(0, 20).forEach((plan) => {
      console.log(
        `- ${plan.pasienId} => score=${plan.patch.comprehensionScore} session=${plan.patch.lastQuizSessionId}`,
      );
    });
    if (plans.length > 20) {
      console.log(`... and ${plans.length - 20} more`);
    }
    return;
  }

  let committed = 0;
  let commitErrors = 0;
  for (let i = 0; i < plans.length; i += 400) {
    const chunk = plans.slice(i, i + 400);
    const batch = db.batch();
    for (const item of chunk) {
      batch.set(db.collection("pasien_profiles").doc(item.pasienId), item.patch, {
        merge: true,
      });
    }
    try {
      await batch.commit();
      committed += chunk.length;
      console.log(`Committed ${committed}/${plans.length}`);
    } catch (error) {
      commitErrors += chunk.length;
      console.error(`Commit chunk failed at index=${i}:`, error?.message || error);
    }
  }

  console.log("=======================================");
  console.log(`UPDATED_OK       : ${committed}`);
  console.log(`UPDATED_FAILED   : ${commitErrors}`);
  console.log("=======================================");
  console.log("DONE");
}

main().catch((error) => {
  console.error("backfill-pasien-comprehension-from-quiz failed:", error?.message || error);
  process.exit(1);
});
