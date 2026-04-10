const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require("@firebase/rules-unit-testing");
const { doc, getDoc, setDoc, updateDoc } = require("firebase/firestore");

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

test("doctor with active dokter_profiles can create konten without role claim", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "dokter_profiles", "dokter-profile-only"), {
      uid: "dokter-profile-only",
      status: "active",
      specialization: "Anestesiologi",
    });
  });

  const doctorDb = testEnv.authenticatedContext("dokter-profile-only").firestore();

  await assertSucceeds(
    setDoc(doc(doctorDb, "konten", "konten-profile-create-001"), {
      dokterId: "dokter-profile-only",
      judul: "Konten Test",
      jenisAnestesi: "Epidural",
      indikasiTindakan: "Deskripsi test",
      status: "draft",
      jumlahBagian: 1,
      createdAt: "server-time",
      updatedAt: "server-time",
    }),
  );
});

test("pasien cannot create konten", async () => {
  const pasienDb = testEnv.authenticatedContext("pasien-002", {
    role: "pasien",
  }).firestore();

  await assertFails(
    setDoc(doc(pasienDb, "konten", "konten-pasien-create-001"), {
      dokterId: "pasien-002",
      judul: "Konten Tidak Sah",
      jenisAnestesi: "Epidural",
      indikasiTindakan: "Deskripsi",
      status: "draft",
      jumlahBagian: 1,
      createdAt: "server-time",
      updatedAt: "server-time",
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

test("pasien owner can create pasien_profiles with stored role fallback (without claim)", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "users", "pasien-fallback-001"), {
      uid: "pasien-fallback-001",
      role: "pasien",
      email: "pasien-fallback-001@mail.com",
    });
  });

  const pasienDb = testEnv.authenticatedContext("pasien-fallback-001").firestore();

  await assertSucceeds(
    setDoc(doc(pasienDb, "pasien_profiles", "pasien-fallback-001"), {
      uid: "pasien-fallback-001",
      namaLengkap: "Pasien Fallback",
      nomorTelepon: "081234567890",
      email: "pasien-fallback-001@mail.com",
      dokterId: "dokter-001",
      updatedAt: "server-time",
    }),
  );
});

test("pasien owner with claim can still create pasien_profiles", async () => {
  const pasienDb = testEnv.authenticatedContext("pasien-claim-001", {
    role: "pasien",
  }).firestore();

  await assertSucceeds(
    setDoc(doc(pasienDb, "pasien_profiles", "pasien-claim-001"), {
      uid: "pasien-claim-001",
      namaLengkap: "Pasien Claim",
      nomorTelepon: "081234567891",
      email: "pasien-claim-001@mail.com",
      dokterId: "dokter-001",
      updatedAt: "server-time",
    }),
  );
});

test("non-owner pasien cannot create another pasien profile even with pasien role", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "users", "pasien-owner-001"), {
      uid: "pasien-owner-001",
      role: "pasien",
      email: "pasien-owner-001@mail.com",
    });
  });

  const otherPasienDb = testEnv.authenticatedContext("pasien-lain-001").firestore();
  await assertFails(
    setDoc(doc(otherPasienDb, "pasien_profiles", "pasien-owner-001"), {
      uid: "pasien-owner-001",
      namaLengkap: "Tidak Sah",
      nomorTelepon: "081234567892",
      email: "invalid@mail.com",
      dokterId: "dokter-001",
      updatedAt: "server-time",
    }),
  );
});

test("pasien can read published konten", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "konten", "konten-published-001"), {
      dokterId: "dokter-001",
      judul: "Konten Published",
      status: "published",
      createdAt: "server-time",
      updatedAt: "server-time",
    });
  });

  const pasienDb = testEnv.authenticatedContext("pasien-read-001", {
    role: "pasien",
  }).firestore();

  await assertSucceeds(getDoc(doc(pasienDb, "konten", "konten-published-001")));
});

test("pasien cannot read assigned draft konten via assignments", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "konten", "konten-assigned-001"), {
      dokterId: "dokter-001",
      judul: "Konten Assigned",
      status: "draft",
      createdAt: "server-time",
      updatedAt: "server-time",
    });
    await setDoc(doc(db, "assignments", "konten-assigned-001_pasien-read-002"), {
      pasienId: "pasien-read-002",
      kontenId: "konten-assigned-001",
      assignedBy: "dokter-001",
      status: "assigned",
      createdAt: "server-time",
      updatedAt: "server-time",
    });
  });

  const pasienDb = testEnv.authenticatedContext("pasien-read-002", {
    role: "pasien",
  }).firestore();

  await assertFails(getDoc(doc(pasienDb, "konten", "konten-assigned-001")));
});

test("pasien cannot read draft konten without assignment", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "konten", "konten-draft-001"), {
      dokterId: "dokter-001",
      judul: "Konten Draft",
      status: "draft",
      createdAt: "server-time",
      updatedAt: "server-time",
    });
  });

  const pasienDb = testEnv.authenticatedContext("pasien-read-003", {
    role: "pasien",
  }).firestore();

  await assertFails(getDoc(doc(pasienDb, "konten", "konten-draft-001")));
});

test("dokter bisa create assignment untuk konten miliknya dan pasien dalam scope", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "pasien_profiles", "pasien-scope-001"), {
      dokterId: "dokter-001",
      namaLengkap: "Pasien Scope",
    });
    await setDoc(doc(db, "konten", "konten-dokter-001"), {
      dokterId: "dokter-001",
      judul: "Konten Scope",
      status: "published",
    });
  });

  const dokterDb = testEnv.authenticatedContext("dokter-001", {
    role: "dokter",
  }).firestore();

  await assertSucceeds(
    setDoc(doc(dokterDb, "assignments", "konten-dokter-001_pasien-scope-001"), {
      pasienId: "pasien-scope-001",
      dokterId: "dokter-001",
      kontenId: "konten-dokter-001",
      assignedBy: "dokter-001",
      status: "assigned",
      assignedAt: "server-time",
      updatedAt: "server-time",
      isCompleted: false,
      currentBagian: 1,
      completedAt: null,
    }),
  );
});

test("dokter tidak bisa create assignment untuk konten draft miliknya", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "pasien_profiles", "pasien-scope-draft-001"), {
      dokterId: "dokter-001",
      namaLengkap: "Pasien Scope Draft",
    });
    await setDoc(doc(db, "konten", "konten-draft-dokter-001"), {
      dokterId: "dokter-001",
      judul: "Konten Draft Scope",
      status: "draft",
    });
  });

  const dokterDb = testEnv.authenticatedContext("dokter-001", {
    role: "dokter",
  }).firestore();

  await assertFails(
    setDoc(
      doc(dokterDb, "assignments", "konten-draft-dokter-001_pasien-scope-draft-001"),
      {
        pasienId: "pasien-scope-draft-001",
        dokterId: "dokter-001",
        kontenId: "konten-draft-dokter-001",
        assignedBy: "dokter-001",
        status: "assigned",
        assignedAt: "server-time",
        updatedAt: "server-time",
        isCompleted: false,
        currentBagian: 1,
        completedAt: null,
      },
    ),
  );
});

test("pasien cannot read sections of draft konten", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "konten", "konten-draft-sections-001"), {
      dokterId: "dokter-001",
      judul: "Konten Draft Dengan Section",
      status: "draft",
      createdAt: "server-time",
      updatedAt: "server-time",
    });
    await setDoc(doc(db, "konten", "konten-draft-sections-001", "sections", "section-001"), {
      kontenId: "konten-draft-sections-001",
      judulBagian: "Section Draft 1",
      isiKonten: "Isi draft",
      urutan: 1,
      createdAt: "server-time",
      updatedAt: "server-time",
    });
  });

  const pasienDb = testEnv.authenticatedContext("pasien-read-sections-001", {
    role: "pasien",
  }).firestore();

  await assertFails(
    getDoc(doc(pasienDb, "konten", "konten-draft-sections-001", "sections", "section-001")),
  );
});

test("pasien can read sections of published konten", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "konten", "konten-published-sections-001"), {
      dokterId: "dokter-001",
      judul: "Konten Published Dengan Section",
      status: "published",
      createdAt: "server-time",
      updatedAt: "server-time",
    });
    await setDoc(doc(db, "konten", "konten-published-sections-001", "sections", "section-001"), {
      kontenId: "konten-published-sections-001",
      judulBagian: "Section Published 1",
      isiKonten: "Isi published",
      urutan: 1,
      createdAt: "server-time",
      updatedAt: "server-time",
    });
  });

  const pasienDb = testEnv.authenticatedContext("pasien-read-sections-002", {
    role: "pasien",
  }).firestore();

  await assertSucceeds(
    getDoc(doc(pasienDb, "konten", "konten-published-sections-001", "sections", "section-001")),
  );
});

test("dokter tidak bisa create assignment untuk konten dokter lain", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "pasien_profiles", "pasien-scope-002"), {
      dokterId: "dokter-001",
      namaLengkap: "Pasien Scope Dua",
    });
    await setDoc(doc(db, "konten", "konten-dokter-lain"), {
      dokterId: "dokter-999",
      judul: "Konten Bukan Milik Dokter 001",
      status: "draft",
    });
  });

  const dokterDb = testEnv.authenticatedContext("dokter-001", {
    role: "dokter",
  }).firestore();

  await assertFails(
    setDoc(doc(dokterDb, "assignments", "konten-dokter-lain_pasien-scope-002"), {
      pasienId: "pasien-scope-002",
      dokterId: "dokter-001",
      kontenId: "konten-dokter-lain",
      assignedBy: "dokter-001",
      status: "assigned",
      assignedAt: "server-time",
      updatedAt: "server-time",
      isCompleted: false,
      currentBagian: 1,
      completedAt: null,
    }),
  );
});

test("dokter tidak bisa create assignment untuk pasien di luar scope", async () => {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, "pasien_profiles", "pasien-luar-scope-001"), {
      dokterId: "dokter-002",
      namaLengkap: "Pasien Luar Scope",
    });
    await setDoc(doc(db, "konten", "konten-dokter-001-scope"), {
      dokterId: "dokter-001",
      judul: "Konten Scope Dokter 001",
      status: "draft",
    });
  });

  const dokterDb = testEnv.authenticatedContext("dokter-001", {
    role: "dokter",
  }).firestore();

  await assertFails(
    setDoc(doc(dokterDb, "assignments", "konten-dokter-001-scope_pasien-luar-scope-001"), {
      pasienId: "pasien-luar-scope-001",
      dokterId: "dokter-001",
      kontenId: "konten-dokter-001-scope",
      assignedBy: "dokter-001",
      status: "assigned",
      assignedAt: "server-time",
      updatedAt: "server-time",
      isCompleted: false,
      currentBagian: 1,
      completedAt: null,
    }),
  );
});
