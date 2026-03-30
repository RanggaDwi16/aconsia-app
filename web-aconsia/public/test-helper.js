/**
 * ACONSIA TESTING HELPER
 * 
 * Paste this script in browser console for quick testing utilities
 * 
 * Usage:
 *   TestHelper.seedPatient('general')
 *   TestHelper.seedPatient('spinal')
 *   TestHelper.checkAutoFilter()
 *   TestHelper.clearAll()
 */

window.TestHelper = {
  
  /**
   * Seed test patient with specific anesthesia type
   * @param {string} type - 'general', 'spinal', 'epidural'
   */
  seedPatient(type = 'general') {
    const patients = {
      general: {
        id: "patient-001",
        userId: "user-001",
        fullName: "Jordan Smith",
        mrn: "MRN-2026-001",
        dateOfBirth: "1985-01-15",
        age: 41,
        gender: "Male",
        phone: "+62 812-3456-7890",
        email: "jordan.smith@email.com",
        address: "Jl. Sudirman No. 123, Jakarta Pusat, DKI Jakarta 10110",
        surgeryType: "Laparoscopic Appendectomy",
        surgeryDate: "2026-03-15",
        asaStatus: "ASA II",
        anesthesiaType: "General Anesthesia",
        medicalHistory: "Hypertension (controlled)",
        allergies: "None",
        medications: "Amlodipine 5mg daily",
        status: "approved",
        assignedDoctorId: "doctor-001",
        comprehensionScore: 0
      },
      spinal: {
        id: "patient-002",
        userId: "user-002",
        fullName: "Sarah Johnson",
        mrn: "MRN-2026-002",
        dateOfBirth: "1990-05-22",
        age: 35,
        gender: "Female",
        phone: "+62 821-9876-5432",
        email: "sarah.johnson@email.com",
        address: "Jl. Gatot Subroto No. 456, Jakarta Selatan",
        surgeryType: "Cesarean Section",
        surgeryDate: "2026-03-20",
        asaStatus: "ASA I",
        anesthesiaType: "Spinal Anesthesia",
        medicalHistory: "Healthy",
        allergies: "None",
        medications: "Prenatal vitamins",
        status: "approved",
        assignedDoctorId: "doctor-001",
        comprehensionScore: 0
      },
      epidural: {
        id: "patient-003",
        userId: "user-003",
        fullName: "Michael Chen",
        mrn: "MRN-2026-003",
        dateOfBirth: "1978-11-08",
        age: 47,
        gender: "Male",
        phone: "+62 813-5555-1234",
        email: "michael.chen@email.com",
        address: "Jl. Thamrin No. 789, Jakarta Pusat",
        surgeryType: "Lower Limb Orthopedic Surgery",
        surgeryDate: "2026-03-18",
        asaStatus: "ASA II",
        anesthesiaType: "Epidural Anesthesia",
        medicalHistory: "Type 2 Diabetes (controlled)",
        allergies: "Penicillin",
        medications: "Metformin 500mg twice daily",
        status: "approved",
        assignedDoctorId: "doctor-002",
        comprehensionScore: 0
      }
    };

    const patient = patients[type.toLowerCase()];
    if (!patient) {
      console.error(`❌ Invalid type. Use: 'general', 'spinal', or 'epidural'`);
      return;
    }

    localStorage.setItem("currentPatient", JSON.stringify(patient));
    console.log(`✅ Seeded patient: ${patient.fullName}`);
    console.log(`   Type: ${patient.anesthesiaType}`);
    console.log(`   Navigate to /patient to see filtered materials`);
  },

  /**
   * Check if auto-filter is working correctly
   */
  checkAutoFilter() {
    const patient = JSON.parse(localStorage.getItem("currentPatient") || "{}");
    
    if (!patient.anesthesiaType) {
      console.error("❌ No patient data found. Run TestHelper.seedPatient() first");
      return;
    }

    console.log("🔍 Checking auto-filter...");
    console.log(`   Patient: ${patient.fullName}`);
    console.log(`   Anesthesia Type: ${patient.anesthesiaType}`);
    
    // Expected materials by type
    const expectedMaterials = {
      "General Anesthesia": ["Pengenalan Anestesi Umum", "Persiapan Sebelum Anestesi Umum", "Prosedur Anestesi Umum"],
      "Spinal Anesthesia": ["Pengenalan Anestesi Spinal", "Persiapan Anestesi Spinal", "Prosedur Anestesi Spinal"],
      "Epidural Anesthesia": ["Anestesi Epidural: Panduan Lengkap", "Persiapan Anestesi Epidural"]
    };

    const expected = expectedMaterials[patient.anesthesiaType];
    
    console.log(`   Expected materials (${expected.length}):`);
    expected.forEach((title, idx) => {
      console.log(`   ${idx + 1}. ${title}`);
    });
    
    console.log("\n   ✅ Go to /patient to verify ONLY these materials are visible");
    console.log("   ❌ If you see other materials (Spinal/Epidural/etc), AUTO-FILTER FAILED!");
  },

  /**
   * Set comprehension score (for testing schedule)
   * @param {number} score - Score 0-100
   */
  setScore(score) {
    const patient = JSON.parse(localStorage.getItem("currentPatient") || "{}");
    if (!patient.id) {
      console.error("❌ No patient data found");
      return;
    }

    patient.comprehensionScore = score;
    localStorage.setItem("currentPatient", JSON.stringify(patient));
    console.log(`✅ Comprehension score set to: ${score}%`);
    
    if (score >= 80) {
      console.log("   ✅ Score ≥80% → Can schedule consent");
      console.log("   Navigate to /patient/schedule-consent");
    } else {
      console.log("   ❌ Score <80% → Cannot schedule yet");
      console.log("   Read more materials or chat with AI");
    }
  },

  /**
   * Simulate completing all materials
   */
  completeAllMaterials() {
    const patient = JSON.parse(localStorage.getItem("currentPatient") || "{}");
    if (!patient.id) {
      console.error("❌ No patient data found");
      return;
    }

    patient.comprehensionScore = 85;
    patient.status = "ready";
    localStorage.setItem("currentPatient", JSON.stringify(patient));
    
    console.log("✅ Simulated: All materials completed");
    console.log("   Score: 85%");
    console.log("   Status: READY");
    console.log("   Navigate to /patient to see final state");
  },

  /**
   * Clear all localStorage data
   */
  clearAll() {
    localStorage.clear();
    console.log("✅ All localStorage cleared");
    console.log("   Refresh page to start fresh");
  },

  /**
   * Show current state
   */
  showState() {
    const patient = JSON.parse(localStorage.getItem("currentPatient") || "{}");
    
    if (!patient.id) {
      console.log("ℹ️  No patient data found");
      console.log("   Run TestHelper.seedPatient() to start");
      return;
    }

    console.log("📊 Current State:");
    console.log("─────────────────────────────────────");
    console.log(`   Name: ${patient.fullName}`);
    console.log(`   MRN: ${patient.mrn}`);
    console.log(`   Anesthesia Type: ${patient.anesthesiaType}`);
    console.log(`   Status: ${patient.status}`);
    console.log(`   Comprehension Score: ${patient.comprehensionScore}%`);
    console.log(`   Surgery: ${patient.surgeryType}`);
    console.log(`   Surgery Date: ${patient.surgeryDate}`);
    console.log("─────────────────────────────────────");
  },

  /**
   * Quick test sequence
   */
  quickTest() {
    console.log("🚀 Starting Quick Test Sequence...\n");
    
    console.log("1️⃣  Seeding test patient (General Anesthesia)...");
    this.seedPatient('general');
    
    console.log("\n2️⃣  Checking auto-filter...");
    this.checkAutoFilter();
    
    console.log("\n3️⃣  Setting initial score to 60%...");
    this.setScore(60);
    
    console.log("\n4️⃣  Next steps:");
    console.log("   a) Navigate to /patient");
    console.log("   b) Verify ONLY 3 materials visible");
    console.log("   c) Click [Mulai] on any material");
    console.log("   d) Complete reading + chat");
    console.log("   e) Check final score ≥80%");
    console.log("   f) Schedule consent\n");
    
    console.log("💡 Tips:");
    console.log("   TestHelper.showState()          - See current state");
    console.log("   TestHelper.completeAllMaterials() - Skip to final state");
    console.log("   TestHelper.clearAll()           - Reset everything");
    console.log("\n🔄 Test 3-Way Sync:");
    console.log("   1. Open /admin in new tab");
    console.log("   2. Open /doctor in another tab");
    console.log("   3. Open /patient in another tab");
    console.log("   4. Watch all dashboards sync every 2s!");
  },

  /**
   * Test auto-filter with different types
   */
  testAllTypes() {
    console.log("🧪 Testing Auto-Filter with All Types...\n");
    
    const types = ['general', 'spinal', 'epidural'];
    
    types.forEach((type, idx) => {
      console.log(`${idx + 1}. Testing ${type.toUpperCase()}:`);
      this.seedPatient(type);
      this.checkAutoFilter();
      console.log("");
    });
    
    console.log("✅ All types seeded. Check /patient for each to verify filter.");
  },

  /**
   * Show help
   */
  help() {
    console.log("🛠️  ACONSIA TESTING HELPER\n");
    console.log("Available Commands:");
    console.log("─────────────────────────────────────");
    console.log("TestHelper.seedPatient('type')     - Seed patient data");
    console.log("                                     Types: 'general', 'spinal', 'epidural'");
    console.log("TestHelper.checkAutoFilter()       - Verify auto-filter working");
    console.log("TestHelper.setScore(score)         - Set comprehension score (0-100)");
    console.log("TestHelper.completeAllMaterials()  - Simulate completion");
    console.log("TestHelper.showState()             - Show current state");
    console.log("TestHelper.clearAll()              - Clear all data");
    console.log("TestHelper.quickTest()             - Run quick test sequence");
    console.log("TestHelper.testAllTypes()          - Test all anesthesia types");
    console.log("TestHelper.help()                  - Show this help");
    console.log("─────────────────────────────────────\n");
    console.log("Quick Start:");
    console.log("1. TestHelper.quickTest()");
    console.log("2. Navigate to /patient");
    console.log("3. Verify auto-filter works\n");
  }
};

// Auto-show help on load
console.log("%c🧪 ACONSIA Testing Helper Loaded!", "color: #4CAF50; font-weight: bold; font-size: 16px;");
console.log("Type %cTestHelper.help()%c for available commands", "color: #2196F3; font-weight: bold;", "");
console.log("Quick start: %cTestHelper.quickTest()%c", "color: #2196F3; font-weight: bold;", "");