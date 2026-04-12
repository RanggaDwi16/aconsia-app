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

function readText(value) {
  if (value === null || value === undefined) return "";
  const text = String(value).trim();
  return text === "-" ? "" : text;
}

function isObject(value) {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function toMillisModern(value) {
  if (!value) return 0;
  if (value instanceof Date) {
    return Number.isFinite(value.getTime()) ? value.getTime() : 0;
  }
  if (typeof value === "number") {
    return Number.isFinite(value) ? value : 0;
  }
  if (isObject(value)) {
    if (typeof value.toMillis === "function") {
      try {
        const millis = value.toMillis();
        return Number.isFinite(millis) ? millis : 0;
      } catch {
        return 0;
      }
    }
    if (typeof value.toDate === "function") {
      try {
        const date = value.toDate();
        return date instanceof Date && Number.isFinite(date.getTime())
          ? date.getTime()
          : 0;
      } catch {
        return 0;
      }
    }
  }
  if (typeof value === "string" && value.trim().length > 0) {
    const parsed = Date.parse(value.trim());
    return Number.isFinite(parsed) ? parsed : 0;
  }
  return 0;
}

function toMillisLegacyStringOnly(value) {
  if (typeof value !== "string") return 0;
  const parsed = Date.parse(value.trim());
  return Number.isFinite(parsed) ? parsed : 0;
}

function pickDokterId(data) {
  if (!isObject(data)) return "";
  return readText(data.dokterId) || readText(data.assignedDokterId);
}

function readScheduleDateValue(data) {
  if (!isObject(data)) return null;
  const preOp = isObject(data.preOperativeAssessment)
    ? data.preOperativeAssessment
    : null;
  return preOp?.scheduledSignatureDate ?? data.scheduledSignatureDate ?? null;
}

function readScheduleTimeValue(data) {
  if (!isObject(data)) return "";
  const preOp = isObject(data.preOperativeAssessment)
    ? data.preOperativeAssessment
    : null;
  return readText(preOp?.scheduledSignatureTime || data.scheduledSignatureTime);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const sampleLimit = Math.max(1, Number(args.sample || 50));

  await ensureApp();
  const db = admin.firestore();

  const snapshot = await db.collection("pasien_profiles").get();
  const uidBuckets = new Map();

  const stats = {
    totalProfiles: snapshot.size,
    withDokterId: 0,
    withScheduleDate: 0,
    scheduleModernParseOk: 0,
    scheduleLegacyParseOk: 0,
    scheduleLegacyWouldFail: 0,
    scheduleModernFailed: 0,
    duplicateUidBuckets: 0,
    duplicateRows: 0,
  };

  const anomalies = [];
  const anomaliesByDoctor = new Map();

  for (const docSnap of snapshot.docs) {
    const data = docSnap.data() || {};
    const dokterId = pickDokterId(data);
    if (dokterId) stats.withDokterId += 1;

    const canonicalUid = readText(data.uid) || docSnap.id;
    const existing = uidBuckets.get(canonicalUid) || [];
    existing.push({
      docId: docSnap.id,
      dokterId,
      updatedAtMs: toMillisModern(data.updatedAt),
      createdAtMs: toMillisModern(data.createdAt),
    });
    uidBuckets.set(canonicalUid, existing);

    const scheduleDateValue = readScheduleDateValue(data);
    const scheduleTimeValue = readScheduleTimeValue(data);
    if (!scheduleDateValue) continue;

    stats.withScheduleDate += 1;
    const modernMs = toMillisModern(scheduleDateValue);
    const legacyMs = toMillisLegacyStringOnly(scheduleDateValue);

    if (modernMs > 0) stats.scheduleModernParseOk += 1;
    if (legacyMs > 0) stats.scheduleLegacyParseOk += 1;

    if (modernMs > 0 && legacyMs <= 0) {
      stats.scheduleLegacyWouldFail += 1;
      anomalies.push({
        issue: "legacy_schedule_parser_would_fail",
        pasienDocId: docSnap.id,
        canonicalUid,
        dokterId,
        scheduleDateType:
          scheduleDateValue === null
            ? "null"
            : Array.isArray(scheduleDateValue)
              ? "array"
              : typeof scheduleDateValue,
        hasScheduleTime: scheduleTimeValue.length > 0,
      });
      const doctorKey = dokterId || "(tanpa_dokter)";
      anomaliesByDoctor.set(doctorKey, (anomaliesByDoctor.get(doctorKey) || 0) + 1);
    }

    if (modernMs <= 0) {
      stats.scheduleModernFailed += 1;
      anomalies.push({
        issue: "unparseable_schedule_date",
        pasienDocId: docSnap.id,
        canonicalUid,
        dokterId,
        scheduleDateRaw:
          typeof scheduleDateValue === "string"
            ? scheduleDateValue
            : String(scheduleDateValue),
      });
      const doctorKey = dokterId || "(tanpa_dokter)";
      anomaliesByDoctor.set(doctorKey, (anomaliesByDoctor.get(doctorKey) || 0) + 1);
    }
  }

  for (const [canonicalUid, rows] of uidBuckets.entries()) {
    if (rows.length <= 1) continue;
    stats.duplicateUidBuckets += 1;
    stats.duplicateRows += rows.length;

    anomalies.push({
      issue: "duplicate_uid_documents",
      canonicalUid,
      rows: rows
        .sort((a, b) => {
          const delta = (b.updatedAtMs || b.createdAtMs) - (a.updatedAtMs || a.createdAtMs);
          if (delta !== 0) return delta;
          return a.docId.localeCompare(b.docId);
        })
        .map((row) => ({
          docId: row.docId,
          dokterId: row.dokterId || null,
          updatedAtMs: row.updatedAtMs || 0,
        })),
    });
  }

  console.log("=======================================");
  console.log("AUDIT PASIEN PROFILE SCHEDULE");
  console.log(`TOTAL_PROFILES              : ${stats.totalProfiles}`);
  console.log(`WITH_DOKTER_ID              : ${stats.withDokterId}`);
  console.log(`WITH_SCHEDULE_DATE          : ${stats.withScheduleDate}`);
  console.log(`SCHEDULE_PARSE_OK_MODERN    : ${stats.scheduleModernParseOk}`);
  console.log(`SCHEDULE_PARSE_OK_LEGACY    : ${stats.scheduleLegacyParseOk}`);
  console.log(`LEGACY_WOULD_FAIL           : ${stats.scheduleLegacyWouldFail}`);
  console.log(`MODERN_PARSE_FAILED         : ${stats.scheduleModernFailed}`);
  console.log(`DUPLICATE_UID_BUCKETS       : ${stats.duplicateUidBuckets}`);
  console.log(`DUPLICATE_UID_ROWS          : ${stats.duplicateRows}`);
  console.log(`ANOMALY_TOTAL               : ${anomalies.length}`);
  console.log("=======================================");

  if (anomalies.length > 0) {
    console.log(`ANOMALIES_SAMPLE (limit=${sampleLimit}):`);
    for (const row of anomalies.slice(0, sampleLimit)) {
      console.log(`- ${JSON.stringify(row)}`);
    }
  }

  if (anomaliesByDoctor.size > 0) {
    console.log("ANOMALY_BY_DOKTER:");
    const sorted = Array.from(anomaliesByDoctor.entries()).sort((a, b) => b[1] - a[1]);
    for (const [dokterId, count] of sorted.slice(0, sampleLimit)) {
      console.log(`- dokterId=${dokterId} count=${count}`);
    }
  }

  console.log("DONE");
}

main().catch((error) => {
  console.error("audit-pasien-profile-schedule-anomalies failed:", error?.message || error);
  process.exit(1);
});
