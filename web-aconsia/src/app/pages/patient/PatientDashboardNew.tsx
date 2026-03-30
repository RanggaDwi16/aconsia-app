import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Progress } from "../../components/ui/progress";
import { useNavigate } from "react-router";
import {
  User,
  BookOpen,
  FileSignature,
  MessageCircle,
  Phone,
  Clock,
  CheckCircle,
  AlertCircle,
  Calendar,
  MapPin,
  Activity,
  Heart,
  TrendingUp,
  LogOut,
} from "lucide-react";

export function PatientDashboardNew() {
  const navigate = useNavigate();
  const [patientData, setPatientData] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Load patient data
    const currentPatient = localStorage.getItem("currentPatient");
    if (currentPatient) {
      setPatientData(JSON.parse(currentPatient));
    }
    setLoading(false);
  }, []);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Memuat data...</p>
        </div>
      </div>
    );
  }

  if (!patientData) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50 flex items-center justify-center">
        <Card className="max-w-md">
          <CardContent className="p-8 text-center">
            <AlertCircle className="w-16 h-16 text-red-600 mx-auto mb-4" />
            <h3 className="text-xl font-bold mb-2">Data Pasien Tidak Ditemukan</h3>
            <p className="text-gray-600 mb-4">Silakan daftar terlebih dahulu</p>
            <Button onClick={() => navigate("/patient/register")} className="w-full">
              Daftar Sekarang
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  // Get anesthesia type label
  const getAnesthesiaLabel = (type: string) => {
    const labels: Record<string, string> = {
      general: "Anestesi Umum",
      spinal: "Anestesi Spinal",
      epidural: "Anestesi Epidural",
      regional: "Anestesi Regional",
      local: "Anestesi Lokal + Sedasi",
    };
    return labels[type] || "Belum Ditentukan";
  };

  const comprehensionScore = patientData.comprehensionScore || 0;
  const canScheduleSignature = comprehensionScore >= 80;
  const hasScheduledDate = !!patientData.scheduledSignatureDate;

  const handleLogout = () => {
    localStorage.removeItem("currentPatient");
    localStorage.removeItem("userRole");
    navigate("/");
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Simple Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Dashboard Pasien</h1>
              <p className="text-sm text-gray-600 mt-1">{patientData.fullName}</p>
            </div>
            <div className="flex items-center gap-4">
              <div className="text-right">
                <div className="text-xs text-gray-500">No. Rekam Medis</div>
                <div className="text-lg font-semibold text-gray-900">{patientData.mrn}</div>
              </div>
              <Button
                onClick={handleLogout}
                variant="outline"
                className="border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300"
              >
                <LogOut className="w-4 h-4 mr-2" />
                Keluar
              </Button>
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-6 py-8 max-w-5xl">
        {/* Status Alert */}
        {patientData.status === "pending" && (
          <div className="mb-6 p-4 bg-orange-50 border-l-4 border-orange-400 rounded">
            <div className="flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-orange-600 mt-0.5" />
              <div>
                <h4 className="font-semibold text-orange-900 mb-1">Menunggu Persetujuan Dokter</h4>
                <p className="text-sm text-orange-800">
                  Dokter {patientData.doctorName || patientData.anesthesiologistName} sedang meninjau data Anda. 
                  Anda akan mendapat notifikasi ketika sudah disetujui.
                </p>
              </div>
            </div>
          </div>
        )}

        {/* AI Recommendations - Show only if comprehension > 0 */}
        {patientData.status === "approved" && comprehensionScore > 0 && comprehensionScore < 80 && (
          <div className="mb-6 bg-gradient-to-r from-purple-50 to-pink-50 border border-purple-200 rounded-lg p-5">
            <h3 className="text-base font-semibold text-purple-900 mb-3 flex items-center gap-2">
              <span className="text-purple-600">✨</span> Rekomendasi AI
            </h3>
            <p className="text-sm text-purple-800 mb-4">
              Berdasarkan progress membaca Anda, kami merekomendasikan:
            </p>
            <div className="space-y-3">
              {/* Recommendation 1 */}
              <div className="bg-white border border-orange-200 rounded-lg p-4">
                <div className="flex items-start gap-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <h4 className="font-semibold text-gray-900">Pelajari Materi Dasar Anestesi</h4>
                      <Badge className="bg-orange-500 text-white text-xs">Penting</Badge>
                    </div>
                    <p className="text-sm text-gray-600 mb-3">
                      Pemahaman Anda masih di bawah 80%. Mari pelajari materi dasar terlebih dahulu.
                    </p>
                    <Button
                      size="sm"
                      className="bg-purple-600 hover:bg-purple-700 text-white"
                      onClick={() => navigate("/patient/material/1")}
                    >
                      Mulai Belajar
                    </Button>
                  </div>
                </div>
              </div>

              {/* Recommendation 2 */}
              <div className="bg-white border border-yellow-200 rounded-lg p-4">
                <div className="flex items-start gap-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <h4 className="font-semibold text-gray-900">Chat dengan AI Assistant</h4>
                      <Badge className="bg-yellow-500 text-white text-xs">Sedang</Badge>
                    </div>
                    <p className="text-sm text-gray-600 mb-3">
                      AI Assistant dapat menjawab pertanyaan Anda secara interaktif dan membantu pemahaman.
                    </p>
                    <Button
                      size="sm"
                      variant="outline"
                      className="border-purple-300 text-purple-700 hover:bg-purple-50"
                      onClick={() => navigate("/patient/chat-hybrid")}
                    >
                      Mulai Chat
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Celebration if score >= 80 */}
        {patientData.status === "approved" && comprehensionScore >= 80 && !hasScheduledDate && (
          <div className="mb-6 bg-gradient-to-r from-green-50 to-emerald-50 border border-green-300 rounded-lg p-5">
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-600 mt-0.5" />
              <div className="flex-1">
                <h4 className="font-semibold text-green-900 mb-1">🎉 Selamat! Anda Sudah Memenuhi Syarat</h4>
                <p className="text-sm text-green-800 mb-3">
                  Pemahaman Anda sudah mencapai {comprehensionScore}%. Anda dapat jadwalkan tanda tangan informed consent sekarang.
                </p>
                <Button
                  size="sm"
                  className="bg-green-600 hover:bg-green-700 text-white"
                  onClick={() => navigate("/patient/schedule-signature")}
                >
                  Jadwalkan Sekarang
                </Button>
              </div>
            </div>
          </div>
        )}

        {/* Main Content - 2 Columns */}
        <div className="grid lg:grid-cols-3 gap-6">
          {/* Left: Menu Cards */}
          <div className="lg:col-span-2 space-y-4">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Menu</h2>

            {/* 1. Materi Pembelajaran */}
            <button
              onClick={() => navigate("/patient/material/1")}
              disabled={patientData.status !== "approved"}
              className={`w-full p-6 rounded-lg border-2 text-left transition-all ${
                patientData.status === "approved"
                  ? "bg-white border-blue-200 hover:border-blue-400 hover:shadow-md cursor-pointer"
                  : "bg-gray-50 border-gray-200 cursor-not-allowed opacity-60"
              }`}
            >
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-lg flex items-center justify-center ${
                  patientData.status === "approved" ? "bg-blue-100" : "bg-gray-200"
                }`}>
                  <BookOpen className={`w-6 h-6 ${patientData.status === "approved" ? "text-blue-600" : "text-gray-400"}`} />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900 mb-1">Materi Pembelajaran</h3>
                  <p className="text-sm text-gray-600">
                    {patientData.status === "approved" 
                      ? `Pelajari tentang ${getAnesthesiaLabel(patientData.anesthesiaType)} + Chat AI`
                      : "Menunggu persetujuan dokter"
                    }
                  </p>
                </div>
                {patientData.status === "approved" && (
                  <div className="text-blue-600">→</div>
                )}
              </div>
            </button>

            {/* 2. Jadwal Tanda Tangan */}
            <button
              onClick={() => navigate("/patient/schedule-signature")}
              disabled={!canScheduleSignature}
              className={`w-full p-6 rounded-lg border-2 text-left transition-all ${
                canScheduleSignature
                  ? "bg-white border-green-200 hover:border-green-400 hover:shadow-md cursor-pointer"
                  : "bg-gray-50 border-gray-200 cursor-not-allowed opacity-60"
              }`}
            >
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-lg flex items-center justify-center ${
                  canScheduleSignature ? "bg-green-100" : "bg-gray-200"
                }`}>
                  <FileSignature className={`w-6 h-6 ${canScheduleSignature ? "text-green-600" : "text-gray-400"}`} />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900 mb-1">Jadwal Tanda Tangan</h3>
                  <p className="text-sm text-gray-600">
                    {canScheduleSignature 
                      ? (hasScheduledDate ? "Jadwal Anda sudah dibuat" : "Pilih waktu untuk tanda tangan informed consent")
                      : `Perlu pemahaman minimal 80% (saat ini: ${comprehensionScore}%)`
                    }
                  </p>
                </div>
                {canScheduleSignature && (
                  <div className="text-green-600">→</div>
                )}
              </div>
            </button>

            {/* 3. Hubungi Dokter */}
            <button
              onClick={() => navigate("/patient/contact-doctor")}
              disabled={!canScheduleSignature}
              className={`w-full p-6 rounded-lg border-2 text-left transition-all ${
                canScheduleSignature
                  ? "bg-white border-orange-200 hover:border-orange-400 hover:shadow-md cursor-pointer"
                  : "bg-gray-50 border-gray-200 cursor-not-allowed opacity-60"
              }`}
            >
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-lg flex items-center justify-center ${
                  canScheduleSignature ? "bg-orange-100" : "bg-gray-200"
                }`}>
                  <Phone className={`w-6 h-6 ${canScheduleSignature ? "text-orange-600" : "text-gray-400"}`} />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900 mb-1">Hubungi Dokter</h3>
                  <p className="text-sm text-gray-600">
                    {canScheduleSignature
                      ? "Kirim pesan jika butuh bantuan"
                      : "Tersedia setelah selesai pembelajaran"
                    }
                  </p>
                </div>
                {canScheduleSignature && (
                  <div className="text-orange-600">→</div>
                )}
              </div>
            </button>

            {/* 4. Profil Saya */}
            <button
              onClick={() => navigate("/patient/profile")}
              className="w-full p-6 rounded-lg border-2 bg-white border-gray-200 hover:border-gray-400 hover:shadow-md text-left transition-all"
            >
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
                  <User className="w-6 h-6 text-gray-600" />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900 mb-1">Profil Saya</h3>
                  <p className="text-sm text-gray-600">Lihat identitas lengkap pasien</p>
                </div>
                <div className="text-gray-600">→</div>
              </div>
            </button>
          </div>

          {/* Right: Info Sidebar */}
          <div className="space-y-4">
            {/* Progress */}
            <div className="bg-white p-6 rounded-lg border border-gray-200">
              <h3 className="text-sm font-semibold text-gray-700 mb-3">Progress Pemahaman</h3>
              <div className="text-center mb-4">
                <div className="text-4xl font-bold text-blue-600 mb-2">{comprehensionScore}%</div>
                <Progress value={comprehensionScore} className="h-2" />
              </div>
              {comprehensionScore < 80 && (
                <p className="text-xs text-gray-600 text-center">
                  Target: 80% untuk jadwal tanda tangan
                </p>
              )}
              {comprehensionScore >= 80 && (
                <p className="text-xs text-green-700 text-center font-medium">
                  ✓ Sudah memenuhi syarat untuk TTD
                </p>
              )}
            </div>

            {/* Scheduled Date */}
            {hasScheduledDate && (
              <div className="bg-green-50 p-6 rounded-lg border border-green-200">
                <h3 className="text-sm font-semibold text-green-900 mb-2">Jadwal Tanda Tangan</h3>
                <div className="flex items-start gap-2">
                  <Calendar className="w-4 h-4 text-green-600 mt-0.5" />
                  <div className="text-sm text-green-800">
                    <p className="font-medium">
                      {new Date(patientData.scheduledSignatureDate).toLocaleDateString('id-ID', { 
                        day: 'numeric', 
                        month: 'long',
                        year: 'numeric' 
                      })}
                    </p>
                    <p className="text-xs">Pukul {patientData.scheduledSignatureTime || "-"}</p>
                  </div>
                </div>
              </div>
            )}

            {/* Patient Info */}
            <div className="bg-white p-6 rounded-lg border border-gray-200">
              <h3 className="text-sm font-semibold text-gray-700 mb-4">Info Operasi</h3>
              <div className="space-y-3 text-sm">
                <div>
                  <p className="text-gray-500 text-xs mb-1">Jenis Operasi</p>
                  <p className="font-medium text-gray-900">{patientData.surgeryType}</p>
                </div>
                <div>
                  <p className="text-gray-500 text-xs mb-1">Tanggal Operasi</p>
                  <p className="font-medium text-gray-900">
                    {new Date(patientData.surgeryDate).toLocaleDateString('id-ID', { 
                      day: 'numeric', 
                      month: 'long',
                      year: 'numeric' 
                    })}
                  </p>
                </div>
                <div>
                  <p className="text-gray-500 text-xs mb-1">Jenis Anestesi</p>
                  <Badge className="bg-blue-600 text-white">
                    {getAnesthesiaLabel(patientData.anesthesiaType)}
                  </Badge>
                </div>
                <div>
                  <p className="text-gray-500 text-xs mb-1">Dokter Anestesi</p>
                  <p className="font-medium text-gray-900">{patientData.doctorName || patientData.anesthesiologistName}</p>
                </div>
                <div>
                  <p className="text-gray-500 text-xs mb-1">Rumah Sakit</p>
                  <p className="font-medium text-gray-900">{patientData.hospitalName || "-"}</p>
                </div>
              </div>
            </div>

            {/* Health Notes */}
            <div className="bg-white p-6 rounded-lg border border-gray-200">
              <h3 className="text-sm font-semibold text-gray-700 mb-4">Catatan Kesehatan</h3>
              <div className="space-y-3 text-sm">
                <div>
                  <p className="text-gray-500 text-xs mb-1">Alergi</p>
                  <p className="text-gray-900">{patientData.allergies || "Tidak ada"}</p>
                </div>
                <div>
                  <p className="text-gray-500 text-xs mb-1">Riwayat Penyakit</p>
                  <p className="text-gray-900">{patientData.medicalHistory || "Tidak ada"}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}