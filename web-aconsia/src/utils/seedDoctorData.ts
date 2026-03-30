// Comprehensive demo data seeding for quick testing

export function seedDemoData() {
  // 1. DEMO DOCTOR
  const demoDoctor = {
    id: "doctor-001",
    fullName: "Dr. Ahmad Suryadi, Sp.An",
    email: "demo@doctor.com",
    phone: "081234567890",
    sipNumber: "SIP/12345/2024",
    strNumber: "STR/67890/2024",
    specialization: "Anestesiologi",
    hospital: "RS Dr. Sardjito Yogyakarta",
    password: "demo123",
    createdAt: new Date().toISOString(),
    status: "active"
  };

  // Save individual doctor for login
  localStorage.setItem('doctor_demo@doctor.com', JSON.stringify(demoDoctor));

  // Save to doctors array
  const doctors = JSON.parse(localStorage.getItem('doctors') || '[]');
  if (!doctors.find((d: any) => d.id === demoDoctor.id)) {
    doctors.push(demoDoctor);
    localStorage.setItem('doctors', JSON.stringify(doctors));
  }

  // 2. DEMO ADMIN
  const demoAdmin = {
    id: "admin-001",
    fullName: "Admin Demo",
    email: "admin@demo.com",
    password: "admin123",
    role: "admin",
    createdAt: new Date().toISOString(),
    status: "active"
  };

  localStorage.setItem('admin_admin@demo.com', JSON.stringify(demoAdmin));

  // 3. DEMO PATIENTS (berbagai status)
  const demoPatients = [
    {
      id: "patient-demo-001",
      nik: "3374012205950001",
      fullName: "Budi Santoso",
      mrn: "MR001234",
      dateOfBirth: "1995-05-22",
      age: "30",
      gender: "male",
      religion: "Islam",
      maritalStatus: "married",
      education: "S1",
      occupation: "Pegawai Swasta",
      phone: "081234567001",
      email: "budi@demo.com",
      password: "demo123", // LOGIN PASSWORD
      address: "Jl. Mawar No. 15",
      city: "Yogyakarta",
      weight: "70",
      height: "170",
      allergies: "Tidak ada",
      medicalHistory: "Sehat",
      currentMedications: "Tidak ada",
      previousAnesthesia: "Belum pernah",
      anesthesiologistName: "Dr. Ahmad Suryadi, Sp.An",
      anesthesiologistId: "doctor-001",
      assignedDoctorId: "doctor-001",
      // Data yang sudah diisi dokter:
      diagnosis: "Appendicitis Acute",
      surgeryType: "Laparoscopic Appendectomy",
      surgeryDate: "2026-03-25",
      anesthesiaType: "General Anesthesia",
      status: "in_progress",
      comprehensionScore: 45,
      materialsCompleted: 4,
      totalMaterials: 10,
      lastActivity: "15 menit yang lalu",
      createdAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(), // 2 hari lalu
    },
    {
      id: "patient-demo-002",
      nik: "3374012304920002",
      fullName: "Siti Rahmawati",
      mrn: "MR001235",
      dateOfBirth: "1992-04-23",
      age: "33",
      gender: "female",
      religion: "Islam",
      maritalStatus: "married",
      education: "S1",
      occupation: "Ibu Rumah Tangga",
      phone: "081234567002",
      email: "siti@demo.com",
      password: "demo123", // LOGIN PASSWORD
      address: "Jl. Melati No. 8",
      city: "Yogyakarta",
      weight: "65",
      height: "160",
      allergies: "Tidak ada",
      medicalHistory: "Hamil 38 minggu",
      currentMedications: "Vitamin kehamilan",
      previousAnesthesia: "Belum pernah",
      anesthesiologistName: "Dr. Ahmad Suryadi, Sp.An",
      anesthesiologistId: "doctor-001",
      assignedDoctorId: "doctor-001",
      // Data yang sudah diisi dokter:
      diagnosis: "Gravida 1 Para 0, 38 weeks",
      surgeryType: "Cesarean Section",
      surgeryDate: "2026-03-22",
      anesthesiaType: "Spinal Anesthesia",
      status: "ready",
      comprehensionScore: 92,
      materialsCompleted: 10,
      totalMaterials: 10,
      lastActivity: "1 jam yang lalu",
      scheduledConsentDate: "2026-03-20 09:00",
      createdAt: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(), // 5 hari lalu
    },
    {
      id: "patient-demo-003",
      nik: "3374011506880003",
      fullName: "Ahmad Fauzi",
      mrn: "MR001236",
      dateOfBirth: "1988-06-15",
      age: "37",
      gender: "male",
      religion: "Islam",
      maritalStatus: "married",
      education: "SMA",
      occupation: "Wiraswasta",
      phone: "081234567003",
      email: "ahmad@demo.com",
      password: "demo123", // LOGIN PASSWORD
      address: "Jl. Kenanga No. 22",
      city: "Yogyakarta",
      weight: "75",
      height: "172",
      allergies: "Tidak ada",
      medicalHistory: "Diabetes Tipe 2",
      currentMedications: "Metformin 500mg",
      previousAnesthesia: "Belum pernah",
      anesthesiologistName: "Dr. Ahmad Suryadi, Sp.An",
      anesthesiologistId: "doctor-001",
      assignedDoctorId: "doctor-001",
      // Data yang sudah diisi dokter:
      diagnosis: "Diabetic Foot Infection",
      surgeryType: "Lower Limb Debridement",
      surgeryDate: "2026-03-28",
      anesthesiaType: "Epidural Anesthesia",
      status: "in_progress",
      comprehensionScore: 68,
      materialsCompleted: 7,
      totalMaterials: 10,
      lastActivity: "3 jam yang lalu",
      createdAt: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(), // 1 hari lalu
    },
    {
      id: "patient-demo-004",
      nik: "3374012708000004",
      fullName: "Maya Kusuma",
      mrn: "MR001237",
      dateOfBirth: "2000-08-27",
      age: "25",
      gender: "female",
      religion: "Kristen Protestan",
      maritalStatus: "single",
      education: "S1",
      occupation: "Mahasiswi",
      phone: "081234567004",
      email: "maya@demo.com",
      password: "demo123", // LOGIN PASSWORD
      address: "Jl. Dahlia No. 5",
      city: "Yogyakarta",
      weight: "55",
      height: "165",
      allergies: "Tidak ada",
      medicalHistory: "Sehat",
      currentMedications: "Tidak ada",
      previousAnesthesia: "Belum pernah",
      anesthesiologistName: "Dr. Ahmad Suryadi, Sp.An",
      anesthesiologistId: "doctor-001",
      assignedDoctorId: "doctor-001",
      // Baru daftar, belum diisi dokter:
      diagnosis: null,
      surgeryType: null,
      surgeryDate: null,
      anesthesiaType: null,
      status: "pending",
      comprehensionScore: 0,
      materialsCompleted: 0,
      totalMaterials: 0,
      lastActivity: "Baru saja",
      createdAt: new Date().toISOString(), // Baru saja
    },
    // ========================================
    // 🆕 NEW: PASIEN YANG SUDAH ACC TAPI BELUM ISI TEKNIK ANESTESI
    // ========================================
    {
      id: "patient-demo-005",
      nik: "3374011204950005",
      fullName: "Rina Wijaya",
      mrn: "MR001238",
      dateOfBirth: "1995-04-12",
      age: "30",
      gender: "female",
      religion: "Islam",
      maritalStatus: "married",
      education: "S1",
      occupation: "Guru",
      phone: "081234567005",
      email: "rina@demo.com",
      password: "demo123", // LOGIN PASSWORD
      address: "Jl. Anggrek No. 10",
      city: "Yogyakarta",
      weight: "58",
      height: "162",
      allergies: "Tidak ada",
      medicalHistory: "Sehat",
      currentMedications: "Tidak ada",
      previousAnesthesia: "Belum pernah",
      anesthesiologistName: "Dr. Ahmad Suryadi, Sp.An",
      anesthesiologistId: "doctor-001",
      assignedDoctorId: "doctor-001",
      // ✅ SUDAH DI-ACC DOKTER & ISI DIAGNOSIS/SURGERY
      // ⚠️ BELUM PILIH TEKNIK ANESTESI (null)
      diagnosis: "Ovarian Cyst",
      surgeryType: "Laparoscopic Cystectomy",
      surgeryDate: "2026-03-26",
      anesthesiaType: null, // ⬅️ ANDA YANG PILIH!
      status: "approved", // ✅ Sudah di-approve dokter
      comprehensionScore: 0,
      materialsCompleted: 0,
      totalMaterials: 0,
      lastActivity: "Baru saja",
      createdAt: new Date().toISOString(),
    },
    {
      id: "patient-demo-006",
      nik: "3374010809920006",
      fullName: "Andi Wijaya",
      mrn: "MR001239",
      dateOfBirth: "1992-09-08",
      age: "33",
      gender: "male",
      religion: "Kristen Katolik",
      maritalStatus: "married",
      education: "S2",
      occupation: "Dosen",
      phone: "081234567006",
      email: "andi@demo.com",
      password: "demo123", // LOGIN PASSWORD
      address: "Jl. Flamboyan No. 18",
      city: "Yogyakarta",
      weight: "72",
      height: "175",
      allergies: "Tidak ada",
      medicalHistory: "Hipertensi ringan (terkontrol)",
      currentMedications: "Amlodipine 5mg",
      previousAnesthesia: "Belum pernah",
      anesthesiologistName: "Dr. Ahmad Suryadi, Sp.An",
      anesthesiologistId: "doctor-001",
      assignedDoctorId: "doctor-001",
      // ✅ SUDAH DI-ACC DOKTER & ISI DIAGNOSIS/SURGERY
      // ⚠️ BELUM PILIH TEKNIK ANESTESI (null)
      diagnosis: "Inguinal Hernia",
      surgeryType: "Herniorrhaphy",
      surgeryDate: "2026-03-27",
      anesthesiaType: null, // ⬅️ ANDA YANG PILIH!
      status: "approved", // ✅ Sudah di-approve dokter
      comprehensionScore: 0,
      materialsCompleted: 0,
      totalMaterials: 0,
      lastActivity: "Baru saja",
      createdAt: new Date().toISOString(),
    },
  ];

  // Save demo patients
  // ⚠️ ALWAYS OVERWRITE to ensure latest data (remove if condition)
  localStorage.setItem('demoPatients', JSON.stringify(demoPatients));
  
  // Save each patient for login (using NIK as username)
  demoPatients.forEach(patient => {
    localStorage.setItem(`patient_${patient.nik}`, JSON.stringify(patient));
  });
  
  console.log('✅ Demo data seeded successfully!');
  console.log('📧 Doctor: demo@doctor.com / demo123');
  console.log('📧 Admin: admin@demo.com / admin123');
  console.log(`👥 ${demoPatients.length} demo patients created`);
  console.log('\n🔐 Patient Login (NIK/Password):');
  demoPatients.forEach(p => {
    const statusLabel = p.status === 'approved' && !p.anesthesiaType 
      ? '✅ APPROVED - BELUM ISI TEKNIK ANESTESI (ANDA YANG PILIH!)'
      : p.status === 'pending'
      ? '⏳ Pending'
      : p.status === 'in_progress'
      ? `📚 In Progress (${p.comprehensionScore}%)`
      : p.status === 'ready'
      ? `✅ Ready (${p.comprehensionScore}%)`
      : p.status;
    console.log(`   - ${p.fullName}: ${p.nik} / demo123 [${statusLabel}]`);
  });
}

// Legacy function name untuk backward compatibility
export function seedDemoDoctorData() {
  seedDemoData();
}