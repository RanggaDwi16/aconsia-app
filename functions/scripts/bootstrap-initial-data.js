#!/usr/bin/env node
/* eslint-disable no-console */
const admin = require("firebase-admin");

async function ensureApp() {
  if (admin.apps.length > 0) return;
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });
}

async function getOrCreateUser(auth, { email, password, displayName }) {
  try {
    const existing = await auth.getUserByEmail(email);
    await auth.updateUser(existing.uid, {
      password,
      displayName,
      emailVerified: true,
      disabled: false,
    });
    return { user: await auth.getUser(existing.uid), created: false };
  } catch (error) {
    if (error?.code !== "auth/user-not-found") {
      throw error;
    }
  }

  const created = await auth.createUser({
    email,
    password,
    displayName,
    emailVerified: true,
    disabled: false,
  });
  return { user: created, created: true };
}

async function upsertUserDoc(db, params) {
  const {
    uid,
    email,
    name,
    role,
    status = "active",
    extra = {},
  } = params;

  await db.collection("users").doc(uid).set(
    {
      uid,
      email,
      name,
      displayName: name,
      role,
      status,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      ...extra,
    },
    { merge: true },
  );
}

async function main() {
  await ensureApp();

  const auth = admin.auth();
  const db = admin.firestore();

  const adminSeed = {
    email: "admin@demo.com",
    password: "admin123",
    name: "Admin Demo",
    roleClaim: "admin",
    roleDoc: "admin",
  };

  const doctorSeed = {
    email: "demo@doctor.com",
    password: "demo123",
    name: "dr. Sindu Sinistra, Sp.An",
    roleClaim: "dokter",
    roleDoc: "dokter",
    phone: "081234567890",
    hospital: "RS ACONSIA",
    sipNumber: "SIP/DEMO/2026/001",
    strNumber: "STR/DEMO/2026/001",
    specialization: "Anestesiologi",
  };

  const patientSeed = {
    email: "pasien@demo.com",
    password: "demo123",
    name: "Pasien Demo",
    roleClaim: "pasien",
    roleDoc: "pasien",
    nik: "3374012205950001",
    mrn: "RM-DEMO-001",
    gender: "Perempuan",
    birthDate: "1995-05-22",
    age: "30",
    phone: "081298765432",
    address: "Jl. Demo No. 1, Jakarta",
  };

  const seededAccounts = [];

  for (const item of [adminSeed, doctorSeed, patientSeed]) {
    const { user, created } = await getOrCreateUser(auth, {
      email: item.email,
      password: item.password,
      displayName: item.name,
    });

    const existingClaims = user.customClaims || {};
    await auth.setCustomUserClaims(user.uid, {
      ...existingClaims,
      role: item.roleClaim,
    });

    seededAccounts.push({
      ...item,
      uid: user.uid,
      created,
    });
  }

  const seededAdmin = seededAccounts.find((x) => x.roleDoc === "admin");
  const seededDoctor = seededAccounts.find((x) => x.roleDoc === "dokter");
  const seededPatient = seededAccounts.find((x) => x.roleDoc === "pasien");

  await upsertUserDoc(db, {
    uid: seededAdmin.uid,
    email: seededAdmin.email,
    name: seededAdmin.name,
    role: "admin",
  });

  await upsertUserDoc(db, {
    uid: seededDoctor.uid,
    email: seededDoctor.email,
    name: seededDoctor.name,
    role: "dokter",
    extra: {
      phone: doctorSeed.phone,
      hospital: doctorSeed.hospital,
      sipNumber: doctorSeed.sipNumber,
      strNumber: doctorSeed.strNumber,
      specialization: doctorSeed.specialization,
      isProfileCompleted: true,
    },
  });

  await db.collection("dokter_profiles").doc(seededDoctor.uid).set(
    {
      uid: seededDoctor.uid,
      email: seededDoctor.email,
      fullName: seededDoctor.name,
      nama: seededDoctor.name,
      phoneNumber: doctorSeed.phone,
      noTelepon: doctorSeed.phone,
      hospitalName: doctorSeed.hospital,
      namaRumahSakit: doctorSeed.hospital,
      specialization: doctorSeed.specialization,
      sipNumber: doctorSeed.sipNumber,
      strNumber: doctorSeed.strNumber,
      status: "active",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  await db.collection("public_dokter_options").doc(seededDoctor.uid).set(
    {
      uid: seededDoctor.uid,
      namaLengkap: seededDoctor.name,
      nomorTelepon: doctorSeed.phone,
      spesialisasi: doctorSeed.specialization,
      status: "active",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  await upsertUserDoc(db, {
    uid: seededPatient.uid,
    email: seededPatient.email,
    name: seededPatient.name,
    role: "pasien",
    extra: {
      nik: patientSeed.nik,
      noRekamMedis: patientSeed.mrn,
      isProfileCompleted: true,
    },
  });

  await db.collection("pasien_profiles").doc(seededPatient.uid).set(
    {
      uid: seededPatient.uid,
      email: seededPatient.email,
      namaLengkap: seededPatient.name,
      noRekamMedis: patientSeed.mrn,
      nik: patientSeed.nik,
      tanggalLahir: patientSeed.birthDate,
      age: patientSeed.age,
      jenisKelamin: patientSeed.gender,
      nomorTelepon: patientSeed.phone,
      alamat: patientSeed.address,
      dokterId: seededDoctor.uid,
      assignedDokterId: seededDoctor.uid,
      status: "pending",
      diagnosis: "",
      jenisOperasi: "",
      jenisAnestesi: null,
      comprehensionScore: 0,
      surgeryDate: "Belum dijadwalkan",
      materialsCompleted: 0,
      totalMaterials: 0,
      lastActivity: "N/A",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true },
  );

  console.log("=======================================");
  console.log("Bootstrap data berhasil dibuat.");
  console.log("");
  for (const acct of seededAccounts) {
    console.log(
      `${acct.roleDoc.toUpperCase()} | ${acct.email} | ${acct.password} | uid=${acct.uid} | created=${acct.created ? "yes" : "updated"}`,
    );
  }
  console.log("=======================================");
  console.log("Catatan:");
  console.log("- Firestore collections terisi: users, dokter_profiles, public_dokter_options, pasien_profiles");
  console.log("- Jika user sudah login sebelumnya, lakukan logout/login ulang agar claim terbaru terbaca.");
}

main().catch((error) => {
  console.error("Bootstrap gagal:", error?.message || error);
  process.exit(1);
});
