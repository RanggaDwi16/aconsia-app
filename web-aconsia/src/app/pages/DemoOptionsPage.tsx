import { Button } from "../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { useNavigate } from "react-router";
import { ArrowLeft, UserPlus, Stethoscope, BookOpen, CheckCircle } from "lucide-react";

export function DemoOptionsPage() {
  const navigate = useNavigate();

  const setupDemoPatient = () => {
    // Simulasi pasien yang SUDAH ISI DATA, tapi masih pending approval
    const demoPatient = {
      id: "demo-patient-pending",
      fullName: "Siti Rahayu",
      nik: "3273012345678901",
      mrn: "MR001234",
      dateOfBirth: "1985-05-15",
      age: "40",
      gender: "female",
      religion: "Islam",
      maritalStatus: "married",
      education: "SMA",
      occupation: "Ibu Rumah Tangga",
      phone: "08123456789",
      email: "siti.rahayu@demo.com",
      address: "Jl. Merdeka No. 123",
      rt: "001",
      rw: "002",
      kelurahan: "Kebayoran Baru",
      kecamatan: "Kebayoran Baru",
      city: "Jakarta Selatan",
      province: "DKI Jakarta",
      guardianName: "Ahmad Rahayu (Suami)",
      guardianPhone: "08129876543",
      guardianRelation: "Suami",
      medicalHistory: "Hipertensi ringan, terkontrol dengan obat",
      allergies: "Tidak ada alergi obat",
      currentMedications: "Amlodipin 5mg (1x sehari)",
      previousAnesthesia: "Tidak ada",
      weight: "65",
      height: "160",
      anesthesiologistName: "dr. Siti Rahmawati, Sp.An",
      // Status PENDING - menunggu dokter isi data medis
      status: "pending",
      comprehensionScore: 0,
      // Field yang akan diisi DOKTER (masih null):
      diagnosis: null,
      surgeryType: null,
      surgeryDate: null,
      anesthesiaType: null,
      approvedBy: null,
      approvedAt: null,
    };

    localStorage.setItem(`patient-${demoPatient.id}`, JSON.stringify(demoPatient));
    localStorage.setItem("currentPatientId", demoPatient.id);
    
    alert("✅ Demo Patient Created!\n\nNama: Siti Rahayu\nStatus: Pending (menunggu approval dokter)\n\nSilakan login sebagai dokter untuk approve data medis.");
  };

  const setupApprovedPatient = () => {
    // Simulasi pasien yang SUDAH DI-APPROVE dokter, siap belajar
    const approvedPatient = {
      id: "demo-patient-approved",
      fullName: "Budi Santoso",
      nik: "3273019876543210",
      mrn: "MR005678",
      dateOfBirth: "1990-08-20",
      age: "35",
      gender: "male",
      religion: "Islam",
      maritalStatus: "married",
      education: "S1",
      occupation: "Karyawan Swasta",
      phone: "08567890123",
      email: "budi.santoso@demo.com",
      address: "Jl. Sudirman No. 456",
      rt: "003",
      rw: "005",
      kelurahan: "Sukajadi",
      kecamatan: "Coblong",
      city: "Bandung",
      province: "Jawa Barat",
      guardianName: "Ani Santoso",
      guardianRelation: "Istri",
      guardianPhone: "08567890999",
      medicalHistory: "Sehat, tidak ada riwayat penyakit kronis",
      allergies: "Tidak ada",
      currentMedications: "Tidak ada",
      previousAnesthesia: "Tidak ada",
      weight: "75",
      height: "175",
      // Status APPROVED - sudah lengkap dengan data medis dari dokter
      status: "approved",
      comprehensionScore: 0,
      // Data medis SUDAH DIISI oleh dokter:
      diagnosis: "Acute Appendicitis (Usus Buntu Akut)",
      surgeryType: "Appendectomy (Operasi Pengangkatan Usus Buntu)",
      surgeryDate: "2026-03-20",
      anesthesiaType: "General Anesthesia",
      anesthesiologistName: "dr. Ahmad Hidayat, Sp.An",
      approvedBy: "dr. Ahmad Hidayat, Sp.An",
      approvedAt: new Date().toISOString(),
    };

    localStorage.setItem(`patient-${approvedPatient.id}`, JSON.stringify(approvedPatient));
    localStorage.setItem("currentPatientId", approvedPatient.id);
    
    alert("✅ Demo Patient Created!\n\nNama: Budi Santoso\nStatus: Approved (siap belajar)\nJenis Anestesi: General Anesthesia\n\nAnda bisa langsung login sebagai pasien untuk mulai belajar.");
  };

  const setupCompleteFlow = () => {
    // Setup BOTH: 1 pending patient + 1 approved patient
    const pendingPatient = {
      id: "demo-patient-pending-2",
      fullName: "Dewi Lestari",
      nik: "3201015555666777",
      mrn: "MR002468",
      dateOfBirth: "1992-11-10",
      age: "33",
      gender: "female",
      religion: "Islam",
      maritalStatus: "married",
      education: "S1",
      occupation: "Guru",
      phone: "08111222333",
      email: "dewi.lestari@demo.com",
      address: "Jl. Asia Afrika No. 789",
      rt: "002",
      rw: "003",
      kelurahan: "Gubeng",
      kecamatan: "Gubeng",
      city: "Surabaya",
      province: "Jawa Timur",
      guardianName: "Rudi Lestari",
      guardianRelation: "Suami",
      guardianPhone: "08111222444",
      medicalHistory: "Tidak ada",
      allergies: "Alergi Penisilin",
      currentMedications: "Tidak ada",
      previousAnesthesia: "Tidak ada",
      weight: "58",
      height: "162",
      anesthesiologistName: "dr. Maya Kusuma, Sp.An",
      status: "pending",
      comprehensionScore: 0,
      diagnosis: null,
      surgeryType: null,
      surgeryDate: null,
      anesthesiaType: null,
      approvedBy: null,
      approvedAt: null,
    };

    const approvedPatient = {
      id: "demo-patient-approved-2",
      fullName: "Rini Kartika",
      nik: "3578012222333444",
      mrn: "MR007890",
      dateOfBirth: "1988-03-25",
      age: "38",
      gender: "female",
      religion: "Kristen Protestan",
      maritalStatus: "married",
      education: "S1",
      occupation: "Dokter Umum",
      phone: "08777888999",
      email: "rini.kartika@demo.com",
      address: "Jl. Gatot Subroto No. 321",
      rt: "004",
      rw: "007",
      kelurahan: "Tembalang",
      kecamatan: "Tembalang",
      city: "Semarang",
      province: "Jawa Tengah",
      guardianName: "Budi Kartika",
      guardianRelation: "Suami",
      guardianPhone: "08777888777",
      medicalHistory: "Tidak ada",
      allergies: "Tidak ada",
      currentMedications: "Tidak ada",
      previousAnesthesia: "Tidak ada",
      weight: "62",
      height: "165",
      anesthesiologistName: "dr. Siti Nurhaliza, Sp.An",
      status: "approved",
      comprehensionScore: 35,
      diagnosis: "Cholelithiasis (Batu Empedu)",
      surgeryType: "Laparoscopic Cholecystectomy",
      surgeryDate: "2026-03-25",
      anesthesiaType: "Spinal Anesthesia",
      approvedBy: "dr. Siti Nurhaliza, Sp.An",
      approvedAt: new Date().toISOString(),
    };

    localStorage.setItem(`patient-${pendingPatient.id}`, JSON.stringify(pendingPatient));
    localStorage.setItem(`patient-${approvedPatient.id}`, JSON.stringify(approvedPatient));
    
    alert("✅ Complete Demo Setup Created!\n\n1. Dewi Lestari (Pending) - menunggu approval dokter\n2. Rini Kartika (Approved) - siap belajar dengan progress 35%\n\nSilakan explore full flow!");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50 p-8">
      <div className="max-w-5xl mx-auto">
        <Button 
          variant="ghost" 
          onClick={() => navigate('/')}
          className="mb-8"
        >
          <ArrowLeft className="w-4 h-4 mr-2" />
          Kembali ke Home
        </Button>

        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            🎬 Demo Mode - Pilih Skenario
          </h1>
          <p className="text-lg text-gray-600">
            Pilih skenario demo untuk melihat sistem bekerja dengan data simulasi
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-6">
          {/* Scenario 1: Pending Patient */}
          <Card className="border-2 border-yellow-300 hover:shadow-xl transition-shadow">
            <CardHeader className="bg-yellow-50">
              <div className="w-16 h-16 bg-yellow-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <UserPlus className="w-8 h-8 text-yellow-600" />
              </div>
              <CardTitle className="text-center text-xl">
                Skenario 1: Sudah Daftar
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6">
              <div className="space-y-3 mb-6">
                <p className="text-sm text-gray-600">
                  <strong>Pasien:</strong> Siti Rahayu
                </p>
                <p className="text-sm text-gray-600">
                  <strong>Status:</strong> <span className="text-yellow-600 font-semibold">Pending</span>
                </p>
                <p className="text-sm text-gray-700 mt-4">
                  ✅ Data identitas sudah lengkap (23 fields)<br />
                  ⏳ Menunggu dokter isi diagnosis medis<br />
                  ⏳ Belum bisa mulai belajar
                </p>
              </div>
              <Button 
                className="w-full bg-yellow-600 hover:bg-yellow-700"
                onClick={setupDemoPatient}
              >
                Setup Demo Ini
              </Button>
            </CardContent>
          </Card>

          {/* Scenario 2: Approved Patient */}
          <Card className="border-2 border-green-300 hover:shadow-xl transition-shadow">
            <CardHeader className="bg-green-50">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <CheckCircle className="w-8 h-8 text-green-600" />
              </div>
              <CardTitle className="text-center text-xl">
                Skenario 2: Sudah Di-ACC
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6">
              <div className="space-y-3 mb-6">
                <p className="text-sm text-gray-600">
                  <strong>Pasien:</strong> Budi Santoso
                </p>
                <p className="text-sm text-gray-600">
                  <strong>Status:</strong> <span className="text-green-600 font-semibold">Approved</span>
                </p>
                <p className="text-sm text-gray-700 mt-4">
                  ✅ Data lengkap + diagnosis dari dokter<br />
                  ✅ Jenis anestesi: General Anesthesia<br />
                  ✅ Siap mulai belajar materi
                </p>
              </div>
              <Button 
                className="w-full bg-green-600 hover:bg-green-700"
                onClick={setupApprovedPatient}
              >
                Setup Demo Ini
              </Button>
            </CardContent>
          </Card>

          {/* Scenario 3: Complete Flow */}
          <Card className="border-2 border-blue-300 hover:shadow-xl transition-shadow">
            <CardHeader className="bg-blue-50">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Stethoscope className="w-8 h-8 text-blue-600" />
              </div>
              <CardTitle className="text-center text-xl">
                Skenario 3: Full Demo
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6">
              <div className="space-y-3 mb-6">
                <p className="text-sm text-gray-600">
                  <strong>2 Pasien:</strong> Pending + Approved
                </p>
                <p className="text-sm text-gray-700 mt-4">
                  👥 Dewi Lestari (Pending)<br />
                  👥 Rini Kartika (Approved - 35% progress)<br />
                  🔄 Test full workflow end-to-end
                </p>
              </div>
              <Button 
                className="w-full bg-blue-600 hover:bg-blue-700"
                onClick={setupCompleteFlow}
              >
                Setup Full Demo
              </Button>
            </CardContent>
          </Card>
        </div>

        {/* Quick Access Links */}
        <div className="mt-12 p-8 bg-white rounded-lg shadow-lg">
          <h2 className="text-2xl font-bold mb-6 text-center">Quick Access untuk Testing</h2>
          <div className="grid md:grid-cols-2 gap-4">
            <Button 
              variant="outline" 
              onClick={() => navigate('/login')}
              className="w-full justify-start"
            >
              <Stethoscope className="w-5 h-5 mr-3" />
              Login sebagai Dokter
            </Button>
            <Button 
              variant="outline" 
              onClick={() => navigate('/patient')}
              className="w-full justify-start"
            >
              <BookOpen className="w-5 h-5 mr-3" />
              Login sebagai Pasien
            </Button>
            <Button 
              variant="outline" 
              onClick={() => navigate('/register')}
              className="w-full justify-start"
            >
              <UserPlus className="w-5 h-5 mr-3" />
              Registrasi Pasien Baru
            </Button>
            <Button 
              variant="outline" 
              onClick={() => navigate('/doctor/approval')}
              className="w-full justify-start"
            >
              <CheckCircle className="w-5 h-5 mr-3" />
              Form Approval Dokter
            </Button>
          </div>
        </div>

        {/* Instructions */}
        <div className="mt-8 p-6 bg-purple-50 border-2 border-purple-200 rounded-lg">
          <h3 className="font-bold text-lg mb-3">📝 Cara Menggunakan Demo:</h3>
          <ol className="space-y-2 text-sm text-gray-700">
            <li>1️⃣ Pilih salah satu skenario di atas dan klik "Setup Demo Ini"</li>
            <li>2️⃣ Data demo akan tersimpan di localStorage browser</li>
            <li>3️⃣ Gunakan Quick Access untuk navigate ke halaman yang ingin dicoba</li>
            <li>4️⃣ Test full flow: Registrasi → Dokter Approval → Pasien Belajar → Quiz</li>
            <li>5️⃣ Refresh browser untuk reset (localStorage akan terhapus)</li>
          </ol>
        </div>
      </div>
    </div>
  );
}