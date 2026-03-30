import { useState, useCallback } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { useNavigate } from "react-router";
import {
  User,
  FileText,
  Heart,
  Stethoscope,
  ArrowRight,
  ArrowLeft,
  CheckCircle,
} from "lucide-react";

interface PatientFormData {
  // Step 1: Identitas (SIMPLIFIED - hapus asuransi, kode pos, golongan darah)
  nik: string;
  fullName: string;
  dateOfBirth: string;
  age: string;
  gender: string;
  religion: string;
  maritalStatus: string;
  education: string;
  occupation: string;
  phone: string;
  email: string;
  address: string;
  rt: string;
  rw: string;
  kelurahan: string;
  kecamatan: string;
  city: string;
  province: string;
  guardianName: string;
  guardianRelation: string;
  guardianPhone: string;

  // Step 2: Data Medis (TANPA golongan darah)
  mrn: string; // Auto-generated
  weight: string;
  height: string;

  // Step 3: Riwayat Kesehatan
  allergies: string;
  medicalHistory: string;
  currentMedications: string;
  previousAnesthesia: string;

  // Step 4: Pilih Dokter Anestesi
  anesthesiologistName: string;
  anesthesiologistId: string;
}

export function PatientRegistrationSimplified() {
  const navigate = useNavigate();
  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState<PatientFormData>({
    nik: "",
    fullName: "",
    dateOfBirth: "",
    age: "",
    gender: "",
    religion: "",
    maritalStatus: "",
    education: "",
    occupation: "",
    phone: "",
    email: "",
    address: "",
    rt: "",
    rw: "",
    kelurahan: "",
    kecamatan: "",
    city: "",
    province: "",
    guardianName: "",
    guardianRelation: "",
    guardianPhone: "",
    mrn: `MR${Date.now().toString().slice(-6)}`, // Auto-generate
    weight: "",
    height: "",
    allergies: "",
    medicalHistory: "",
    currentMedications: "",
    previousAnesthesia: "",
    anesthesiologistName: "",
    anesthesiologistId: "",
  });

  const handleChange = (field: keyof PatientFormData, value: string) => {
    setFormData((prev) => {
      const updated = { ...prev, [field]: value };
      
      // Auto-calculate age when dateOfBirth changes
      if (field === "dateOfBirth" && value) {
        const birthDate = new Date(value);
        const today = new Date();
        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        
        // Adjust if birthday hasn't occurred this year yet
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
          age--;
        }
        
        updated.age = String(age);
      }
      
      return updated;
    });
  };

  const validateStep = (step: number): boolean => {
    if (step === 1) {
      return !!(
        formData.nik &&
        formData.fullName &&
        formData.dateOfBirth &&
        formData.gender &&
        formData.phone &&
        formData.address
      );
    }
    if (step === 2) {
      return !!(formData.weight && formData.height);
    }
    if (step === 3) {
      return true; // Optional fields
    }
    if (step === 4) {
      return !!formData.anesthesiologistName;
    }
    return false;
  };

  const handleNext = () => {
    if (!validateStep(currentStep)) {
      alert("Mohon lengkapi data wajib yang ditandai (*)");
      return;
    }
    setCurrentStep((prev) => Math.min(prev + 1, 4));
  };

  const handleBack = () => {
    setCurrentStep((prev) => Math.max(prev - 1, 1));
  };

  const handleSubmit = () => {
    if (!validateStep(4)) {
      alert("Mohon pilih dokter anestesi!");
      return;
    }

    // Calculate age if not filled
    const calculatedAge =
      formData.age ||
      String(new Date().getFullYear() - new Date(formData.dateOfBirth).getFullYear());

    // Save to localStorage - DATA PASIEN SAJA, belum ada diagnosis/operasi/tanggal
    const patientData = {
      id: `patient-${Date.now()}`,
      ...formData,
      age: calculatedAge,
      status: "pending", // Waiting for doctor to complete medical data
      comprehensionScore: 0,
      // Fields yang akan diisi dokter:
      diagnosis: null,
      surgeryType: null,
      surgeryDate: null,
      anesthesiaType: null,
      doctorName: formData.anesthesiologistName,
      hospitalName: null,
      assignedDoctorId: formData.anesthesiologistId || "doctor-001", // ✅ TAMBAH INI!
    };

    localStorage.setItem("currentPatient", JSON.stringify(patientData));
    navigate("/patient/dashboard-new");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-cyan-50">
      <div className="container mx-auto px-4 py-8 max-w-4xl">
        {/* Header with Clear Indicator */}
        <div className="mb-8 text-center">
          <div className="inline-block bg-green-100 text-green-800 px-4 py-2 rounded-full text-xs font-semibold mb-3">
            ✅ VERSI BARU - Data Medis Diisi Dokter
          </div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Formulir Pendaftaran Pasien
          </h1>
          <p className="text-gray-600">
            Isi data diri Anda. Dokter akan melengkapi data medis setelah pendaftaran.
          </p>
        </div>

        {/* Progress Steps */}
        <div className="mb-8">
          <div className="flex items-center justify-between max-w-2xl mx-auto">
            {[1, 2, 3, 4].map((step) => (
              <div key={step} className="flex items-center">
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center font-bold transition-all ${
                    currentStep >= step
                      ? "bg-blue-600 text-white"
                      : "bg-gray-200 text-gray-600"
                  }`}
                >
                  {step}
                </div>
                {step < 4 && (
                  <div
                    className={`w-16 h-1 mx-2 ${
                      currentStep > step ? "bg-blue-600" : "bg-gray-200"
                    }`}
                  />
                )}
              </div>
            ))}
          </div>
          <div className="flex items-center justify-between max-w-2xl mx-auto mt-2">
            <p className="text-xs text-gray-600 w-20 text-center">Identitas</p>
            <p className="text-xs text-gray-600 w-20 text-center">Data Medis</p>
            <p className="text-xs text-gray-600 w-20 text-center">Riwayat</p>
            <p className="text-xs text-gray-600 w-20 text-center">Dokter</p>
          </div>
        </div>

        {/* Form Card */}
        <Card className="border-blue-200">
          <CardHeader className="bg-gradient-to-r from-blue-50 to-cyan-50">
            <CardTitle className="flex items-center gap-2">
              {currentStep === 1 && <User className="w-5 h-5 text-blue-600" />}
              {currentStep === 2 && <FileText className="w-5 h-5 text-blue-600" />}
              {currentStep === 3 && <Heart className="w-5 h-5 text-blue-600" />}
              {currentStep === 4 && <Stethoscope className="w-5 h-5 text-blue-600" />}
              {currentStep === 1 && "Data Identitas Pasien"}
              {currentStep === 2 && "Data Medis & Operasi"}
              {currentStep === 3 && "Riwayat Kesehatan"}
              {currentStep === 4 && "Informasi Dokter & Rumah Sakit"}
            </CardTitle>
          </CardHeader>
          <CardContent className="p-6">
            {/* STEP 1: IDENTITAS */}
            {currentStep === 1 && (
              <div className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2 md:col-span-2">
                    <Label>
                      NIK <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      placeholder="16 digit NIK"
                      maxLength={16}
                      value={formData.nik}
                      onChange={(e) => handleChange("nik", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2 md:col-span-2">
                    <Label>
                      Nama Lengkap <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      placeholder="Nama sesuai KTP"
                      value={formData.fullName}
                      onChange={(e) => handleChange("fullName", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>
                      Tanggal Lahir <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      type="date"
                      value={formData.dateOfBirth}
                      onChange={(e) => handleChange("dateOfBirth", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Umur</Label>
                    <Input
                      type="number"
                      placeholder="Otomatis dari tanggal lahir"
                      value={formData.age}
                      readOnly
                      className="bg-gray-50"
                    />
                    <p className="text-xs text-gray-500">
                      Otomatis dihitung dari tanggal lahir
                    </p>
                  </div>

                  <div className="space-y-2">
                    <Label>
                      Jenis Kelamin <span className="text-red-600">*</span>
                    </Label>
                    <select
                      className="w-full border border-gray-300 rounded-md p-2"
                      value={formData.gender}
                      onChange={(e) => handleChange("gender", e.target.value)}
                    >
                      <option value="">Pilih</option>
                      <option value="male">Laki-laki</option>
                      <option value="female">Perempuan</option>
                    </select>
                  </div>

                  <div className="space-y-2">
                    <Label>Agama</Label>
                    <select
                      className="w-full border border-gray-300 rounded-md p-2"
                      value={formData.religion}
                      onChange={(e) => handleChange("religion", e.target.value)}
                    >
                      <option value="">Pilih</option>
                      <option value="Islam">Islam</option>
                      <option value="Kristen Protestan">Kristen Protestan</option>
                      <option value="Kristen Katolik">Kristen Katolik</option>
                      <option value="Hindu">Hindu</option>
                      <option value="Buddha">Buddha</option>
                      <option value="Konghucu">Konghucu</option>
                      <option value="Lainnya">Lainnya</option>
                    </select>
                  </div>

                  <div className="space-y-2">
                    <Label>Status Pernikahan</Label>
                    <select
                      className="w-full border border-gray-300 rounded-md p-2"
                      value={formData.maritalStatus}
                      onChange={(e) => handleChange("maritalStatus", e.target.value)}
                    >
                      <option value="">Pilih</option>
                      <option value="single">Belum Menikah</option>
                      <option value="married">Menikah</option>
                      <option value="divorced">Cerai</option>
                    </select>
                  </div>

                  <div className="space-y-2">
                    <Label>Pendidikan Terakhir</Label>
                    <Input
                      placeholder="SD, SMP, SMA, S1, dll"
                      value={formData.education}
                      onChange={(e) => handleChange("education", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Pekerjaan</Label>
                    <Input
                      placeholder="Pegawai, Wiraswasta, dll"
                      value={formData.occupation}
                      onChange={(e) => handleChange("occupation", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>
                      No. Telepon <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      placeholder="08xxxxxxxxxx"
                      value={formData.phone}
                      onChange={(e) => handleChange("phone", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Email</Label>
                    <Input
                      type="email"
                      placeholder="email@example.com"
                      value={formData.email}
                      onChange={(e) => handleChange("email", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2 md:col-span-2">
                    <Label>
                      Alamat Lengkap <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      placeholder="Jalan, nomor rumah"
                      value={formData.address}
                      onChange={(e) => handleChange("address", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>RT</Label>
                    <Input
                      placeholder="001"
                      value={formData.rt}
                      onChange={(e) => handleChange("rt", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>RW</Label>
                    <Input
                      placeholder="002"
                      value={formData.rw}
                      onChange={(e) => handleChange("rw", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Kelurahan/Desa</Label>
                    <Input
                      value={formData.kelurahan}
                      onChange={(e) => handleChange("kelurahan", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Kecamatan</Label>
                    <Input
                      value={formData.kecamatan}
                      onChange={(e) => handleChange("kecamatan", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Kota/Kabupaten</Label>
                    <Input
                      value={formData.city}
                      onChange={(e) => handleChange("city", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Provinsi</Label>
                    <Input
                      value={formData.province}
                      onChange={(e) => handleChange("province", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Nama Penanggung Jawab</Label>
                    <Input
                      placeholder="Nama keluarga"
                      value={formData.guardianName}
                      onChange={(e) => handleChange("guardianName", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Hubungan</Label>
                    <Input
                      placeholder="Suami, Istri, Anak, dll"
                      value={formData.guardianRelation}
                      onChange={(e) => handleChange("guardianRelation", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>No. Telepon Penanggung Jawab</Label>
                    <Input
                      placeholder="08xxxxxxxxxx"
                      value={formData.guardianPhone}
                      onChange={(e) => handleChange("guardianPhone", e.target.value)}
                    />
                  </div>
                </div>
              </div>
            )}

            {/* STEP 2: DATA MEDIS - HANYA YANG PASIEN TAHU */}
            {currentStep === 2 && (
              <div className="space-y-4">
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-4">
                  <p className="text-sm text-blue-800">
                    📋 <strong>No. Rekam Medis:</strong> {formData.mrn}
                  </p>
                  <p className="text-xs text-blue-600 mt-1">
                    Nomor ini akan digunakan untuk identifikasi Anda di rumah sakit
                  </p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label>
                      Berat Badan (kg) <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      type="number"
                      placeholder="60"
                      value={formData.weight}
                      onChange={(e) => handleChange("weight", e.target.value)}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>
                      Tinggi Badan (cm) <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      type="number"
                      placeholder="165"
                      value={formData.height}
                      onChange={(e) => handleChange("height", e.target.value)}
                    />
                  </div>
                </div>

                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mt-6">
                  <p className="text-sm font-semibold text-yellow-900 mb-2">
                    ⚠️ Data yang Akan Dilengkapi oleh Dokter:
                  </p>
                  <ul className="text-sm text-yellow-800 space-y-1 list-disc list-inside">
                    <li><strong>Diagnosis Medis</strong> (contoh: Appendicitis Acute)</li>
                    <li><strong>Jenis Operasi/Tindakan</strong> (contoh: Laparoscopic Appendectomy)</li>
                    <li><strong>Tanggal Rencana Operasi</strong> (dijadwalkan oleh dokter)</li>
                    <li><strong>Jenis Anestesi</strong> (ditentukan oleh dokter anestesi)</li>
                  </ul>
                  <p className="text-xs text-yellow-700 mt-3">
                    Setelah Anda mendaftar, dokter akan melengkapi data medis ini dan menentukan jenis anestesi yang sesuai untuk Anda.
                  </p>
                </div>
              </div>
            )}

            {/* STEP 3: RIWAYAT KESEHATAN */}
            {currentStep === 3 && (
              <div className="space-y-4">
                <div className="space-y-2">
                  <Label>Alergi Obat/Makanan</Label>
                  <Input
                    placeholder="Contoh: Penisilin, Kacang, dll (atau tulis 'Tidak ada')"
                    value={formData.allergies}
                    onChange={(e) => handleChange("allergies", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label>Riwayat Penyakit</Label>
                  <textarea
                    className="w-full border border-gray-300 rounded-md p-2"
                    rows={3}
                    placeholder="Penyakit yang pernah/sedang diderita (diabetes, hipertensi, dll)"
                    value={formData.medicalHistory}
                    onChange={(e) => handleChange("medicalHistory", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label>Obat yang Sedang Dikonsumsi</Label>
                  <textarea
                    className="w-full border border-gray-300 rounded-md p-2"
                    rows={2}
                    placeholder="Nama obat dan dosis (jika ada)"
                    value={formData.currentMedications}
                    onChange={(e) => handleChange("currentMedications", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label>Riwayat Anestesi Sebelumnya</Label>
                  <Input
                    placeholder="Pernah dibius? Kapan? Ada masalah?"
                    value={formData.previousAnesthesia}
                    onChange={(e) => handleChange("previousAnesthesia", e.target.value)}
                  />
                </div>
              </div>
            )}

            {/* STEP 4: PILIH DOKTER ANESTESI */}
            {currentStep === 4 && (
              <div className="space-y-4">
                <div className="bg-cyan-50 border border-cyan-200 rounded-lg p-4 mb-4">
                  <h4 className="font-semibold text-cyan-900 mb-2">📋 Ringkasan Data</h4>
                  <div className="text-sm text-cyan-800 space-y-1">
                    <p>• Nama: <strong>{formData.fullName}</strong></p>
                    <p>• No. RM: <strong>{formData.mrn}</strong></p>
                    <p>• No. KTP: <strong>{formData.nik}</strong></p>
                  </div>
                </div>

                <div className="space-y-2">
                  <Label>
                    Nama Dokter Anestesi <span className="text-red-600">*</span>
                  </Label>
                  <select
                    className="w-full border border-gray-300 rounded-md p-2"
                    value={formData.anesthesiologistName}
                    onChange={(e) => {
                      const selectedOption = e.target.options[e.target.selectedIndex];
                      handleChange("anesthesiologistName", e.target.value);
                      handleChange("anesthesiologistId", selectedOption.getAttribute("data-id") || "doctor-001");
                    }}
                  >
                    <option value="">Pilih Dokter Anestesi</option>
                    <option value="Dr. Ahmad Suryadi, Sp.An" data-id="doctor-001">Dr. Ahmad Suryadi, Sp.An</option>
                    <option value="Dr. Siti Rahmawati, Sp.An" data-id="doctor-002">Dr. Siti Rahmawati, Sp.An</option>
                    <option value="Dr. Maya Kusuma, Sp.An" data-id="doctor-003">Dr. Maya Kusuma, Sp.An</option>
                    <option value="Dr. Budi Santoso, Sp.An" data-id="doctor-004">Dr. Budi Santoso, Sp.An</option>
                  </select>
                  <p className="text-xs text-gray-500">
                    Pilih dokter anestesi yang akan menangani Anda
                  </p>
                </div>

                <div className="bg-green-50 border border-green-200 rounded-lg p-4 mt-6">
                  <p className="text-sm text-green-800">
                    ✅ <strong>Langkah Selanjutnya:</strong> Setelah mendaftar, dokter akan
                    melengkapi data diagnosis medis, jenis operasi, tanggal operasi, dan memilih
                    jenis anestesi yang sesuai untuk Anda.
                  </p>
                </div>
              </div>
            )}

            {/* Navigation Buttons */}
            <div className="flex justify-between mt-8 pt-6 border-t">
              <Button
                variant="outline"
                onClick={handleBack}
                disabled={currentStep === 1}
                className="border-gray-300"
              >
                <ArrowLeft className="w-4 h-4 mr-2" />
                Kembali
              </Button>

              {currentStep < 4 ? (
                <Button onClick={handleNext} className="bg-blue-600 hover:bg-blue-700">
                  Lanjut
                  <ArrowRight className="w-4 h-4 ml-2" />
                </Button>
              ) : (
                <Button
                  onClick={handleSubmit}
                  className="bg-green-600 hover:bg-green-700"
                >
                  <CheckCircle className="w-4 h-4 mr-2" />
                  Selesai & Masuk Dashboard
                </Button>
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}