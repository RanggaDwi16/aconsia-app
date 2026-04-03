const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require("@firebase/rules-unit-testing");
const { doc, setDoc, updateDoc } = require("firebase/firestore");

const projectId = `aconsia-rules-test-${Date.now()}`;
const rules = fs.readFileSync(
  path.resolve(__dirname, "../../firestore.rules"),
  "utf8",
);

let testEnv;

test.before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      rules,
    },
  });
});

test.after(async () => {
  if (testEnv) {
    await testEnv.cleanup();
  }
});

test.beforeEach(async () => {
  await testEnv.clearFirestore();
});

test("doctor cannot update sensitive pasien status directly", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "pasien_profiles", "pasien-001"), {
      assignedDokterId: "dokter-001",
      status: "pending",
      namaLengkap: "Pasien Test",
    });
  });

  const doctorDb = testEnv.authenticatedContext("dokter-001", {
    role: "dokter",
  }).firestore();

  await assertFails(
    updateDoc(doc(doctorDb, "pasien_profiles", "pasien-001"), {
      status: "approved",
    }),
  );
});

test("admin client cannot update user lifecycle fields directly", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "users", "pasien-001"), {
      role: "pasien",
      status: "active",
      name: "Pasien Rules",
    });
  });

  const adminDb = testEnv.authenticatedContext("admin-001", {
    role: "admin",
  }).firestore();

  await assertFails(
    updateDoc(doc(adminDb, "users", "pasien-001"), {
      status: "suspended",
      statusReason: "manual",
    }),
  );
});

test("system custom token can create immutable audit log", async () => {
  const systemDb = testEnv.authenticatedContext("system-uid", {
    role: "admin",
    firebase: {
      sign_in_provider: "custom",
    },
  }).firestore();

  await assertSucceeds(
    setDoc(doc(systemDb, "admin_audit_logs", "log-001"), {
      actorUid: "system-uid",
      actorRole: "admin",
      actionType: "TEST",
      entityType: "system",
      message: "rules test",
      createdAt: new Date().toISOString(),
    }),
  );
});

test("doctor cannot update konten publish status directly", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "konten", "konten-001"), {
      dokterId: "dokter-001",
      judul: "Materi A",
      status: "draft",
    });
  });

  const doctorDb = testEnv.authenticatedContext("dokter-001", {
    role: "dokter",
  }).firestore();

  await assertFails(
    updateDoc(doc(doctorDb, "konten", "konten-001"), {
      status: "published",
    }),
  );
});

test("doctor can still update non-moderation konten fields", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "konten", "konten-002"), {
      dokterId: "dokter-001",
      judul: "Materi B",
      status: "draft",
      deskripsi: "awal",
    });
  });

  const doctorDb = testEnv.authenticatedContext("dokter-001", {
    role: "dokter",
  }).firestore();

  await assertSucceeds(
    updateDoc(doc(doctorDb, "konten", "konten-002"), {
      deskripsi: "revisi dokter",
    }),
  );
});

test("doctor self-registration user doc must follow strict schema", async () => {
  const doctorDb = testEnv.authenticatedContext("dokter-self-001").firestore();

  await assertSucceeds(
    setDoc(doc(doctorDb, "users", "dokter-self-001"), {
      uid: "dokter-self-001",
      email: "dokter.valid@hospital.com",
      name: "Dr Valid",
      displayName: "Dr Valid",
      role: "dokter",
      status: "active",
      phone: "081234567890",
      hospital: "RS Valid",
      specialization: "Anestesiologi",
      sipNumber: "SIP/12345/2026",
      strNumber: "STR/98765/2026",
      isProfileCompleted: true,
      createdAt: "server-time",
      updatedAt: "server-time",
    }),
  );

  await assertFails(
    setDoc(doc(doctorDb, "users", "dokter-self-001-bad"), {
      uid: "dokter-self-001-bad",
      email: "dokter.valid@hospital.com",
      name: "Dr Invalid",
      displayName: "Dr Invalid",
      role: "dokter",
      status: "active",
      phone: "08ABC123",
      hospital: "RS Invalid",
      specialization: "Anestesiologi",
      sipNumber: "SIP/12345/2026",
      strNumber: "STR/98765/2026",
      isProfileCompleted: true,
      createdAt: "server-time",
      updatedAt: "server-time",
    }),
  );
});

test("dokter profile create must be valid even without dokter claim", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "users", "dokter-self-002"), {
      uid: "dokter-self-002",
      role: "dokter",
      email: "dokter2@hospital.com",
    });
  });

  const doctorDb = testEnv.authenticatedContext("dokter-self-002").firestore();

  await assertSucceeds(
    setDoc(doc(doctorDb, "dokter_profiles", "dokter-self-002"), {
      uid: "dokter-self-002",
      email: "dokter2@hospital.com",
      fullName: "Dr Dua",
      nama: "Dr Dua",
      phoneNumber: "081234567891",
      noTelepon: "081234567891",
      hospitalName: "RS Dua",
      namaRumahSakit: "RS Dua",
      specialization: "Anestesiologi",
      sipNumber: "SIP/55555/2026",
      strNumber: "STR/44444/2026",
      status: "active",
      createdAt: "server-time",
      updatedAt: "server-time",
    }),
  );

  await assertSucceeds(
    setDoc(doc(doctorDb, "dokter_profiles", "dokter-self-002"), {
      uid: "dokter-self-002",
      email: "dokter2@hospital.com",
      fullName: "Dr Dua",
      nama: "Dr Dua",
      phoneNumber: "081234567891",
      noTelepon: "081234567891",
      hospitalName: "RS Dua",
      namaRumahSakit: "RS Dua",
      specialization: "Anestesiologi",
      sipNumber: "SIP INVALID !!!",
      strNumber: "STR/44444/2026",
      status: "active",
      createdAt: "server-time",
      updatedAt: "server-time",
    }),
  );

  await assertSucceeds(
    setDoc(doc(doctorDb, "dokter_profiles", "dokter-self-002"), {
      uid: "dokter-self-002",
      email: "dokter2@hospital.com",
      fullName: "Dr Dua",
      nama: "Dr Dua",
      phoneNumber: "081234567891",
      noTelepon: "081234567891",
      hospitalName: "RS Dua",
      namaRumahSakit: "RS Dua",
      specialization: "Anestesiologi",
      sipNumber: "ASDFGHJK",
      strNumber: "QWERTYUI",
      status: "active",
      createdAt: "server-time",
      updatedAt: "server-time",
    }),
  );

  await assertFails(
    setDoc(doc(doctorDb, "dokter_profiles", "dokter-self-002"), {
      uid: "dokter-self-002",
      email: "dokter2@hospital.com",
      fullName: "Dr Dua",
      nama: "Dr Dua",
      phoneNumber: "081234567891",
      noTelepon: "081234567891",
      hospitalName: "RS Dua",
      namaRumahSakit: "RS Dua",
      specialization: "Anestesiologi",
      sipNumber: "SIP/12345/1999",
      strNumber: "STR-12345-2026",
      status: "active",
      createdAt: "server-time",
      updatedAt: "server-time",
    }),
  );
});
