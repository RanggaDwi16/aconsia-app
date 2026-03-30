import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { ArrowLeft, ArrowRight, CheckCircle, AlertCircle } from "lucide-react";
import { useNavigate } from "react-router";

interface AssessmentData {
  // ASA Status
  asaStatus: string;
  
  // Riwayat Anestesi
  hasAnesthesiaHistory: string;
  anesthesiaDetails: string;
  anesthesiaComplications: string;
  
  // Alergi
  hasDrugAllergy: string;
  allergyDetails: string;
  allergyReaction: string;
  
  // Obat Rutin
  takingMedication: string;
  medicationList: Array<{
    name: string;
    dose: string;
    frequency: string;
  }>;
  
  // Kebiasaan
  smokingStatus: string;
  cigarettesPerDay: string;
  alcoholStatus: string;
  alcoholFrequency: string;
  drugUse: string;
  
  // Riwayat Penyakit
  hasDiabetes: boolean;
  hasHypertension: boolean;
  hasAsthma: boolean;
  hasHeartDisease: boolean;
  hasStroke: boolean;
  hasKidneyDisease: boolean;
  hasLiverDisease: boolean;
  hasEpilepsy: boolean;
  otherDiseases: string;
}

export function PreOperativeAssessment() {
  const navigate = useNavigate();
  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState<AssessmentData>({
    asaStatus: "",
    hasAnesthesiaHistory: "",
    anesthesiaDetails: "",
    anesthesiaComplications: "",
    hasDrugAllergy: "",
    allergyDetails: "",
    allergyReaction: "",
    takingMedication: "",
    medicationList: [],
    smokingStatus: "",
    cigarettesPerDay: "",
    alcoholStatus: "",
    alcoholFrequency: "",
    drugUse: "Tidak",
    hasDiabetes: false,
    hasHypertension: false,
    hasAsthma: false,
    hasHeartDisease: false,
    hasStroke: false,
    hasKidneyDisease: false,
    hasLiverDisease: false,
    hasEpilepsy: false,
    otherDiseases: "",
  });

  const handleSubmit = () => {
    // Save assessment data
    console.log("Assessment Data:", formData);
    
    // ✅ SYNC TO MULTIPLE LOCATIONS (like PatientApprovalNew.tsx)
    const savedPatient = localStorage.getItem("currentPatient");
    if (savedPatient) {
      const patientData = JSON.parse(savedPatient);
      
      // Update patient with assessment completion
      const updatedPatient = {
        ...patientData,
        assessmentCompleted: true,
        assessmentData: formData,
      };
      
      // 1. Update currentPatient
      localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
      
      // 2. Update patient_{NIK} (for patient login)
      if (updatedPatient.nik) {
        localStorage.setItem(`patient_${updatedPatient.nik}`, JSON.stringify(updatedPatient));
      }
      
      // 3. Update demoPatients array (MOST IMPORTANT for doctor dashboard!)
      const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
      const updatedDemoPatients = demoPatients.map((p: any) =>
        p.id === updatedPatient.id ? updatedPatient : p
      );
      localStorage.setItem("demoPatients", JSON.stringify(updatedDemoPatients));
      
      console.log("✅ Assessment completed and synced to all locations:", updatedPatient.id);
    }
    
    // Show success message
    alert("✅ Asesmen berhasil disimpan!");
    
    // Navigate back to patient home
    navigate("/patient");
  };

  const totalSteps = 4;

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50">
      <div className="container mx-auto px-4 py-8 max-w-3xl">
        {/* Header */}
        <div className="flex items-center gap-4 mb-6">
          <Button variant="ghost" size="sm" onClick={() => navigate("/patient")}>
            <ArrowLeft className="w-4 h-4 mr-2" />
            Kembali
          </Button>
          <div className="flex-1">
            <h1 className="text-2xl font-bold text-gray-900">Asesmen Pra-Operasi</h1>
            <p className="text-sm text-gray-600">Isi data lengkap untuk evaluasi risiko anestesi</p>
          </div>
        </div>

        {/* Progress Indicator */}
        <Card className="mb-6 border-blue-200">
          <CardContent className="p-4">
            <div className="flex items-center justify-between mb-3">
              {[1, 2, 3, 4].map((step) => (
                <div key={step} className="flex items-center flex-1">
                  <div className={`flex items-center justify-center w-10 h-10 rounded-full font-bold ${
                    step <= currentStep ? "bg-blue-600 text-white" : "bg-gray-300 text-gray-600"
                  }`}>
                    {step}
                  </div>
                  {step < 4 && (
                    <div className={`flex-1 h-1 mx-2 ${
                      step < currentStep ? "bg-blue-600" : "bg-gray-300"
                    }`} />
                  )}
                </div>
              ))}
            </div>
            <p className="text-xs text-gray-600 text-center">
              Langkah {currentStep} dari {totalSteps}
            </p>
          </CardContent>
        </Card>

        {/* Form Content */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-blue-600" />
              {currentStep === 1 && "Riwayat Anestesi & Alergi"}
              {currentStep === 2 && "Obat-obatan & Kebiasaan"}
              {currentStep === 3 && "Riwayat Penyakit"}
              {currentStep === 4 && "Konfirmasi Data"}
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* STEP 1: Riwayat Anestesi & Alergi */}
            {currentStep === 1 && (
              <>
                {/* Riwayat Anestesi */}
                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">
                    Apakah Anda pernah menjalani anestesi sebelumnya? *
                  </label>
                  <div className="space-y-2">
                    {["Belum pernah", "Pernah, tidak ada masalah", "Pernah, ada masalah"].map((option) => (
                      <label key={option} className="flex items-center gap-2 p-3 border rounded-lg cursor-pointer hover:bg-blue-50">
                        <input
                          type="radio"
                          name="hasAnesthesiaHistory"
                          value={option}
                          checked={formData.hasAnesthesiaHistory === option}
                          onChange={(e) => setFormData({ ...formData, hasAnesthesiaHistory: e.target.value })}
                          className="w-4 h-4"
                        />
                        <span className="text-sm">{option}</span>
                      </label>
                    ))}
                  </div>
                </div>

                {formData.hasAnesthesiaHistory === "Pernah, ada masalah" && (
                  <div>
                    <label className="block text-sm font-semibold text-gray-900 mb-2">
                      Jelaskan masalah yang terjadi:
                    </label>
                    <textarea
                      className="w-full p-3 border rounded-lg text-sm"
                      rows={3}
                      placeholder="Contoh: Mual hebat setelah operasi, sakit kepala, dll"
                      value={formData.anesthesiaComplications}
                      onChange={(e) => setFormData({ ...formData, anesthesiaComplications: e.target.value })}
                    />
                  </div>
                )}

                {/* Alergi Obat */}
                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">
                    Apakah Anda memiliki alergi terhadap obat-obatan? *
                  </label>
                  <div className="space-y-2">
                    {["Tidak ada", "Ada"].map((option) => (
                      <label key={option} className="flex items-center gap-2 p-3 border rounded-lg cursor-pointer hover:bg-blue-50">
                        <input
                          type="radio"
                          name="hasDrugAllergy"
                          value={option}
                          checked={formData.hasDrugAllergy === option}
                          onChange={(e) => setFormData({ ...formData, hasDrugAllergy: e.target.value })}
                          className="w-4 h-4"
                        />
                        <span className="text-sm">{option}</span>
                      </label>
                    ))}
                  </div>
                </div>

                {formData.hasDrugAllergy === "Ada" && (
                  <>
                    <div>
                      <label className="block text-sm font-semibold text-gray-900 mb-2">
                        Sebutkan nama obat yang menyebabkan alergi:
                      </label>
                      <input
                        type="text"
                        className="w-full p-3 border rounded-lg text-sm"
                        placeholder="Contoh: Penisilin, Aspirin, dll"
                        value={formData.allergyDetails}
                        onChange={(e) => setFormData({ ...formData, allergyDetails: e.target.value })}
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-semibold text-gray-900 mb-2">
                        Reaksi alergi yang terjadi:
                      </label>
                      <input
                        type="text"
                        className="w-full p-3 border rounded-lg text-sm"
                        placeholder="Contoh: Gatal, ruam, sesak napas, dll"
                        value={formData.allergyReaction}
                        onChange={(e) => setFormData({ ...formData, allergyReaction: e.target.value })}
                      />
                    </div>
                  </>
                )}
              </>
            )}

            {/* STEP 2: Obat-obatan & Kebiasaan */}
            {currentStep === 2 && (
              <>
                {/* Obat Rutin */}
                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">
                    Apakah Anda rutin mengonsumsi obat-obatan? *
                  </label>
                  <div className="space-y-2">
                    {["Tidak", "Ya"].map((option) => (
                      <label key={option} className="flex items-center gap-2 p-3 border rounded-lg cursor-pointer hover:bg-blue-50">
                        <input
                          type="radio"
                          name="takingMedication"
                          value={option}
                          checked={formData.takingMedication === option}
                          onChange={(e) => setFormData({ ...formData, takingMedication: e.target.value })}
                          className="w-4 h-4"
                        />
                        <span className="text-sm">{option}</span>
                      </label>
                    ))}
                  </div>
                </div>

                {formData.takingMedication === "Ya" && (
                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <p className="text-sm text-blue-900 mb-3 font-semibold">
                      Sebutkan obat yang Anda konsumsi:
                    </p>
                    <textarea
                      className="w-full p-3 border rounded-lg text-sm"
                      rows={4}
                      placeholder="Format: Nama Obat - Dosis - Frekuensi&#10;Contoh:&#10;• Metformin - 500mg - 2x sehari&#10;• Amlodipine - 5mg - 1x sehari"
                      value={formData.medicationList.map(m => `${m.name} - ${m.dose} - ${m.frequency}`).join('\n')}
                      onChange={(e) => {
                        const lines = e.target.value.split('\n').filter(l => l.trim());
                        const meds = lines.map(line => {
                          const parts = line.replace('•', '').trim().split('-').map(p => p.trim());
                          return {
                            name: parts[0] || '',
                            dose: parts[1] || '',
                            frequency: parts[2] || ''
                          };
                        });
                        setFormData({ ...formData, medicationList: meds });
                      }}
                    />
                  </div>
                )}

                {/* Kebiasaan Merokok */}
                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">
                    Status Merokok *
                  </label>
                  <div className="space-y-2">
                    {["Tidak merokok", "Pernah merokok (sudah berhenti)", "Merokok aktif"].map((option) => (
                      <label key={option} className="flex items-center gap-2 p-3 border rounded-lg cursor-pointer hover:bg-blue-50">
                        <input
                          type="radio"
                          name="smokingStatus"
                          value={option}
                          checked={formData.smokingStatus === option}
                          onChange={(e) => setFormData({ ...formData, smokingStatus: e.target.value })}
                          className="w-4 h-4"
                        />
                        <span className="text-sm">{option}</span>
                      </label>
                    ))}
                  </div>
                </div>

                {formData.smokingStatus === "Merokok aktif" && (
                  <div>
                    <label className="block text-sm font-semibold text-gray-900 mb-2">
                      Berapa batang rokok per hari?
                    </label>
                    <input
                      type="number"
                      className="w-full p-3 border rounded-lg text-sm"
                      placeholder="Contoh: 10"
                      value={formData.cigarettesPerDay}
                      onChange={(e) => setFormData({ ...formData, cigarettesPerDay: e.target.value })}
                    />
                  </div>
                )}

                {/* Kebiasaan Alkohol */}
                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">
                    Konsumsi Alkohol *
                  </label>
                  <div className="space-y-2">
                    {["Tidak pernah", "Jarang (1-2x/bulan)", "Sering (>1x/minggu)", "Setiap hari"].map((option) => (
                      <label key={option} className="flex items-center gap-2 p-3 border rounded-lg cursor-pointer hover:bg-blue-50">
                        <input
                          type="radio"
                          name="alcoholStatus"
                          value={option}
                          checked={formData.alcoholStatus === option}
                          onChange={(e) => setFormData({ ...formData, alcoholStatus: e.target.value })}
                          className="w-4 h-4"
                        />
                        <span className="text-sm">{option}</span>
                      </label>
                    ))}
                  </div>
                </div>
              </>
            )}

            {/* STEP 3: Riwayat Penyakit */}
            {currentStep === 3 && (
              <>
                <div className="bg-orange-50 border border-orange-200 rounded-lg p-4 mb-4">
                  <p className="text-sm text-orange-900">
                    <strong>Penting:</strong> Centang semua penyakit yang Anda pernah/sedang alami. Informasi ini sangat penting untuk keselamatan anestesi Anda.
                  </p>
                </div>

                <div className="space-y-3">
                  {[
                    { key: "hasDiabetes", label: "Diabetes (Kencing Manis)" },
                    { key: "hasHypertension", label: "Hipertensi (Tekanan Darah Tinggi)" },
                    { key: "hasAsthma", label: "Asma" },
                    { key: "hasHeartDisease", label: "Penyakit Jantung" },
                    { key: "hasStroke", label: "Riwayat Stroke" },
                    { key: "hasKidneyDisease", label: "Penyakit Ginjal" },
                    { key: "hasLiverDisease", label: "Penyakit Hati/Liver" },
                    { key: "hasEpilepsy", label: "Epilepsi/Kejang" },
                  ].map((disease) => (
                    <label key={disease.key} className="flex items-center gap-3 p-4 border rounded-lg cursor-pointer hover:bg-blue-50">
                      <input
                        type="checkbox"
                        checked={formData[disease.key as keyof AssessmentData] as boolean}
                        onChange={(e) => setFormData({ ...formData, [disease.key]: e.target.checked })}
                        className="w-5 h-5"
                      />
                      <span className="text-sm font-medium">{disease.label}</span>
                    </label>
                  ))}
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-900 mb-2">
                    Penyakit lain yang belum disebutkan:
                  </label>
                  <textarea
                    className="w-full p-3 border rounded-lg text-sm"
                    rows={3}
                    placeholder="Sebutkan penyakit lain yang Anda alami (jika ada)"
                    value={formData.otherDiseases}
                    onChange={(e) => setFormData({ ...formData, otherDiseases: e.target.value })}
                  />
                </div>
              </>
            )}

            {/* STEP 4: Konfirmasi */}
            {currentStep === 4 && (
              <div className="space-y-4">
                <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                  <CheckCircle className="w-6 h-6 text-green-600 mb-2" />
                  <h3 className="font-bold text-green-900 mb-2">Data Asesmen Anda</h3>
                  <p className="text-sm text-green-800">
                    Silakan periksa kembali data yang telah Anda isi. Data ini akan dikirim ke dokter anestesi untuk evaluasi risiko.
                  </p>
                </div>

                <Card className="bg-gray-50">
                  <CardContent className="p-4 space-y-3 text-sm">
                    <div>
                      <strong>Riwayat Anestesi:</strong> {formData.hasAnesthesiaHistory || "-"}
                    </div>
                    <div>
                      <strong>Alergi Obat:</strong> {formData.hasDrugAllergy === "Ada" ? `Ya (${formData.allergyDetails})` : "Tidak ada"}
                    </div>
                    <div>
                      <strong>Obat Rutin:</strong> {formData.takingMedication === "Ya" ? "Ya" : "Tidak"}
                    </div>
                    <div>
                      <strong>Merokok:</strong> {formData.smokingStatus || "-"}
                    </div>
                    <div>
                      <strong>Alkohol:</strong> {formData.alcoholStatus || "-"}
                    </div>
                    <div>
                      <strong>Riwayat Penyakit:</strong>{" "}
                      {[
                        formData.hasDiabetes && "Diabetes",
                        formData.hasHypertension && "Hipertensi",
                        formData.hasAsthma && "Asma",
                        formData.hasHeartDisease && "Penyakit Jantung",
                        formData.hasStroke && "Stroke",
                        formData.hasKidneyDisease && "Penyakit Ginjal",
                        formData.hasLiverDisease && "Penyakit Hati",
                        formData.hasEpilepsy && "Epilepsi",
                      ].filter(Boolean).join(", ") || "Tidak ada"}
                    </div>
                  </CardContent>
                </Card>
              </div>
            )}

            {/* Navigation Buttons */}
            <div className="flex gap-3 pt-6">
              {currentStep > 1 && (
                <Button
                  variant="outline"
                  onClick={() => setCurrentStep(currentStep - 1)}
                  className="flex-1"
                >
                  <ArrowLeft className="w-4 h-4 mr-2" />
                  Sebelumnya
                </Button>
              )}
              {currentStep < totalSteps && (
                <Button
                  onClick={() => setCurrentStep(currentStep + 1)}
                  className="flex-1 bg-blue-600 hover:bg-blue-700"
                >
                  Selanjutnya
                  <ArrowRight className="w-4 h-4 ml-2" />
                </Button>
              )}
              {currentStep === totalSteps && (
                <Button
                  onClick={handleSubmit}
                  className="flex-1 bg-green-600 hover:bg-green-700"
                >
                  <CheckCircle className="w-4 h-4 mr-2" />
                  Submit Asesmen
                </Button>
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}