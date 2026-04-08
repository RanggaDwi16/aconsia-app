import { useEffect, useMemo, useState } from "react";
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
  Bell,
  AlertCircle,
} from "lucide-react";
import { useNavigate } from "react-router";
import { getDesktopSession } from "../../../core/auth/session";
import {
  getDoctorMonitoringPatients,
  type MonitoringPatient,
} from "../../../modules/doctor/services/doctorMonitoringService";
import { userMessages } from "../../copy/userMessages";

export function DoctorMonitoring() {
  const navigate = useNavigate();
  const session = getDesktopSession();
  const [patients, setPatients] = useState<MonitoringPatient[]>([]);
  const [selectedPatient, setSelectedPatient] = useState<MonitoringPatient | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState("");

  const loadData = async () => {
    if (!session?.uid) {
      setError("Sesi dokter tidak ditemukan. Silakan login ulang.");
      setIsLoading(false);
      return;
    }

    try {
      const data = await getDoctorMonitoringPatients(session.uid);
      setPatients(data);
      setError("");
    } catch (loadErr) {
      console.error("[DoctorMonitoring] failed to load Firestore data", loadErr);
      setError(userMessages.doctorMonitoring.loadError);
      setPatients([]);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    void loadData();
    const interval = setInterval(() => {
      void loadData();
    }, 10000);
    return () => clearInterval(interval);
  }, [session?.uid]);

  const summary = useMemo(
    () => ({
      total: patients.length,
      completed: patients.filter((p) => p.status === "completed").length,
      inProgress: patients.filter((p) => p.status === "in-progress").length,
      attention: patients.filter((p) => p.redFlags.length > 0).length,
    }),
    [patients],
  );

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
        <div className="flex items-center gap-4 mb-6">
          <Button variant="ghost" size="sm" onClick={() => navigate("/doctor")}>
            <ArrowLeft className="w-4 h-4 mr-2" />
            Kembali
          </Button>
          <div className="flex-1">
            <h1 className="text-2xl font-bold text-gray-900">Monitoring Progres Pasien</h1>
            <p className="text-sm text-gray-600">{userMessages.doctorMonitoring.subtitle}</p>
          </div>
          <Badge variant="secondary" className="bg-blue-600 text-white">
            <Bell className="w-4 h-4 mr-1" />
            {summary.attention} Notifikasi
          </Badge>
        </div>

        {isLoading && (
          <Card>
            <CardContent className="p-6 text-center text-gray-600">Memuat data monitoring...</CardContent>
          </Card>
        )}

        {!isLoading && error && (
          <Card className="border-red-200 mb-6">
            <CardContent className="p-6 text-center text-red-700">
              <AlertCircle className="w-8 h-8 mx-auto mb-2" />
              {error}
            </CardContent>
          </Card>
        )}

        {!isLoading && !error && (
          <>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
              <Card className="border-blue-200">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-xs text-gray-600">Total Pasien</p>
                      <p className="text-2xl font-bold text-gray-900">{summary.total}</p>
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
                      <p className="text-2xl font-bold text-green-600">{summary.completed}</p>
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
                      <p className="text-2xl font-bold text-yellow-600">{summary.inProgress}</p>
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
                      <p className="text-2xl font-bold text-red-600">{summary.attention}</p>
                    </div>
                    <AlertTriangle className="w-8 h-8 text-red-600" />
                  </div>
                </CardContent>
              </Card>
            </div>

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
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </>
        )}

        {selectedPatient && (
          <div
            className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50"
            onClick={() => setSelectedPatient(null)}
          >
            <Card
              className="max-w-4xl w-full max-h-[90vh] overflow-y-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <CardHeader className="border-b sticky top-0 bg-white z-10">
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-xl">{selectedPatient.name}</CardTitle>
                    <p className="text-sm text-gray-600">
                      {selectedPatient.noRM} • {selectedPatient.anesthesiaType}
                    </p>
                  </div>
                  <Button variant="ghost" size="sm" onClick={() => setSelectedPatient(null)}>
                    ✕
                  </Button>
                </div>
              </CardHeader>

              <CardContent className="p-6 space-y-6">
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
                      <p className="text-xs text-gray-600 mb-1">Comprehension</p>
                      <p className="text-3xl font-bold text-purple-600">{selectedPatient.comprehensionScore}%</p>
                    </CardContent>
                  </Card>
                </div>

                <div>
                  <h3 className="font-bold text-gray-900 mb-3 flex items-center gap-2">
                    <CheckCircle className="w-5 h-5 text-green-600" />
                    Quiz Scores (per Section)
                  </h3>
                  {selectedPatient.quizScores.length === 0 ? (
                    <p className="text-sm text-gray-500">Belum ada data quiz.</p>
                  ) : (
                    <div className="space-y-2">
                      {selectedPatient.quizScores.map((quiz, idx) => (
                        <div key={idx} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                          <span className="text-sm font-medium text-gray-700 flex-1">{quiz.section}</span>
                          <div className="flex items-center gap-2">
                            <span className={`text-sm font-bold ${quiz.score >= 80 ? "text-green-600" : "text-orange-600"}`}>
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
                  )}
                </div>

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
                          <strong>Topik:</strong>{" "}
                          {selectedPatient.aiChatStats.topicsAsked.length > 0
                            ? selectedPatient.aiChatStats.topicsAsked.join(", ")
                            : "-"}
                        </p>
                      </CardContent>
                    </Card>
                  </div>
                )}

                {selectedPatient.redFlags.length > 0 && (
                  <div>
                    <h3 className="font-bold text-gray-900 mb-3 flex items-center gap-2">
                      <AlertTriangle className="w-5 h-5 text-red-600" />
                      Catatan Perhatian
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
                      </CardContent>
                    </Card>
                  </div>
                )}

                <div className="flex gap-3 pt-4 border-t">
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
