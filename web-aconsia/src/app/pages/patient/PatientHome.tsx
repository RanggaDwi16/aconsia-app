import { useState } from "react";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { useNavigate } from "react-router";
import { AlertCircle, Calendar, BookOpen, MessageSquare, TrendingUp, CheckCircle } from "lucide-react";

interface PatientStatus {
  status: "pending" | "approved" | "in_education" | "ready";
  approvedAnesthesia?: string;
  comprehensionScore: number;
  doctorName?: string;
  scheduledDate?: string;
}

export function PatientHome() {
  const navigate = useNavigate();
  
  // Simulate patient status - in real app, fetch from backend
  const [patientStatus] = useState<PatientStatus>({
    status: "approved",
    approvedAnesthesia: "General Anesthesia", // SET BY DOCTOR
    comprehensionScore: 0, // START FROM 0%
    doctorName: "Dr. Ahmad Suryadi, Sp.An",
    scheduledDate: undefined,
  });

  const patientName = "Jordan Smith";

  // ALL AVAILABLE Learning materials
  const allMaterials = [
    {
      id: "1",
      title: "Pengenalan Anestesi Umum",
      description: "Memahami dasar-dasar anestesi umum sebelum operasi",
      type: "General Anesthesia",
      readingProgress: 0,
      status: "not_started",
      estimatedTime: "15 menit",
    },
    {
      id: "2",
      title: "Persiapan Sebelum Anestesi Umum",
      description: "Hal-hal yang perlu dipersiapkan sebelum menjalani anestesi umum",
      type: "General Anesthesia",
      readingProgress: 0,
      status: "not_started",
      estimatedTime: "10 menit",
    },
    {
      id: "3",
      title: "Prosedur Anestesi Umum",
      description: "Tahapan dan proses pemberian anestesi umum",
      type: "General Anesthesia",
      readingProgress: 0,
      status: "not_started",
      estimatedTime: "20 menit",
    },
    {
      id: "4",
      title: "Pengenalan Anestesi Spinal",
      description: "Memahami anestesi spinal untuk operasi bagian bawah tubuh",
      type: "Spinal Anesthesia",
      readingProgress: 0,
      status: "not_started",
      estimatedTime: "15 menit",
    },
    {
      id: "5",
      title: "Persiapan Anestesi Spinal",
      description: "Persiapan khusus untuk anestesi spinal",
      type: "Spinal Anesthesia",
      readingProgress: 0,
      status: "not_started",
      estimatedTime: "12 menit",
    },
    {
      id: "6",
      title: "Anestesi Epidural: Panduan Lengkap",
      description: "Memahami teknik anestesi epidural",
      type: "Epidural Anesthesia",
      readingProgress: 0,
      status: "not_started",
      estimatedTime: "18 menit",
    },
  ];

  // ✅ FILTER BASED ON APPROVED ANESTHESIA TYPE
  const materials = patientStatus.approvedAnesthesia
    ? allMaterials.filter(m => m.type === patientStatus.approvedAnesthesia)
    : [];

  // Calculate if patient has started learning
  const hasStartedLearning = materials.some(m => m.readingProgress > 0);
  
  // AI Recommendations - ONLY show after reading some materials
  const getAIRecommendations = () => {
    if (!hasStartedLearning) {
      return [];
    }

    // Find weak areas based on reading progress
    const incompleteMaterials = materials.filter(m => m.readingProgress < 100);
    const lowProgressMaterials = materials.filter(m => m.readingProgress > 0 && m.readingProgress < 50);

    const recommendations = [];

    // Priority 1: Materials with low progress (started but not finished)
    if (lowProgressMaterials.length > 0) {
      recommendations.push({
        id: lowProgressMaterials[0].id,
        title: lowProgressMaterials[0].title,
        reason: "Anda sudah memulai materi ini. Lanjutkan untuk pemahaman lebih baik!",
        type: lowProgressMaterials[0].type,
        priority: "high",
        readingProgress: lowProgressMaterials[0].readingProgress,
      });
    }

    // Priority 2: Next unread material
    const nextUnread = incompleteMaterials.find(m => m.readingProgress === 0);
    if (nextUnread && recommendations.length < 2) {
      recommendations.push({
        id: nextUnread.id,
        title: nextUnread.title,
        reason: "Materi berikutnya yang perlu Anda pelajari",
        type: nextUnread.type,
        priority: "medium",
        readingProgress: nextUnread.readingProgress,
      });
    }

    return recommendations;
  };

  const aiRecommendations = getAIRecommendations();

  if (patientStatus.status === "pending") {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-white">
        <div className="container mx-auto px-4 py-8">
          {/* Header */}
          <div className="flex items-center justify-between mb-8">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">{patientName}</h1>
              <p className="text-gray-600">Pasien</p>
            </div>
          </div>

          {/* Pending Status Card */}
          <Card className="border-orange-200 bg-orange-50 max-w-md mx-auto mt-20">
            <CardContent className="p-8 text-center">
              <div className="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <AlertCircle className="w-10 h-10 text-orange-600" />
              </div>
              <h2 className="text-xl font-bold mb-4">Data Teknik Anestesi Anda Belum Dipilih Oleh Dokter</h2>
              <p className="text-gray-700 mb-6">
                Silahkan tunggu dokter mengkonfirmasi teknik anestesi anda / hubungi dokter yang berwenang untuk mengkonfirmasi teknik anestesi anda.
              </p>
              <Button className="bg-blue-600 hover:bg-blue-700 w-full">
                Hubungi Dokter
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-white">
      <div className="container mx-auto px-4 py-8 max-w-2xl">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">{patientName}</h1>
            <p className="text-gray-600">Pasien</p>
          </div>
          <Button variant="outline" size="sm" onClick={() => navigate('/patient/profile')}>
            Lihat Profil
          </Button>
        </div>

        {/* Dashboard Title */}
        <div className="mb-6">
          <h2 className="text-xl font-bold text-gray-900">Dashboard Pasien</h2>
          <p className="text-gray-600 text-sm">Pantau progress pembelajaran Anda</p>
        </div>

        <div className="space-y-6">
          {/* Overall Progress */}
          <Card className="border-blue-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <p className="text-sm text-gray-600">Tingkat Pemahaman Keseluruhan</p>
                  <p className="text-3xl font-bold text-blue-600">{patientStatus.comprehensionScore}%</p>
                </div>
                <div className="w-20 h-20 bg-blue-100 rounded-full flex items-center justify-center">
                  <TrendingUp className="w-10 h-10 text-blue-600" />
                </div>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-3">
                <div 
                  className="bg-blue-600 h-3 rounded-full transition-all duration-500"
                  style={{ width: `${patientStatus.comprehensionScore}%` }}
                />
              </div>
              <p className="text-xs text-gray-500 mt-2">
                {patientStatus.comprehensionScore >= 80 
                  ? "✅ Anda sudah siap untuk informed consent!"
                  : `Teruskan belajar! Anda perlu ${80 - patientStatus.comprehensionScore}% lagi untuk siap.`
                }
              </p>
            </CardContent>
          </Card>

          {/* AI Recommendations */}
          {aiRecommendations.length > 0 && (
            <Card>
              <CardContent className="p-6">
                <div className="flex items-start gap-3 mb-4">
                  <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg flex items-center justify-center flex-shrink-0">
                    <MessageSquare className="w-5 h-5 text-white" />
                  </div>
                  <div>
                    <h3 className="font-bold text-gray-900 flex items-center gap-2">
                      🤖 Rekomendasi AI
                    </h3>
                    <p className="text-sm text-gray-600">
                      Berdasarkan analisis progress membaca Anda:
                    </p>
                  </div>
                </div>

                <div className="space-y-3">
                  {aiRecommendations.map((rec) => (
                    <Card key={rec.id} className="border-purple-200 bg-gradient-to-br from-purple-50 to-pink-50">
                      <CardContent className="p-4">
                        <div className="flex items-start justify-between mb-2">
                          <div className="flex-1">
                            <h4 className="font-semibold text-gray-900">{rec.title}</h4>
                            <p className="text-xs text-gray-600 mt-1">{rec.reason}</p>
                          </div>
                          <Badge variant="secondary" className="ml-2">
                            {rec.type}
                          </Badge>
                        </div>
                        <Button 
                          size="sm" 
                          className="w-full bg-blue-600 hover:bg-blue-700 mt-3"
                          onClick={() => navigate(`/patient/material/${rec.id}`)}
                        >
                          Lanjutkan Membaca
                        </Button>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {/* Schedule Informed Consent */}
          <Card>
            <CardContent className="p-6">
              <div className="flex items-start gap-3 mb-4">
                <Calendar className="w-5 h-5 text-blue-600 mt-1" />
                <div className="flex-1">
                  <h3 className="font-bold text-gray-900">Jadwalkan Tanda Tangan Anestesi</h3>
                  <p className="text-sm text-gray-600 mt-1">
                    Hal-hal yang perlu diperhatikan sebelum menjalani...
                  </p>
                </div>
              </div>
              
              {patientStatus.comprehensionScore >= 80 ? (
                <div>
                  {patientStatus.scheduledDate ? (
                    <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-3">
                      <div className="flex items-center gap-2 text-green-700 mb-1">
                        <CheckCircle className="w-4 h-4" />
                        <span className="font-semibold">Jadwal Terkonfirmasi</span>
                      </div>
                      <p className="text-sm text-gray-700">{patientStatus.scheduledDate}</p>
                    </div>
                  ) : (
                    <Badge variant="secondary" className="mb-3">Belum Selesai</Badge>
                  )}
                  <Button 
                    className="w-full bg-blue-600 hover:bg-blue-700"
                    onClick={() => navigate('/patient/schedule-consent')}
                  >
                    {patientStatus.scheduledDate ? 'Ubah Jadwal' : 'Pilih Jadwal'}
                  </Button>
                </div>
              ) : (
                <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                  <p className="text-sm text-gray-600">
                    🔒 Selesaikan pembelajaran minimal 80% untuk dapat menjadwalkan informed consent
                  </p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Learning Materials */}
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center gap-2 mb-4">
                <BookOpen className="w-5 h-5 text-blue-600" />
                <h3 className="font-bold text-gray-900">Materi Pembelajaran</h3>
              </div>
              <p className="text-sm text-gray-600 mb-4">Konten edukasi dari dokter Anda</p>

              <div className="space-y-3">
                {materials.map((material) => (
                  <Card key={material.id} className="border-gray-200 hover:border-blue-300 transition-colors">
                    <CardContent className="p-4">
                      <div className="flex items-start justify-between mb-2">
                        <div className="flex-1">
                          <h4 className="font-semibold text-gray-900">{material.title}</h4>
                          <p className="text-sm text-gray-600 mt-1">{material.description}</p>
                          <div className="flex items-center gap-2 mt-2">
                            <Badge 
                              variant={material.status === "not_started" ? "secondary" : "default"}
                              className={material.status === "not_started" ? "bg-red-100 text-red-700" : ""}
                            >
                              {material.status === "not_started" ? "Belum Selesai" : "Selesai"}
                            </Badge>
                            <span className="text-xs text-gray-500">⏱️ {material.estimatedTime}</span>
                          </div>
                        </div>
                      </div>
                      
                      <div className="mt-3">
                        <div className="flex items-center justify-between text-sm mb-1">
                          <span className="text-gray-600">Progress Membaca:</span>
                          <span className="font-semibold text-blue-600">{material.readingProgress}%</span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-2">
                          <div 
                            className="bg-blue-600 h-2 rounded-full transition-all"
                            style={{ width: `${material.readingProgress}%` }}
                          />
                        </div>
                      </div>

                      <Button 
                        size="sm" 
                        className="w-full bg-blue-600 hover:bg-blue-700 mt-3"
                        onClick={() => navigate(`/patient/material/${material.id}`)}
                      >
                        {material.readingProgress > 0 ? 'Lanjutkan' : 'Mulai'}
                      </Button>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}