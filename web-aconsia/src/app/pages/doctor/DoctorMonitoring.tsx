import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { 
  ArrowLeft, 
  User, 
  Clock, 
  CheckCircle, 
  AlertTriangle,
  Eye,
  FileText,
  TrendingUp,
  Bell
} from "lucide-react";
import { useNavigate } from "react-router";

interface PatientProgress {
  id: string;
  name: string;
  noRM: string;
  anesthesiaType: string;
  approvedDate: string;
  overallProgress: number;
  currentSection: string;
  timeSpent: number; // minutes
  quizScores: Array<{
    section: string;
    score: number;
    attempts: number;
  }>;
  aiChatStats: {
    totalQuestions: number;
    topicsAsked: string[];
  };
  status: "not-started" | "in-progress" | "completed";
  redFlags: string[];
}

export function DoctorMonitoring() {
  const navigate = useNavigate();
  
  // Demo data
  const [patients] = useState<PatientProgress[]>([
    {
      id: "1",
      name: "Siti Aminah",
      noRM: "RM-2024-001",
      anesthesiaType: "General Anesthesia",
      approvedDate: "2026-03-14 09:00",
      overallProgress: 100,
      currentSection: "Selesai",
      timeSpent: 45,
      quizScores: [
        { section: "Section 1", score: 100, attempts: 1 },
        { section: "Section 2", score: 100, attempts: 1 },
        { section: "Section 3", score: 75, attempts: 2 },
        { section: "Section 4", score: 100, attempts: 1 },
        { section: "Section 5", score: 100, attempts: 1 },
        { section: "Section 6", score: 100, attempts: 1 },
        { section: "Section 7", score: 100, attempts: 1 },
        { section: "Section 8", score: 100, attempts: 1 },
        { section: "Section 9", score: 100, attempts: 1 },
        { section: "Section 10", score: 100, attempts: 1 },
      ],
      aiChatStats: {
        totalQuestions: 12,
        topicsAsked: ["Efek samping", "Risiko", "Puasa"],
      },
      status: "completed",
      redFlags: [],
    },
    {
      id: "2",
      name: "Budi Santoso",
      noRM: "RM-2024-002",
      anesthesiaType: "Spinal Anesthesia",
      approvedDate: "2026-03-14 10:30",
      overallProgress: 40,
      currentSection: "Section 4",
      timeSpent: 18,
      quizScores: [
        { section: "Section 1", score: 100, attempts: 1 },
        { section: "Section 2", score: 75, attempts: 3 },
        { section: "Section 3", score: 100, attempts: 1 },
      ],
      aiChatStats: {
        totalQuestions: 0,
        topicsAsked: [],
      },
      status: "in-progress",
      redFlags: ["Stuck di Section 4 lebih dari 30 menit", "Quiz Section 2 failed 3x"],
    },
    {
      id: "3",
      name: "Dewi Lestari",
      noRM: "RM-2024-003",
      anesthesiaType: "General Anesthesia",
      approvedDate: "2026-03-14 11:00",
      overallProgress: 0,
      currentSection: "Belum dimulai",
      timeSpent: 0,
      quizScores: [],
      aiChatStats: {
        totalQuestions: 0,
        topicsAsked: [],
      },
      status: "not-started",
      redFlags: ["Belum memulai edukasi > 2 jam setelah approval"],
    },
  ]);

  const [selectedPatient, setSelectedPatient] = useState<PatientProgress | null>(null);

  const getStatusColor = (status: string) => {
    if (status === "completed") return "bg-green-100 text-green-800 border-green-300";
    if (status === "in-progress") return "bg-blue-100 text-blue-800 border-blue-300";
    return "bg-gray-100 text-gray-800 border-gray-300";
  };

  const getProgressColor = (progress: number) => {
    if (progress === 100) return "bg-green-600";
    if (progress >= 50) return "bg-blue-600";
    if (progress >= 20) return "bg-yellow-600";
    return "bg-red-600";
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50">
      <div className="container mx-auto px-4 py-8 max-w-7xl">
        {/* Header */}
        <div className="flex items-center gap-4 mb-6">
          <Button variant="ghost" size="sm" onClick={() => navigate("/doctor")}>
            <ArrowLeft className="w-4 h-4 mr-2" />
            Kembali
          </Button>
          <div className="flex-1">
            <h1 className="text-2xl font-bold text-gray-900">Monitoring Progres Pasien</h1>
            <p className="text-sm text-gray-600">Real-time tracking edukasi informed consent</p>
          </div>
          <Badge variant="secondary" className="bg-blue-600 text-white">
            <Bell className="w-4 h-4 mr-1" />
            {patients.filter(p => p.redFlags.length > 0).length} Notifikasi
          </Badge>
        </div>

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <Card className="border-blue-200">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-gray-600">Total Pasien</p>
                  <p className="text-2xl font-bold text-gray-900">{patients.length}</p>
                </div>
                <User className="w-8 h-8 text-blue-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="border-green-200">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-gray-600">Selesai</p>
                  <p className="text-2xl font-bold text-green-600">
                    {patients.filter(p => p.status === "completed").length}
                  </p>
                </div>
                <CheckCircle className="w-8 h-8 text-green-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="border-yellow-200">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-gray-600">Dalam Proses</p>
                  <p className="text-2xl font-bold text-yellow-600">
                    {patients.filter(p => p.status === "in-progress").length}
                  </p>
                </div>
                <TrendingUp className="w-8 h-8 text-yellow-600" />
              </div>
            </CardContent>
          </Card>

          <Card className="border-red-200">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-gray-600">Perlu Perhatian</p>
                  <p className="text-2xl font-bold text-red-600">
                    {patients.filter(p => p.redFlags.length > 0).length}
                  </p>
                </div>
                <AlertTriangle className="w-8 h-8 text-red-600" />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Patient List */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {patients.map((patient) => (
            <Card 
              key={patient.id} 
              className={`border-2 cursor-pointer transition-all hover:shadow-lg ${
                patient.redFlags.length > 0 ? "border-red-300 bg-red-50" : "border-gray-200"
              }`}
              onClick={() => setSelectedPatient(patient)}
            >
              <CardHeader className="pb-3">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <CardTitle className="text-lg mb-1">{patient.name}</CardTitle>
                    <div className="flex items-center gap-2 text-xs text-gray-600">
                      <span>{patient.noRM}</span>
                      <span>•</span>
                      <span>{patient.anesthesiaType}</span>
                    </div>
                  </div>
                  <Badge className={`${getStatusColor(patient.status)} border`}>
                    {patient.status === "completed" && "Selesai"}
                    {patient.status === "in-progress" && "Dalam Proses"}
                    {patient.status === "not-started" && "Belum Mulai"}
                  </Badge>
                </div>
              </CardHeader>

              <CardContent className="space-y-3">
                {/* Progress Bar */}
                <div>
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-xs font-semibold text-gray-700">Progress</span>
                    <span className="text-sm font-bold text-gray-900">{patient.overallProgress}%</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div 
                      className={`${getProgressColor(patient.overallProgress)} h-2 rounded-full transition-all`}
                      style={{ width: `${patient.overallProgress}%` }}
                    />
                  </div>
                </div>

                {/* Stats */}
                <div className="grid grid-cols-2 gap-2 text-xs">
                  <div className="bg-blue-50 rounded p-2">
                    <div className="flex items-center gap-1 text-blue-700">
                      <Clock className="w-3 h-3" />
                      <span className="font-semibold">Waktu</span>
                    </div>
                    <p className="text-gray-900 font-bold mt-0.5">{patient.timeSpent} menit</p>
                  </div>
                  <div className="bg-green-50 rounded p-2">
                    <div className="flex items-center gap-1 text-green-700">
                      <CheckCircle className="w-3 h-3" />
                      <span className="font-semibold">Section</span>
                    </div>
                    <p className="text-gray-900 font-bold mt-0.5">{patient.currentSection}</p>
                  </div>
                </div>

                {/* Red Flags */}
                {patient.redFlags.length > 0 && (
                  <div className="bg-red-100 border border-red-300 rounded p-2">
                    <div className="flex items-center gap-1 mb-1">
                      <AlertTriangle className="w-4 h-4 text-red-600" />
                      <span className="text-xs font-bold text-red-900">Perlu Perhatian:</span>
                    </div>
                    <ul className="text-xs text-red-800 space-y-0.5">
                      {patient.redFlags.map((flag, idx) => (
                        <li key={idx}>• {flag}</li>
                      ))}
                    </ul>
                  </div>
                )}

                {/* Actions */}
                <div className="flex gap-2 pt-2">
                  <Button 
                    size="sm" 
                    className="flex-1 bg-blue-600 hover:bg-blue-700"
                    onClick={(e) => {
                      e.stopPropagation();
                      setSelectedPatient(patient);
                    }}
                  >
                    <Eye className="w-3 h-3 mr-1" />
                    Lihat Detail
                  </Button>
                  {patient.status === "completed" && (
                    <Button 
                      size="sm" 
                      variant="outline"
                      className="flex-1"
                      onClick={(e) => {
                        e.stopPropagation();
                        // TODO: Generate PDF report
                        alert("Generate PDF Report untuk " + patient.name);
                      }}
                    >
                      <FileText className="w-3 h-3 mr-1" />
                      Report
                    </Button>
                  )}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Detail Modal/Panel */}
        {selectedPatient && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50" onClick={() => setSelectedPatient(null)}>
            <Card className="max-w-4xl w-full max-h-[90vh] overflow-y-auto" onClick={(e) => e.stopPropagation()}>
              <CardHeader className="border-b sticky top-0 bg-white z-10">
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-xl">{selectedPatient.name}</CardTitle>
                    <p className="text-sm text-gray-600">{selectedPatient.noRM} • {selectedPatient.anesthesiaType}</p>
                  </div>
                  <Button variant="ghost" size="sm" onClick={() => setSelectedPatient(null)}>
                    ✕
                  </Button>
                </div>
              </CardHeader>

              <CardContent className="p-6 space-y-6">
                {/* Overview */}
                <div className="grid grid-cols-3 gap-4">
                  <Card className="bg-blue-50">
                    <CardContent className="p-4 text-center">
                      <p className="text-xs text-gray-600 mb-1">Overall Progress</p>
                      <p className="text-3xl font-bold text-blue-600">{selectedPatient.overallProgress}%</p>
                    </CardContent>
                  </Card>
                  <Card className="bg-green-50">
                    <CardContent className="p-4 text-center">
                      <p className="text-xs text-gray-600 mb-1">Waktu Total</p>
                      <p className="text-3xl font-bold text-green-600">{selectedPatient.timeSpent} min</p>
                    </CardContent>
                  </Card>
                  <Card className="bg-purple-50">
                    <CardContent className="p-4 text-center">
                      <p className="text-xs text-gray-600 mb-1">AI Questions</p>
                      <p className="text-3xl font-bold text-purple-600">{selectedPatient.aiChatStats.totalQuestions}</p>
                    </CardContent>
                  </Card>
                </div>

                {/* Quiz Scores */}
                <div>
                  <h3 className="font-bold text-gray-900 mb-3 flex items-center gap-2">
                    <CheckCircle className="w-5 h-5 text-green-600" />
                    Quiz Scores (per Section)
                  </h3>
                  <div className="space-y-2">
                    {selectedPatient.quizScores.map((quiz, idx) => (
                      <div key={idx} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                        <span className="text-sm font-medium text-gray-700 flex-1">{quiz.section}</span>
                        <div className="flex items-center gap-2">
                          <span className={`text-sm font-bold ${quiz.score === 100 ? "text-green-600" : "text-orange-600"}`}>
                            {quiz.score}%
                          </span>
                          {quiz.attempts > 1 && (
                            <Badge variant="outline" className="text-xs">
                              {quiz.attempts}x attempt
                            </Badge>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* AI Chat Summary */}
                {selectedPatient.aiChatStats.totalQuestions > 0 && (
                  <div>
                    <h3 className="font-bold text-gray-900 mb-3 flex items-center gap-2">
                      <FileText className="w-5 h-5 text-blue-600" />
                      AI Chat Summary
                    </h3>
                    <Card className="bg-blue-50">
                      <CardContent className="p-4">
                        <p className="text-sm mb-2">
                          <strong>Total Pertanyaan:</strong> {selectedPatient.aiChatStats.totalQuestions}
                        </p>
                        <p className="text-sm">
                          <strong>Topik yang Ditanyakan:</strong>{" "}
                          {selectedPatient.aiChatStats.topicsAsked.join(", ")}
                        </p>
                      </CardContent>
                    </Card>
                  </div>
                )}

                {/* Recommendations */}
                {selectedPatient.redFlags.length > 0 && (
                  <div>
                    <h3 className="font-bold text-gray-900 mb-3 flex items-center gap-2">
                      <AlertTriangle className="w-5 h-5 text-red-600" />
                      Rekomendasi Dokter
                    </h3>
                    <Card className="bg-red-50 border-red-200">
                      <CardContent className="p-4">
                        <ul className="space-y-2 text-sm text-red-900">
                          {selectedPatient.redFlags.map((flag, idx) => (
                            <li key={idx} className="flex items-start gap-2">
                              <span className="font-bold">•</span>
                              <span>{flag}</span>
                            </li>
                          ))}
                        </ul>
                        <div className="mt-4 pt-4 border-t border-red-200">
                          <p className="text-sm font-semibold text-red-900">
                            💡 Saran: Lakukan sesi pre-op visit tambahan untuk memastikan pemahaman pasien.
                          </p>
                        </div>
                      </CardContent>
                    </Card>
                  </div>
                )}

                {/* Actions */}
                <div className="flex gap-3 pt-4 border-t">
                  <Button className="flex-1 bg-blue-600 hover:bg-blue-700">
                    <FileText className="w-4 h-4 mr-2" />
                    Download Report PDF
                  </Button>
                  <Button variant="outline" className="flex-1" onClick={() => setSelectedPatient(null)}>
                    Tutup
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </div>
  );
}
