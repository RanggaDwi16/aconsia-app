import { useState, useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Badge } from "../../components/ui/badge";
import {
  User,
  Heart,
  FileText,
  Calendar,
  CheckCircle,
  AlertCircle,
  ArrowLeft,
  Stethoscope,
} from "lucide-react";
import { getDesktopSession } from "../../../core/auth/session";
import {
  approvePatient,
  getPatientForApproval,
  rejectPatient,
} from "../../../modules/doctor/services/patientApprovalService";
import { writeAuditLog } from "../../../modules/admin/services/auditWriterService";

function localApprovalFallbackEnabled() {
  return import.meta.env.VITE_ALLOW_LOCALSTORAGE_PATIENT_APPROVAL_FALLBACK === "true";
}

export function PatientApprovalNew() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const patientId = searchParams.get("patientId");

  const [patient, setPatient] = useState<any>(null);
  const [medicalData, setMedicalData] = useState({
    diagnosis: "",
    surgeryType: "",
    anesthesiaType: "",
  });

  useEffect(() => {
    const loadPatient = async () => {
      if (!patientId) return;

      try {
        const firestorePatient = await getPatientForApproval(patientId);
        if (firestorePatient) {
          setPatient(firestorePatient);
          setMedicalData({
            diagnosis: firestorePatient.diagnosis || "",
            surgeryType: firestorePatient.surgeryType || "",
            anesthesiaType: firestorePatient.anesthesiaType || "",
          });
          return;
        }
      } catch (error) {
        console.warn("[PatientApproval] Firestore load failed, fallback mode", error);
      }

      // fallback local storage mode
      const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
      const foundPatient = demoPatients.find((p: any) => p.id === patientId);

      if (foundPatient) {
        setPatient(foundPatient);
        setMedicalData({
          diagnosis: foundPatient.diagnosis || "",
          surgeryType: foundPatient.surgeryType || "",
          anesthesiaType: foundPatient.anesthesiaType || "",
        });
      }
    };

    void loadPatient();
  }, [patientId]);

  const handleChange = (field: string, value: string) => {
    setMedicalData((prev) => ({ ...prev, [field]: value }));
  };

  const handleApprove = async () => {
    if (!medicalData.diagnosis || !medicalData.surgeryType || !medicalData.anesthesiaType) {
      alert("Mohon lengkapi semua data medis!");
      return;
    }

    const session = getDesktopSession();

    try {
      const result = await approvePatient({
        pasienId: patient.id,
        diagnosis: medicalData.diagnosis,
        surgeryType: medicalData.surgeryType,
        anesthesiaType: medicalData.anesthesiaType,
      });

      if (result.mode === "fallback" && session?.uid) {
        await writeAuditLog({
          actorUid: session.uid,
          actorRole: "doctor",
          actorName: session.displayName || session.email,
          actionType: "APPROVE_PATIENT",
          entityType: "pasien_profiles",
          entityId: patient.id,
          message: `Approved patient ${patient.fullName} with ${medicalData.anesthesiaType}`,
        });
      }

      alert(
        `✅ PASIEN BERHASIL DISETUJUI!\n\n` +
          `Nama: ${patient.fullName}\n` +
          `Diagnosis: ${medicalData.diagnosis}\n` +
          `Jenis Anestesi: ${medicalData.anesthesiaType}`,
      );
      navigate("/doctor");
      return;
    } catch (error) {
      if (!localApprovalFallbackEnabled()) {
        console.error("[PatientApproval] Approve failed", error);
        alert(
          "Approve pasien gagal. Pastikan Firebase Functions sudah deploy dan koneksi stabil.",
        );
        return;
      }
      console.warn("[PatientApproval] Approve failed, fallback localStorage mode", error);
    }

    // Update patient data
    const updatedPatient = {
      ...patient,
      ...medicalData,
      status: "approved",
      approvalDate: new Date().toISOString(),
      totalMaterials: 10, // Set total materials
    };

    // ✅ SYNC TO MULTIPLE LOCATIONS
    
    // 1. Update demoPatients array (MOST IMPORTANT!)
    const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
    const updatedDemoPatients = demoPatients.map((p: any) =>
      p.id === updatedPatient.id ? updatedPatient : p
    );
    localStorage.setItem("demoPatients", JSON.stringify(updatedDemoPatients));
    
    // 2. Update patient_{NIK} (for patient login)
    localStorage.setItem(`patient_${updatedPatient.nik}`, JSON.stringify(updatedPatient));
    
    // 3. Update currentPatient if same ID
    const currentPatient = localStorage.getItem("currentPatient");
    if (currentPatient) {
      const current = JSON.parse(currentPatient);
      if (current.id === updatedPatient.id) {
        localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
      }
    }

    console.log("✅ Patient approved and synced:", updatedPatient);

    alert(
      `✅ PASIEN BERHASIL DISETUJUI!\n\n` +
      `Nama: ${updatedPatient.fullName}\n` +
      `Diagnosis: ${medicalData.diagnosis}\n` +
      `Jenis Anestesi: ${medicalData.anesthesiaType}\n\n` +
      `Pasien sekarang bisa mengakses materi pembelajaran yang relevan.`
    );
    
    navigate("/doctor");
  };

  const handleReject = async () => {
    if (!confirm("Yakin ingin menolak pasien ini?")) return;

    const session = getDesktopSession();

    try {
      const result = await rejectPatient({ pasienId: patient.id });

      if (result.mode === "fallback" && session?.uid) {
        await writeAuditLog({
          actorUid: session.uid,
          actorRole: "doctor",
          actorName: session.displayName || session.email,
          actionType: "REJECT_PATIENT",
          entityType: "pasien_profiles",
          entityId: patient.id,
          message: `Rejected patient ${patient.fullName}`,
        });
      }

      alert("Pasien ditolak.");
      navigate("/doctor/dashboard");
      return;
    } catch (error) {
      if (!localApprovalFallbackEnabled()) {
        console.error("[PatientApproval] Reject failed", error);
        alert(
          "Reject pasien gagal. Pastikan Firebase Functions sudah deploy dan koneksi stabil.",
        );
        return;
      }
      console.warn("[PatientApproval] Reject failed, fallback localStorage mode", error);
    }

    const updatedPatient = {
      ...patient,
      status: "rejected",
      rejectionDate: new Date().toISOString(),
    };

    const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
    const updatedDemoPatients = demoPatients.map((p: any) =>
      p.id === updatedPatient.id ? updatedPatient : p,
    );
    localStorage.setItem("demoPatients", JSON.stringify(updatedDemoPatients));
    
    const currentPatient = localStorage.getItem("currentPatient");
    if (currentPatient) {
      const current = JSON.parse(currentPatient);
      if (current.id === patient.id) {
        localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
      }
    }

    alert("Pasien ditolak.");
    navigate("/doctor/dashboard");
  };

  if (!patient) {
    return (
      <DoctorLayout>
        <div className="p-8">
          <Card>
            <CardContent className="p-8 text-center">
              <AlertCircle className="w-16 h-16 text-red-600 mx-auto mb-4" />
              <h3 className="text-xl font-bold mb-2">Pasien Tidak Ditemukan</h3>
              <Button onClick={() => navigate("/doctor/dashboard")}>
                Kembali ke Dashboard
              </Button>
            </CardContent>
          </Card>
        </div>
      </DoctorLayout>
    );
  }

  return (
    <DoctorLayout>
      <div className="p-8">
        {/* Header */}
        <div className="mb-6 flex items-center gap-4">
          <Button
            variant="outline"
            onClick={() => navigate("/doctor/dashboard")}
            className="border-gray-300"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Kembali
          </Button>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Review & Approval Pasien</h1>
            <p className="text-sm text-gray-600 mt-1">
              Lengkapi data medis untuk melanjutkan edukasi pasien
            </p>
          </div>
        </div>

        <div className="grid lg:grid-cols-3 gap-6">
          {/* Left: Patient Info */}
          <div className="lg:col-span-1 space-y-4">
            {/* Identity Card */}
            <Card className="border-blue-200">
              <CardHeader className="bg-blue-50">
                <CardTitle className="text-lg flex items-center gap-2">
                  <User className="w-5 h-5 text-blue-600" />
                  Identitas Pasien
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-4 space-y-3">
                <div>
                  <p className="text-xs text-gray-500">Nama Lengkap</p>
                  <p className="font-semibold text-gray-900">{patient.fullName}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">No. Rekam Medis</p>
                  <p className="font-semibold text-blue-600">{patient.mrn}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">NIK</p>
                  <p className="font-medium text-gray-900">{patient.nik}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Tanggal Lahir</p>
                  <p className="font-medium text-gray-900">
                    {new Date(patient.dateOfBirth).toLocaleDateString("id-ID", {
                      day: "numeric",
                      month: "long",
                      year: "numeric",
                    })}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Umur</p>
                  <p className="font-medium text-gray-900">{patient.age} tahun</p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Jenis Kelamin</p>
                  <p className="font-medium text-gray-900">
                    {patient.gender === "male" ? "Laki-laki" : "Perempuan"}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">No. Telepon</p>
                  <p className="font-medium text-gray-900">{patient.phone}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Alamat</p>
                  <p className="text-sm text-gray-900">{patient.address}</p>
                </div>
              </CardContent>
            </Card>

            {/* Health Info */}
            <Card className="border-red-200">
              <CardHeader className="bg-red-50">
                <CardTitle className="text-lg flex items-center gap-2">
                  <Heart className="w-5 h-5 text-red-600" />
                  Data Kesehatan
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-4 space-y-3">
                <div className="grid grid-cols-3 gap-2">
                  <div>
                    <p className="text-xs text-gray-500">Tinggi</p>
                    <p className="font-semibold text-gray-900">{patient.height} cm</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">Berat</p>
                    <p className="font-semibold text-gray-900">{patient.weight} kg</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">Gol. Darah</p>
                    <Badge className="bg-red-100 text-red-800">{patient.bloodType}</Badge>
                  </div>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Alergi</p>
                  <p className="text-sm text-gray-900">{patient.allergies || "Tidak ada"}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Riwayat Penyakit</p>
                  <p className="text-sm text-gray-900">
                    {patient.medicalHistory || "Tidak ada"}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Obat Saat Ini</p>
                  <p className="text-sm text-gray-900">
                    {patient.currentMedications || "Tidak ada"}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Riwayat Anestesi</p>
                  <p className="text-sm text-gray-900">
                    {patient.previousAnesthesia || "Belum pernah"}
                  </p>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Right: Medical Data Form */}
          <div className="lg:col-span-2">
            <Card className="border-green-200">
              <CardHeader className="bg-green-50">
                <CardTitle className="text-lg flex items-center gap-2">
                  <Stethoscope className="w-5 h-5 text-green-600" />
                  Lengkapi Data Medis & Operasi
                </CardTitle>
                <p className="text-sm text-gray-600 mt-2">
                  Data ini akan menentukan konten edukasi yang diterima pasien
                </p>
              </CardHeader>
              <CardContent className="pt-6">
                <div className="space-y-6">
                  {/* Diagnosis */}
                  <div className="space-y-2">
                    <Label className="text-base font-semibold">
                      Diagnosis Medis <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      placeholder="Contoh: Appendicitis Acute, Cholelithiasis, dll"
                      value={medicalData.diagnosis}
                      onChange={(e) => handleChange("diagnosis", e.target.value)}
                      className="text-base"
                    />
                    <p className="text-xs text-gray-500">
                      Diagnosis utama yang memerlukan tindakan operasi
                    </p>
                  </div>

                  {/* Surgery Type */}
                  <div className="space-y-2">
                    <Label className="text-base font-semibold">
                      Jenis Operasi <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      placeholder="Contoh: Appendektomi, Kolesistektomi, Operasi Caesar, dll"
                      value={medicalData.surgeryType}
                      onChange={(e) => handleChange("surgeryType", e.target.value)}
                      className="text-base"
                    />
                    <p className="text-xs text-gray-500">
                      Nama tindakan operasi yang akan dilakukan
                    </p>
                  </div>

                  {/* Anesthesia Type - CRITICAL! */}
                  <div className="space-y-2">
                    <Label className="text-base font-semibold">
                      Jenis Anestesi <span className="text-red-600">*</span>
                    </Label>
                    
                    {/* GUIDELINE BOX - PANDUAN PEMILIHAN */}
                    <div className="bg-gradient-to-r from-purple-50 to-blue-50 border-2 border-purple-200 rounded-lg p-4 mb-3">
                      <h4 className="font-bold text-sm text-purple-900 mb-3 flex items-center gap-2">
                        <Stethoscope className="w-4 h-4" />
                        Panduan Pemilihan Jenis Anestesi:
                      </h4>
                      <div className="space-y-2 text-xs">
                        <div className="bg-white rounded p-2 border border-purple-100">
                          <p className="font-semibold text-purple-900">🔴 Anestesi Umum (General)</p>
                          <p className="text-gray-700 mt-1">
                            <strong>Indikasi:</strong> Operasi mayor (bedah kepala, leher, dada, perut besar, jantung, otak), 
                            operasi lama, pasien tidak kooperatif, bayi/anak kecil
                          </p>
                          <p className="text-gray-600 text-xs mt-1">
                            Contoh: Kraniotomi, operasi jantung, laparotomi, appendektomi, kolesistektomi
                          </p>
                        </div>
                        
                        <div className="bg-white rounded p-2 border border-blue-100">
                          <p className="font-semibold text-blue-900">🔵 Anestesi Regional (Spinal/Epidural)</p>
                          <p className="text-gray-700 mt-1">
                            <strong>Indikasi:</strong> Operasi ekstremitas bawah, pelvis, perineum, sectio caesarea, 
                            pasien dengan risiko tinggi GA
                          </p>
                          <p className="text-gray-600 text-xs mt-1">
                            Contoh: SC, operasi hernia, ORIF femur, TUR-P, hemorrhoidectomy
                          </p>
                        </div>
                        
                        <div className="bg-white rounded p-2 border border-green-100">
                          <p className="font-semibold text-green-900">🟢 Anestesi Lokal + Sedasi</p>
                          <p className="text-gray-700 mt-1">
                            <strong>Indikasi:</strong> Operasi minor, superfisial, area terbatas, 
                            pasien kooperatif, rawat jalan
                          </p>
                          <p className="text-gray-600 text-xs mt-1">
                            Contoh: Eksisi lipoma, biopsi, operasi katarak, ekstraksi gigi, sirkumsisi
                          </p>
                        </div>
                      </div>
                    </div>

                    <select
                      className="w-full border-2 border-gray-300 rounded-md p-3 text-base font-semibold focus:border-purple-500 focus:ring-2 focus:ring-purple-200"
                      value={medicalData.anesthesiaType}
                      onChange={(e) => handleChange("anesthesiaType", e.target.value)}
                    >
                      <option value="">-- Pilih Jenis Anestesi Berdasarkan Kondisi Pasien --</option>
                      <option value="general">🔴 Anestesi Umum (General Anesthesia)</option>
                      <option value="spinal">🔵 Anestesi Spinal (Regional)</option>
                      <option value="epidural">🔵 Anestesi Epidural (Regional)</option>
                      <option value="regional">🔵 Anestesi Regional (Blok Saraf)</option>
                      <option value="local">🟢 Anestesi Lokal + Sedasi</option>
                    </select>
                    
                    <div className="bg-blue-50 border border-blue-200 rounded-lg p-3 mt-2">
                      <p className="text-xs text-blue-800">
                        <strong>⚠️ SISTEM AUTO-FILTER:</strong> Setelah Anda memilih jenis anestesi, 
                        sistem akan <strong>OTOMATIS MEMFILTER</strong> konten pembelajaran yang relevan. 
                        Pasien hanya akan melihat materi yang sesuai dengan jenis anestesi yang Anda pilih.
                      </p>
                      <p className="text-xs text-blue-700 mt-2">
                        <strong>Contoh:</strong> Jika Anda pilih "Anestesi Umum" untuk pasien dengan operasi kepala, 
                        maka pasien hanya akan melihat materi tentang general anestesi (risiko, prosedur, persiapan GA), 
                        TIDAK akan melihat materi regional atau lokal.
                      </p>
                    </div>
                  </div>

                  {/* Action Buttons */}
                  <div className="flex gap-4 pt-6 border-t">
                    <Button
                      onClick={handleApprove}
                      className="flex-1 bg-green-600 hover:bg-green-700 h-12 text-base"
                    >
                      <CheckCircle className="w-5 h-5 mr-2" />
                      Setujui & Aktifkan Edukasi
                    </Button>
                    <Button
                      variant="outline"
                      onClick={handleReject}
                      className="border-red-300 text-red-600 hover:bg-red-50 h-12 text-base"
                    >
                      Tolak
                    </Button>
                  </div>

                  <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                    <p className="text-sm text-yellow-800">
                      <strong>💡 Catatan:</strong> Setelah disetujui, pasien akan dapat
                      mengakses materi pembelajaran yang sesuai dengan jenis anestesi yang
                      dipilih. Pasien perlu mencapai pemahaman minimal 80% sebelum dapat
                      menjadwalkan tanda tangan informed consent.
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </DoctorLayout>
  );
}