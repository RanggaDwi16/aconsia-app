import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Badge } from "../../components/ui/badge";
import { useNavigate } from "react-router";
import {
  User,
  Calendar,
  MapPin,
  Phone,
  FileText,
  Stethoscope,
  AlertCircle,
  CheckCircle,
  Heart,
  Pill,
  Clock,
} from "lucide-react";

interface PatientFormData {
  // Identitas Pasien
  fullName: string;
  dateOfBirth: string;
  gender: "Laki-laki" | "Perempuan" | "";
  idNumber: string; // KTP
  address: string;
  phoneNumber: string;
  emergencyContact: string;
  emergencyPhone: string;
  
  // Data Medis
  mrn: string; // Medical Record Number
  weight: string;
  height: string;
  bloodType: string;
  surgeryType: string;
  surgeryDate: string;
  diagnosis: string;
  
  // Riwayat Kesehatan
  medicalHistory: string; // Penyakit yang pernah/sedang diderita
  allergies: string; // Alergi obat/makanan
  currentMedications: string; // Obat yang sedang dikonsumsi
  previousAnesthesia: string; // Riwayat anestesi sebelumnya
  smokingAlcohol: string; // Kebiasaan merokok/alkohol
  
  // Data Dokter
  surgeonName: string;
  anesthesiologistName: string;
  hospitalName: string;
}

export function PatientRegistration() {
  const navigate = useNavigate();
  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState<PatientFormData>({
    fullName: "",
    dateOfBirth: "",
    gender: "",
    idNumber: "",
    address: "",
    phoneNumber: "",
    emergencyContact: "",
    emergencyPhone: "",
    mrn: "",
    weight: "",
    height: "",
    bloodType: "",
    surgeryType: "",
    surgeryDate: "",
    diagnosis: "",
    medicalHistory: "",
    allergies: "",
    currentMedications: "",
    previousAnesthesia: "",
    smokingAlcohol: "",
    surgeonName: "",
    anesthesiologistName: "",
    hospitalName: "",
  });

  const handleChange = (field: keyof PatientFormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const validateStep = (step: number): boolean => {
    if (step === 1) {
      return !!(
        formData.fullName &&
        formData.dateOfBirth &&
        formData.gender &&
        formData.idNumber &&
        formData.address &&
        formData.phoneNumber &&
        formData.emergencyContact &&
        formData.emergencyPhone
      );
    }
    if (step === 2) {
      return !!(
        formData.mrn &&
        formData.weight &&
        formData.height &&
        formData.surgeryType &&
        formData.surgeryDate &&
        formData.diagnosis
      );
    }
    if (step === 3) {
      return !!(
        formData.medicalHistory ||
        formData.allergies ||
        formData.currentMedications ||
        formData.previousAnesthesia ||
        formData.smokingAlcohol
      );
    }
    if (step === 4) {
      return !!(
        formData.surgeonName &&
        formData.anesthesiologistName &&
        formData.hospitalName
      );
    }
    return false;
  };

  const handleNext = () => {
    if (!validateStep(currentStep)) {
      alert("Mohon lengkapi semua data yang wajib diisi!");
      return;
    }
    setCurrentStep(prev => prev + 1);
  };

  const handleBack = () => {
    setCurrentStep(prev => prev - 1);
  };

  const handleSubmit = () => {
    if (!validateStep(4)) {
      alert("Mohon lengkapi semua data dokter!");
      return;
    }

    // Calculate age
    const age = new Date().getFullYear() - new Date(formData.dateOfBirth).getFullYear();

    // Create patient object
    const patientData = {
      id: `patient-${Date.now()}`,
      nik: formData.idNumber, // IMPORTANT: Map idNumber to nik for consistency
      ...formData,
      age,
      status: "pending",
      comprehensionScore: 0,
      anesthesiaType: null, // Will be set by doctor
      doctorName: formData.anesthesiologistName,
      createdAt: new Date().toISOString(),
      password: "demo123", // 🔑 DEFAULT PASSWORD for demo purposes
    };

    // 💾 SAVE TO MULTIPLE LOCATIONS FOR REAL-TIME SYNC
    
    // 1. Save to currentPatient (for patient login)
    localStorage.setItem("currentPatient", JSON.stringify(patientData));
    
    // 2. Save to patient_{NIK} (for patient login by NIK)
    localStorage.setItem(`patient_${formData.idNumber}`, JSON.stringify(patientData));
    
    // 3. ✅ ADD to demoPatients array (for doctor dashboard)
    const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
    demoPatients.push(patientData);
    localStorage.setItem("demoPatients", JSON.stringify(demoPatients));

    console.log("✅ Pasien baru berhasil didaftarkan:", patientData);
    console.log("✅ Total pasien di demoPatients:", demoPatients.length);

    alert(
      `✅ PENDAFTARAN BERHASIL!\n\n` +
      `📌 Informasi Login Anda:\n` +
      `NIK: ${formData.idNumber}\n` +
      `Password: demo123\n\n` +
      `Status: Menunggu approval dokter\n` +
      `Dokter Anestesi: ${formData.anesthesiologistName}\n\n` +
      `Anda akan diarahkan ke dashboard.`
    );

    // Navigate to dashboard
    navigate("/patient");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-cyan-50">
      <div className="container mx-auto px-4 py-8 max-w-4xl">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Pendaftaran Pasien
          </h1>
          <p className="text-gray-600">
            Sistem Edukasi Informed Consent Anestesi
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
            {/* STEP 1: IDENTITAS PASIEN */}
            {currentStep === 1 && (
              <div className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="fullName">Nama Lengkap <span className="text-red-600">*</span></Label>
                    <Input
                      id="fullName"
                      placeholder="Nama sesuai KTP"
                      value={formData.fullName}
                      onChange={(e) => handleChange("fullName", e.target.value)}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="dateOfBirth">Tanggal Lahir <span className="text-red-600">*</span></Label>
                    <Input
                      id="dateOfBirth"
                      type="date"
                      value={formData.dateOfBirth}
                      onChange={(e) => handleChange("dateOfBirth", e.target.value)}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label>Jenis Kelamin <span className="text-red-600">*</span></Label>
                    <div className="flex gap-4">
                      <label className="flex items-center gap-2">
                        <input
                          type="radio"
                          name="gender"
                          value="Laki-laki"
                          checked={formData.gender === "Laki-laki"}
                          onChange={(e) => handleChange("gender", e.target.value)}
                          className="w-4 h-4"
                        />
                        <span>Laki-laki</span>
                      </label>
                      <label className="flex items-center gap-2">
                        <input
                          type="radio"
                          name="gender"
                          value="Perempuan"
                          checked={formData.gender === "Perempuan"}
                          onChange={(e) => handleChange("gender", e.target.value)}
                          className="w-4 h-4"
                        />
                        <span>Perempuan</span>
                      </label>
                    </div>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="idNumber">No. KTP <span className="text-red-600">*</span></Label>
                    <Input
                      id="idNumber"
                      placeholder="16 digit"
                      value={formData.idNumber}
                      onChange={(e) => handleChange("idNumber", e.target.value)}
                      maxLength={16}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="address">Alamat Lengkap <span className="text-red-600">*</span></Label>
                  <textarea
                    id="address"
                    className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                    rows={3}
                    placeholder="Jalan, RT/RW, Kelurahan, Kecamatan, Kota, Provinsi"
                    value={formData.address}
                    onChange={(e) => handleChange("address", e.target.value)}
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="phoneNumber">No. Telepon/HP <span className="text-red-600">*</span></Label>
                    <Input
                      id="phoneNumber"
                      type="tel"
                      placeholder="08xx xxxx xxxx"
                      value={formData.phoneNumber}
                      onChange={(e) => handleChange("phoneNumber", e.target.value)}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="emergencyContact">Kontak Darurat (Nama) <span className="text-red-600">*</span></Label>
                    <Input
                      id="emergencyContact"
                      placeholder="Nama keluarga terdekat"
                      value={formData.emergencyContact}
                      onChange={(e) => handleChange("emergencyContact", e.target.value)}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="emergencyPhone">No. Telepon Kontak Darurat <span className="text-red-600">*</span></Label>
                  <Input
                    id="emergencyPhone"
                    type="tel"
                    placeholder="08xx xxxx xxxx"
                    value={formData.emergencyPhone}
                    onChange={(e) => handleChange("emergencyPhone", e.target.value)}
                  />
                </div>
              </div>
            )}

            {/* STEP 2: DATA MEDIS */}
            {currentStep === 2 && (
              <div className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="mrn">No. Rekam Medis <span className="text-red-600">*</span></Label>
                    <Input
                      id="mrn"
                      placeholder="MRN-XXXX"
                      value={formData.mrn}
                      onChange={(e) => handleChange("mrn", e.target.value)}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="weight">Berat Badan (kg) <span className="text-red-600">*</span></Label>
                    <Input
                      id="weight"
                      type="number"
                      placeholder="60"
                      value={formData.weight}
                      onChange={(e) => handleChange("weight", e.target.value)}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="height">Tinggi Badan (cm) <span className="text-red-600">*</span></Label>
                    <Input
                      id="height"
                      type="number"
                      placeholder="165"
                      value={formData.height}
                      onChange={(e) => handleChange("height", e.target.value)}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="bloodType">Golongan Darah</Label>
                  <select
                    id="bloodType"
                    className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                    value={formData.bloodType}
                    onChange={(e) => handleChange("bloodType", e.target.value)}
                  >
                    <option value="">Pilih golongan darah</option>
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="AB">AB</option>
                    <option value="O">O</option>
                    <option value="Tidak Tahu">Tidak Tahu</option>
                  </select>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="diagnosis">Diagnosis Medis <span className="text-red-600">*</span></Label>
                  <Input
                    id="diagnosis"
                    placeholder="Contoh: Appendicitis Acute"
                    value={formData.diagnosis}
                    onChange={(e) => handleChange("diagnosis", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="surgeryType">Jenis Operasi/Tindakan <span className="text-red-600">*</span></Label>
                  <Input
                    id="surgeryType"
                    placeholder="Contoh: Laparoscopic Appendectomy"
                    value={formData.surgeryType}
                    onChange={(e) => handleChange("surgeryType", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="surgeryDate">Tanggal Rencana Operasi <span className="text-red-600">*</span></Label>
                  <Input
                    id="surgeryDate"
                    type="date"
                    value={formData.surgeryDate}
                    onChange={(e) => handleChange("surgeryDate", e.target.value)}
                    min={new Date().toISOString().split("T")[0]}
                  />
                </div>
              </div>
            )}

            {/* STEP 3: RIWAYAT KESEHATAN */}
            {currentStep === 3 && (
              <div className="space-y-4">
                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 mb-4">
                  <p className="text-sm text-yellow-900">
                    💡 <strong>Penting:</strong> Informasi ini sangat penting untuk keamanan anestesi Anda. 
                    Mohon isi dengan jujur dan lengkap. Jika tidak ada, tulis "Tidak ada".
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="medicalHistory">Riwayat Penyakit</Label>
                  <textarea
                    id="medicalHistory"
                    className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                    rows={3}
                    placeholder="Contoh: Hipertensi, Diabetes, Asma, Penyakit Jantung, dll. (Tulis 'Tidak ada' jika tidak ada)"
                    value={formData.medicalHistory}
                    onChange={(e) => handleChange("medicalHistory", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="allergies">Alergi Obat/Makanan</Label>
                  <textarea
                    id="allergies"
                    className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                    rows={2}
                    placeholder="Contoh: Alergi Penisilin, Seafood, dll. (Tulis 'Tidak ada' jika tidak ada)"
                    value={formData.allergies}
                    onChange={(e) => handleChange("allergies", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="currentMedications">Obat yang Sedang Dikonsumsi</Label>
                  <textarea
                    id="currentMedications"
                    className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                    rows={2}
                    placeholder="Contoh: Obat darah tinggi, Insulin, Vitamin, Jamu, dll. (Tulis 'Tidak ada' jika tidak ada)"
                    value={formData.currentMedications}
                    onChange={(e) => handleChange("currentMedications", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="previousAnesthesia">Riwayat Anestesi Sebelumnya</Label>
                  <textarea
                    id="previousAnesthesia"
                    className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                    rows={2}
                    placeholder="Pernah operasi sebelumnya? Ada masalah/efek samping? (Tulis 'Tidak ada' jika belum pernah)"
                    value={formData.previousAnesthesia}
                    onChange={(e) => handleChange("previousAnesthesia", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="smokingAlcohol">Kebiasaan Merokok/Alkohol</Label>
                  <textarea
                    id="smokingAlcohol"
                    className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                    rows={2}
                    placeholder="Contoh: Merokok 1 bungkus/hari, Alkohol kadang-kadang, dll. (Tulis 'Tidak ada' jika tidak ada)"
                    value={formData.smokingAlcohol}
                    onChange={(e) => handleChange("smokingAlcohol", e.target.value)}
                  />
                </div>
              </div>
            )}

            {/* STEP 4: DATA DOKTER */}
            {currentStep === 4 && (
              <div className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="hospitalName">Nama Rumah Sakit <span className="text-red-600">*</span></Label>
                  <Input
                    id="hospitalName"
                    placeholder="Contoh: RS Siloam Hospitals Jakarta"
                    value={formData.hospitalName}
                    onChange={(e) => handleChange("hospitalName", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="surgeonName">Nama Dokter Bedah <span className="text-red-600">*</span></Label>
                  <Input
                    id="surgeonName"
                    placeholder="Contoh: dr. Ahmad Budiman, Sp.B"
                    value={formData.surgeonName}
                    onChange={(e) => handleChange("surgeonName", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="anesthesiologistName">Nama Dokter Anestesi <span className="text-red-600">*</span></Label>
                  <Input
                    id="anesthesiologistName"
                    placeholder="Contoh: dr. Siti Rahmawati, Sp.An"
                    value={formData.anesthesiologistName}
                    onChange={(e) => handleChange("anesthesiologistName", e.target.value)}
                  />
                </div>

                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mt-6">
                  <h4 className="font-semibold text-blue-900 mb-2">📋 Ringkasan Data</h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-2 text-sm text-blue-800">
                    <div>• Nama: {formData.fullName || "-"}</div>
                    <div>• No. KTP: {formData.idNumber || "-"}</div>
                    <div>• No. RM: {formData.mrn || "-"}</div>
                    <div>• Operasi: {formData.surgeryType || "-"}</div>
                  </div>
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Navigation Buttons */}
        <div className="flex justify-between mt-6">
          <Button
            variant="outline"
            onClick={handleBack}
            disabled={currentStep === 1}
          >
            Kembali
          </Button>
          {currentStep < 4 ? (
            <Button
              onClick={handleNext}
              className="bg-blue-600 hover:bg-blue-700"
            >
              Lanjut
            </Button>
          ) : (
            <Button
              onClick={handleSubmit}
              className="bg-green-600 hover:bg-green-700"
            >
              Selesai & Masuk Dashboard
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}