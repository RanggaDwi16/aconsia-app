#!/usr/bin/env node
/* eslint-disable no-console */
const admin = require("firebase-admin");

async function ensureApp() {
  if (admin.apps.length > 0) return;
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });
}

function normalizeDoctor(docId, data) {
  const rawStatus = (data?.status || "").toString().trim().toLowerCase();
  const status = rawStatus || "active";

  const namaLengkap =
    (data?.fullName || data?.nama || data?.name || "").toString().trim() || "-";
  const nomorTelepon =
    (data?.nomorTelepon || data?.phoneNumber || data?.noTelepon || data?.phone || "")
      .toString()
      .trim();
  const spesialisasi =
    (data?.spesialisasi || data?.specialization || "").toString().trim();

  return {
    uid: (data?.uid || docId || "").toString().trim(),
    namaLengkap,
    nomorTelepon,
    spesialisasi,
    status,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
}

async function main() {
  await ensureApp();
  const db = admin.firestore();

  const dokterSnap = await db.collection("dokter_profiles").get();
  const publicSnap = await db.collection("public_dokter_options").get();

  const batch = db.batch();
  const validIds = new Set();
  let upsertCount = 0;
  let deleteCount = 0;

  for (const doc of dokterSnap.docs) {
    const payload = normalizeDoctor(doc.id, doc.data());
    if (!payload.uid) continue;
    validIds.add(payload.uid);
    batch.set(
      db.collection("public_dokter_options").doc(payload.uid),
      {
        ...payload,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true},
    );
    upsertCount += 1;
  }

  for (const doc of publicSnap.docs) {
    if (!validIds.has(doc.id)) {
      batch.delete(doc.ref);
      deleteCount += 1;
    }
  }

  if (upsertCount > 0 || deleteCount > 0) {
    await batch.commit();
  }

  console.log("=======================================");
  console.log("Sync public_dokter_options selesai.");
  console.log(`Upsert: ${upsertCount}`);
  console.log(`Delete: ${deleteCount}`);
  console.log("=======================================");
}

main().catch((error) => {
  console.error("sync-public-dokter-options gagal:", error?.message || error);
  process.exit(1);
});

