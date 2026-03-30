import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { useNavigate } from "react-router";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogFooter,
} from "../../components/ui/dialog";
import {
  AlertCircle,
  Calendar,
  BookOpen,
  MessageSquare,
  TrendingUp,
  CheckCircle,
  Clock,
  User,
  FileText,
  Activity,
  PlayCircle,
  Lock,
  Sparkles,
  Phone,
  Send,
  Clipboard,
  ClipboardCheck,
  Menu,
  X,
  LogOut,
  Home,
  MessageCircle,
  BookText,
} from "lucide-react";
import { getMaterialsByType, hasContentForType } from "../../../data/learningMaterials";
import { SidebarDrawer } from "../../components/SidebarDrawer";

interface PatientData {
  id: string;
  fullName: string;
  mrn: string;
  surgeryType: string;
  surgeryDate: string;
  anesthesiaType: string | null;
  status: "pending" | "approved" | "in_progress" | "ready";
  comprehensionScore: number;
  doctorName: string;
  scheduledConsentDate?: string;
  assessmentCompleted?: boolean; // NEW: Track assessment completion
  materialsReadCount?: number; // NEW: Track how many materials read
  aiRecommendations?: any[]; // NEW: Store AI recommendations
  lastChatDate?: string; // NEW: Track last chat date
}

interface Material {
  id: string;
  title: string;
  description: string;
  type: string;
  section: number;
  readingProgress: number;
  status: "not_started" | "in_progress" | "completed";
  estimatedTime: string;
}

interface AIRecommendation {
  id: string;
  title: string;
  reason: string;
  priority: "high" | "medium" | "low";
  action: string;
  link: string;
}

export function EnhancedPatientHome() {
  const navigate = useNavigate();
  const [patientData, setPatientData] = useState<PatientData | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [showScheduleDialog, setShowScheduleDialog] = useState(false);
  const [showDoctorChat, setShowDoctorChat] = useState(false);
  const [selectedDate, setSelectedDate] = useState("");
  const [selectedTime, setSelectedTime] = useState("");
  const [doctorMessage, setDoctorMessage] = useState("");
  
  // 🆕 SIDEBAR DRAWER STATE
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [touchStart, setTouchStart] = useState(0);
  const [touchEnd, setTouchEnd] = useState(0);

  // Load patient data from localStorage and auto-sync
  useEffect(() => {
    const loadPatientData = () => {
      const savedPatient = localStorage.getItem("currentPatient");
      if (savedPatient) {
        const patient = JSON.parse(savedPatient);
        
        // 🔄 REAL-TIME SYNC: Check if data updated in demoPatients
        const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
        const updatedPatient = demoPatients.find((p: any) => p.id === patient.id);
        
        if (updatedPatient) {
          // Use updated data from demoPatients (synced by doctor)
          setPatientData(updatedPatient);
          // Update currentPatient with latest data
          localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
        } else {
          // Fallback to saved patient
          setPatientData(patient);
        }
      } else {
        // No logged in patient - redirect to login
        navigate("/login");
        return;
      }
      setIsLoading(false);
    };

    loadPatientData();

    // Auto-sync every 2 seconds for real-time updates
    const interval = setInterval(loadPatientData, 2000);
    return () => clearInterval(interval);
  }, [navigate]);

  // AI Recommendations based on comprehension score
  // 🎯 ONLY SHOW sections where patient struggled (from AI chat assessment)
  const aiRecommendations: AIRecommendation[] = 
    patientData && patientData.aiRecommendations && patientData.aiRecommendations.length > 0
      ? // ✅ USE SAVED AI RECOMMENDATIONS FROM CHATBOT (only weak sections)
        patientData.aiRecommendations.map((rec: any, index: number) => ({
          id: `ai-rec-${index}`,
          title: `Pelajari Kembali: ${rec.title}`,
          reason: rec.reason || `Saya melihat Anda perlu memperkuat pemahaman tentang "${rec.title}"`,
          priority: "high" as const,
          action: "Baca Materi",
          link: `/patient/material/${rec.sectionNum}`,
        }))
      : // ❌ NO FALLBACK - Don't show generic recommendations
        [];

  // Auto-filter materials based on patient's anesthesia type
  const filteredMaterials = patientData?.anesthesiaType
    ? getMaterialsByType(patientData.anesthesiaType)
    : [];

  const handleScheduleConsent = () => {
    if (!selectedDate || !selectedTime) {
      alert("Mohon pilih tanggal dan waktu!");
      return;
    }

    const updatedPatient = {
      ...patientData!,
      scheduledConsentDate: `${selectedDate} ${selectedTime}`,
    };
    setPatientData(updatedPatient);
    localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
    setShowScheduleDialog(false);
    alert("Jadwal tanda tangan berhasil dibuat!");
  };

  const handleSendMessageToDoctor = () => {
    if (!doctorMessage.trim()) {
      alert("Mohon tulis pesan terlebih dahulu!");
      return;
    }

    // In real app, this would send message to doctor
    alert(`Pesan terkirim ke ${patientData?.doctorName}:\n\n"${doctorMessage}"`);
    setDoctorMessage("");
    setShowDoctorChat(false);
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!patientData) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen gap-4">
        <AlertCircle className="w-16 h-16 text-red-600" />
        <p className="text-gray-600">Data pasien tidak ditemukan</p>
        <Button onClick={() => navigate("/patient/register")}>Daftar Sekarang</Button>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-cyan-50">
      {/* 🆕 SIDEBAR DRAWER */}
      <SidebarDrawer
        isOpen={isSidebarOpen}
        onClose={() => setIsSidebarOpen(false)}
        patientData={patientData}
      />

      <div className="container mx-auto px-4 py-4 max-w-6xl">
        {/* Header - WITH HAMBURGER MENU */}
        <div className="mb-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              {/* 🍔 HAMBURGER BUTTON */}
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setIsSidebarOpen(true)}
                className="p-2"
              >
                <Menu className="w-6 h-6 text-gray-700" />
              </Button>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">Dashboard Pasien</h1>
                <p className="text-sm text-gray-600">Pantau progress pembelajaran Anda</p>
              </div>
            </div>
            <Button
              variant="outline"
              size="sm"
              className="gap-2 hidden sm:flex"
              onClick={() => navigate("/patient/contact-doctor")}
            >
              <MessageSquare className="w-4 h-4" />
              Hubungi Dokter
            </Button>
          </div>
        </div>

        {/* Patient Info Card - More Compact */}
        <Card className="mb-4 border-blue-200 bg-gradient-to-r from-blue-50 to-cyan-50">
          <CardContent className="p-4">
            <h3 className="text-sm font-bold text-gray-900 mb-3 flex items-center gap-2">
              <User className="w-4 h-4 text-blue-600" />
              Identitas Pasien
            </h3>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-x-4 gap-y-2 text-sm">
              <div>
                <p className="text-xs text-gray-600">Nama Lengkap</p>
                <p className="font-semibold text-gray-900">{patientData.fullName}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">No. Rekam Medis</p>
                <p className="font-semibold text-gray-900">{patientData.mrn}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">Tanggal Lahir / Umur</p>
                <p className="font-semibold text-gray-900">
                  {(patientData as any).dateOfBirth || "-"} / {(patientData as any).age || "-"} tahun
                </p>
              </div>
              <div>
                <p className="text-xs text-gray-600">Jenis Kelamin</p>
                <p className="font-semibold text-gray-900">{(patientData as any).gender || "-"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">No. Telepon</p>
                <p className="font-semibold text-gray-900">{(patientData as any).phoneNumber || "-"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">Golongan Darah</p>
                <p className="font-semibold text-gray-900">{(patientData as any).bloodType || "-"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">Diagnosis</p>
                <p className="font-semibold text-gray-900">{(patientData as any).diagnosis || "-"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">Jenis Operasi</p>
                <p className="font-semibold text-gray-900">{patientData.surgeryType}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">Jenis Anestesi</p>
                <Badge className="bg-blue-600 text-xs">{patientData.anesthesiaType || "Belum Ditentukan"}</Badge>
              </div>
              <div>
                <p className="text-xs text-gray-600">Dokter Anestesi</p>
                <p className="font-semibold text-gray-900">{patientData.doctorName}</p>
              </div>
              <div>
                <p className="text-xs text-gray-600">Rumah Sakit</p>
                <p className="font-semibold text-gray-900">{(patientData as any).hospitalName || "-"}</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Pre-Operative Assessment Card - Elegant & Professional */}
        <Card className="mb-4 border-slate-200 bg-white hover:shadow-md transition-shadow duration-300">
          <CardContent className="p-6">
            <div className="flex items-center justify-between gap-6">
              {/* Left Section: Icon + Content */}
              <div className="flex items-center gap-4 flex-1">
                {/* Icon */}
                <div className={`flex-shrink-0 w-12 h-12 rounded-xl flex items-center justify-center ${
                  (patientData as any).assessmentCompleted 
                    ? 'bg-emerald-100' 
                    : 'bg-amber-100'
                }`}>
                  <ClipboardCheck className={`w-6 h-6 ${
                    (patientData as any).assessmentCompleted 
                      ? 'text-emerald-600' 
                      : 'text-amber-600'
                  }`} />
                </div>

                {/* Content */}
                <div className="flex-1 min-w-0">
                  <h3 className="text-base font-semibold text-gray-900 mb-1">
                    Asesmen Pra-Operasi
                  </h3>
                  <p className="text-sm text-gray-600">
                    Riwayat medis, alergi, dan kondisi kesehatan
                  </p>
                </div>
              </div>

              {/* Right Section: Status/Action */}
              <div className="flex-shrink-0">
                {(patientData as any).assessmentCompleted ? (
                  <div className="flex items-center gap-2 px-4 py-2 rounded-lg bg-emerald-50 border border-emerald-200">
                    <CheckCircle className="w-4 h-4 text-emerald-600" />
                    <span className="text-sm font-semibold text-emerald-700">Selesai</span>
                  </div>
                ) : (
                  <Button
                    size="sm"
                    className="bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-white font-medium px-5 py-2 shadow-sm"
                    onClick={() => navigate("/patient/pre-operative-assessment")}
                  >
                    Isi Sekarang
                  </Button>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* AI Recommendations - ONLY show weak sections from AI assessment */}
        {aiRecommendations.length > 0 ? (
          <Card className="mb-4 border-purple-200 bg-gradient-to-r from-purple-50 to-pink-50">
            <CardContent className="p-4">
              <h3 className="text-sm font-bold text-gray-900 mb-3 flex items-center gap-2">
                <Sparkles className="w-4 h-4 text-purple-600" />
                Rekomendasi AI - Materi yang Perlu Diperkuat
              </h3>
              <div className="space-y-2">
                {aiRecommendations.map((rec) => (
                  <div
                    key={rec.id}
                    className={`flex items-center justify-between gap-3 p-3 rounded-lg border ${"border-red-200 bg-red-50"}`}
                  >
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1">
                        <h4 className="text-sm font-semibold text-gray-900">{rec.title}</h4>
                        <Badge
                          variant="outline"
                          className="text-xs bg-red-100 text-red-700 border-red-300"
                        >
                          Perlu Diperkuat
                        </Badge>
                      </div>
                      <p className="text-xs text-gray-700">{rec.reason}</p>
                    </div>
                    <Button
                      size="sm"
                      className="bg-purple-600 hover:bg-purple-700 flex-shrink-0"
                      onClick={() => navigate(rec.link)}
                    >
                      {rec.action}
                    </Button>
                  </div>
                ))}
              </div>
              <div className="mt-3 p-2 bg-purple-100 border border-purple-200 rounded-lg">
                <p className="text-xs text-purple-900">
                  💡 <strong>Tips:</strong> Pelajari kembali section di atas untuk meningkatkan skor pemahaman Anda
                </p>
              </div>
            </CardContent>
          </Card>
        ) : patientData && patientData.lastChatDate ? (
          // User sudah chat tapi tidak ada weak sections (semua benar!)
          <Card className="mb-4 border-green-200 bg-gradient-to-r from-green-50 to-emerald-50">
            <CardContent className="p-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-green-600 rounded-full flex items-center justify-center flex-shrink-0">
                  <CheckCircle className="w-6 h-6 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-sm font-bold text-green-900 mb-1">
                    🎉 Luar Biasa! Tidak Ada Rekomendasi Khusus
                  </h3>
                  <p className="text-xs text-green-700">
                    Anda sudah menjawab semua pertanyaan AI dengan baik. Terus belajar untuk mempertahankan pemahaman!
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        ) : null}

        {/* Schedule Consent Card - More Compact */}
        <Card className="mb-4 border-green-200 bg-gradient-to-r from-green-50 to-emerald-50">
          <CardContent className="p-4">
            <div className="flex items-start justify-between gap-4">
              <div className="flex-1">
                <h3 className="text-sm font-bold text-gray-900 mb-2 flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-green-600" />
                  Jadwalkan Tanda Tangan
                </h3>
                <p className="text-xs text-gray-700">
                  Pemahaman ≥80%, siapkan pertanyaan, bawa identitas & dokumen medis
                </p>
              </div>
              <div className="flex-shrink-0">
                {patientData.scheduledConsentDate ? (
                  <div className="text-right">
                    <Badge className="bg-green-100 text-green-700 border-green-300 text-xs mb-1">
                      ✓ Terjadwal
                    </Badge>
                    <p className="text-xs text-gray-600">{patientData.scheduledConsentDate}</p>
                  </div>
                ) : (
                  <Button
                    size="sm"
                    className="bg-green-600 hover:bg-green-700"
                    onClick={() => setShowScheduleDialog(true)}
                    disabled={patientData.comprehensionScore < 80}
                  >
                    {patientData.comprehensionScore < 80 ? "Locked (<80%)" : "Pilih Jadwal"}
                  </Button>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Learning Materials - More Compact */}
        <Card className="mb-4">
          <CardContent className="p-4">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-sm font-bold text-gray-900 flex items-center gap-2">
                <BookOpen className="w-4 h-4 text-blue-600" />
                Materi Pembelajaran
              </h3>
              {patientData.anesthesiaType && (
                <Badge variant="outline" className="text-xs">
                  Auto-filter: {patientData.anesthesiaType}
                </Badge>
              )}
            </div>
            <div className="space-y-2">
              {/* Sort: Belum Selesai di atas, Selesai di bawah */}
              {[...filteredMaterials]
                .sort((a, b) => {
                  if (a.status === "completed" && b.status !== "completed") return 1;
                  if (a.status !== "completed" && b.status === "completed") return -1;
                  return 0;
                })
                .map((material) => (
                  <div
                    key={material.id}
                    className="flex items-center gap-3 p-3 border border-gray-200 rounded-lg hover:shadow-md transition-shadow bg-white"
                  >
                    {/* Icon */}
                    <div className="p-2 bg-blue-100 rounded-lg flex-shrink-0">
                      <FileText className="w-4 h-4 text-blue-600" />
                    </div>

                    {/* Content */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-2 mb-1">
                        <div className="flex-1 min-w-0">
                          <h4 className="text-sm font-semibold text-gray-900">{material.title}</h4>
                          <p className="text-xs text-gray-600 line-clamp-1">{material.description}</p>
                        </div>
                        <span className="text-xs text-gray-500 whitespace-nowrap flex-shrink-0">
                          {material.estimatedTime}
                        </span>
                      </div>

                      {/* Progress Bar - Only show if in progress */}
                      {material.status === "in_progress" && (
                        <div className="mb-2">
                          <div className="flex items-center justify-between text-xs text-gray-600 mb-1">
                            <span>Progress</span>
                            <span>{material.readingProgress}%</span>
                          </div>
                          <div className="w-full bg-gray-200 rounded-full h-1.5">
                            <div
                              className="bg-blue-600 h-1.5 rounded-full transition-all"
                              style={{ width: `${material.readingProgress}%` }}
                            />
                          </div>
                        </div>
                      )}

                      {/* Bottom Row: Status + Button */}
                      <div className="flex items-center justify-between">
                        <Badge
                          className={`text-xs ${
                            material.status === "completed"
                              ? "bg-green-100 text-green-700 border-green-300"
                              : material.status === "in_progress"
                              ? "bg-yellow-100 text-yellow-700 border-yellow-300"
                              : "bg-gray-100 text-gray-700 border-gray-300"
                          }`}
                        >
                          {material.status === "completed"
                            ? "Selesai"
                            : material.status === "in_progress"
                            ? "Sedang Dibaca"
                            : "Belum Dibaca"}
                        </Badge>
                        <Button
                          size="sm"
                          className="bg-blue-600 hover:bg-blue-700 gap-1 h-7 text-xs px-3"
                          onClick={() => navigate(`/patient/material/${material.id}`)}
                        >
                          <PlayCircle className="w-3 h-3" />
                          {material.status === "completed" ? "Baca Ulang" : "Mulai"}
                        </Button>
                      </div>
                    </div>
                  </div>
                ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Schedule Dialog */}
      <Dialog open={showScheduleDialog} onOpenChange={setShowScheduleDialog}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Jadwalkan Tanda Tangan Informed Consent</DialogTitle>
            <DialogDescription>
              Pilih tanggal dan waktu yang sesuai untuk menandatangani informed consent di rumah sakit
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="consentDate">Tanggal</Label>
              <Input
                id="consentDate"
                type="date"
                value={selectedDate}
                onChange={(e) => setSelectedDate(e.target.value)}
                min={new Date().toISOString().split("T")[0]}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="consentTime">Waktu</Label>
              <Input
                id="consentTime"
                type="time"
                value={selectedTime}
                onChange={(e) => setSelectedTime(e.target.value)}
              />
            </div>
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
              <p className="text-sm text-blue-900">
                💡 <strong>Catatan:</strong> Jadwal ini hanya untuk tanda tangan informed consent fisik di rumah
                sakit. Bukan jadwal operasi.
              </p>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowScheduleDialog(false)}>
              Batal
            </Button>
            <Button className="bg-green-600 hover:bg-green-700" onClick={handleScheduleConsent}>
              Konfirmasi Jadwal
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Doctor Chat Dialog */}
      <Dialog open={showDoctorChat} onOpenChange={setShowDoctorChat}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Phone className="w-5 h-5 text-blue-600" />
              Hubungi Dokter Anda
            </DialogTitle>
            <DialogDescription>
              Kirim pesan ke {patientData.doctorName} jika Anda membutuhkan bantuan edukasi offline
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3">
              <p className="text-sm text-yellow-900">
                ⚠️ <strong>Kapan menghubungi dokter?</strong>
              </p>
              <ul className="text-sm text-yellow-800 mt-2 space-y-1">
                <li>• Jika Anda tidak memahami materi setelah membaca dan chat AI</li>
                <li>• Jika Anda memiliki kondisi medis khusus yang membingungkan</li>
                <li>• Jika Anda ingin konsultasi langsung sebelum tanda tangan</li>
              </ul>
            </div>
            <div className="space-y-2">
              <Label htmlFor="doctorMessage">Pesan Anda</Label>
              <textarea
                id="doctorMessage"
                className="w-full min-h-[120px] p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
                placeholder="Tulis pertanyaan atau kekhawatiran Anda di sini..."
                value={doctorMessage}
                onChange={(e) => setDoctorMessage(e.target.value)}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowDoctorChat(false)}>
              Batal
            </Button>
            <Button className="bg-blue-600 hover:bg-blue-700 gap-2" onClick={handleSendMessageToDoctor}>
              <Send className="w-4 h-4" />
              Kirim Pesan
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}