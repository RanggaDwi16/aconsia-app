import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "../../components/ui/dialog";
import {
  Users,
  FileText,
  CheckCircle,
  Clock,
  TrendingUp,
  User,
  Calendar,
  Phone,
  Monitor,
  Activity,
  Stethoscope,
  AlertCircle,
} from "lucide-react";
import { getDesktopSession } from "../../../core/auth/session";
import {
  assignAnesthesiaToPatient,
  getDoctorScopedPatients,
} from "../../../modules/doctor/services/doctorDashboardService";
import { finishNavigationMetric } from "../../perf/navigationMetrics";
import { userMessages } from "../../copy/userMessages";

export function DoctorDashboardNew() {
  const navigate = useNavigate();
  const [doctorData, setDoctorData] = useState<any>(null);
  const [allPatients, setAllPatients] = useState<any[]>([]);
  const [pendingPatients, setPendingPatients] = useState<any[]>([]);
  const [approvedPatients, setApprovedPatients] = useState<any[]>([]);
  const [patientsNeedAnesthesia, setPatientsNeedAnesthesia] = useState<any[]>([]); // NEW
  const [selectedPatient, setSelectedPatient] = useState<any>(null); // For modal
  const [selectedAnesthesia, setSelectedAnesthesia] = useState<string>(""); // Selected type
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState("");

  const mapLoadErrorMessage = (error: unknown) => {
    const code =
      typeof error === "object" &&
      error !== null &&
      "code" in error &&
      typeof (error as { code?: unknown }).code === "string"
        ? String((error as { code?: string }).code)
        : "";

    if (code === "permission-denied") {
      return {
        code,
        message: userMessages.auth.accessDenied,
      };
    }

    if (code === "auth/not-authenticated" || code === "unauthenticated") {
      return {
        code,
        message: userMessages.doctorDashboard.notAuthenticated,
      };
    }

    if (code === "auth/session-mismatch") {
      return {
        code,
        message: userMessages.doctorDashboard.sessionMismatch,
      };
    }

    return {
      code: code || "unknown",
      message: userMessages.doctorDashboard.loadError,
    };
  };

  useEffect(() => {
    finishNavigationMetric("login_to_doctor_dashboard", { route: "/doctor" });
    void loadData();
    const interval = setInterval(() => {
      void loadData();
    }, 5000); // Auto-refresh every 5 seconds
    return () => clearInterval(interval);
  }, []);

  const loadData = async () => {
    const session = getDesktopSession();
    if (!session?.uid) {
      navigate("/login");
      return;
    }

    setDoctorData({
      id: session.uid,
      name: session.displayName || "Dokter",
      email: session.email,
    });

    try {
      const firestorePatients = await getDoctorScopedPatients(session.uid);
      setAllPatients(firestorePatients);

      setPendingPatients(
        firestorePatients.filter((p: any) => p.status === "pending"),
      );
      setApprovedPatients(
        firestorePatients.filter(
          (p: any) =>
            p.status === "approved" ||
            p.status === "in_progress" ||
            p.status === "ready",
        ),
      );
      setPatientsNeedAnesthesia(
        firestorePatients.filter(
          (p: any) => p.status === "approved" && !p.anesthesiaType,
        ),
      );
      setLoadError("");
      setIsLoading(false);
      return;
    } catch (error) {
      const parsedError = mapLoadErrorMessage(error);
      console.error("[DoctorDashboard] Firestore load failed", {
        error,
        code: parsedError.code,
        sessionUid: session.uid,
      });
      setAllPatients([]);
      setPendingPatients([]);
      setApprovedPatients([]);
      setPatientsNeedAnesthesia([]);
      setLoadError(parsedError.message);
      setIsLoading(false);
    }
  };

  const handleReviewPatient = (patientId: string) => {
    navigate(`/doctor/approval?patientId=${patientId}`);
  };

  // NEW: Handle assign anesthesia
  const handleAssignAnesthesia = (patient: any) => {
    setSelectedPatient(patient);
    setSelectedAnesthesia(""); // Reset selection
  };

  const handleSaveAnesthesia = async () => {
    if (!selectedAnesthesia || !selectedPatient) {
      alert("Mohon pilih jenis anestesi terlebih dahulu!");
      return;
    }

    try {
      await assignAnesthesiaToPatient({
        pasienId: selectedPatient.id,
        anesthesiaType: selectedAnesthesia,
      });

      alert(
        `✅ Berhasil assign ${selectedAnesthesia} untuk ${selectedPatient.fullName}!`,
      );
      setSelectedPatient(null);
      setSelectedAnesthesia("");
      void loadData();
      return;
    } catch (error) {
      console.error("[DoctorDashboard] Assign anesthesia failed", error);
      alert(userMessages.doctorDashboard.assignAnesthesiaError);
      return;
    }
  };

  const totalPatients = allPatients.length;
  const completionRate =
    approvedPatients.length > 0
      ? Math.round(
          (approvedPatients.filter((p) => p.comprehensionScore >= 80).length /
            approvedPatients.length) *
            100
        )
      : 0;

  const anesthesiaTypes = [
    "General Anesthesia",
    "Spinal Anesthesia",
    "Epidural Anesthesia",
    "Regional Anesthesia",
    "Local Anesthesia + Sedation",
  ];

  return (
    <DoctorLayout>
      <div className="p-8">
        {isLoading && (
          <Card className="mb-6">
            <CardContent className="p-6 text-center text-gray-600">
              Memuat dashboard dokter...
            </CardContent>
          </Card>
        )}

        {!isLoading && loadError && (
          <Card className="mb-6 border-red-200">
            <CardContent className="p-6 text-center">
              <AlertCircle className="w-10 h-10 text-red-600 mx-auto mb-3" />
              <p className="text-red-700 font-medium mb-3">{loadError}</p>
              <Button variant="outline" onClick={() => void loadData()}>
                Coba Lagi
              </Button>
            </CardContent>
          </Card>
        )}

        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Dashboard Dokter Anestesi
          </h1>
          <p className="text-gray-600">
            Selamat datang, {doctorData?.name || "Dokter"}
          </p>
        </div>

        {/* Quick Access - NEW */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <Card className="border-2 border-blue-300 bg-gradient-to-br from-blue-50 to-cyan-50 hover:shadow-lg transition-all cursor-pointer" onClick={() => navigate("/doctor/monitoring")}>
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="w-16 h-16 bg-blue-600 rounded-lg flex items-center justify-center">
                  <Monitor className="w-8 h-8 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-lg font-bold text-gray-900 mb-1">Real-Time Monitoring</h3>
                  <p className="text-sm text-gray-600">Pantau progress edukasi pasien secara real-time</p>
                </div>
                <div className="text-blue-600">
                  <Activity className="w-6 h-6" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-2 border-purple-300 bg-gradient-to-br from-purple-50 to-pink-50 hover:shadow-lg transition-all cursor-pointer" onClick={() => navigate("/doctor/approval")}>
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="w-16 h-16 bg-purple-600 rounded-lg flex items-center justify-center">
                  <FileText className="w-8 h-8 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-lg font-bold text-gray-900 mb-1">Review Pasien Baru</h3>
                  <p className="text-sm text-gray-600">Approve & tentukan jenis anestesi</p>
                </div>
                {pendingPatients.length > 0 && (
                  <Badge className="bg-orange-600 text-white text-lg px-3 py-1">
                    {pendingPatients.length}
                  </Badge>
                )}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600 mb-1">Total Pasien</p>
                  <p className="text-3xl font-bold text-gray-900">{totalPatients}</p>
                </div>
                <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                  <Users className="w-6 h-6 text-blue-600" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600 mb-1">Menunggu Review</p>
                  <p className="text-3xl font-bold text-orange-600">
                    {pendingPatients.length}
                  </p>
                </div>
                <div className="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center">
                  <Clock className="w-6 h-6 text-orange-600" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600 mb-1">Sudah Disetujui</p>
                  <p className="text-3xl font-bold text-green-600">
                    {approvedPatients.length}
                  </p>
                </div>
                <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                  <CheckCircle className="w-6 h-6 text-green-600" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600 mb-1">Tingkat Pemahaman</p>
                  <p className="text-3xl font-bold text-cyan-600">{completionRate}%</p>
                </div>
                <div className="w-12 h-12 bg-cyan-100 rounded-lg flex items-center justify-center">
                  <TrendingUp className="w-6 h-6 text-cyan-600" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Pending Patients - PRIORITY */}
        {pendingPatients.length > 0 && (
          <Card className="mb-6 border-orange-200 bg-orange-50">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-orange-900">
                <Clock className="w-5 h-5" />
                Pasien Menunggu Review ({pendingPatients.length})
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {pendingPatients.map((patient) => (
                  <div
                    key={patient.id}
                    className="bg-white rounded-lg p-4 border border-orange-200"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-orange-100 rounded-full flex items-center justify-center">
                          <User className="w-6 h-6 text-orange-600" />
                        </div>
                        <div>
                          <h4 className="font-semibold text-gray-900">
                            {patient.fullName}
                          </h4>
                          <div className="flex items-center gap-4 text-sm text-gray-600 mt-1">
                            <span>No. RM: {patient.mrn}</span>
                            <span>•</span>
                            <span>NIK: {patient.nik}</span>
                            <span>•</span>
                            <span className="flex items-center gap-1">
                              <Phone className="w-3 h-3" />
                              {patient.phone}
                            </span>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <Badge className="bg-orange-100 text-orange-800">
                          Menunggu Review
                        </Badge>
                        <Button
                          onClick={() => handleReviewPatient(patient.id)}
                          className="bg-orange-600 hover:bg-orange-700"
                        >
                          Review Sekarang
                        </Button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}

        {/* Approved Patients */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <CheckCircle className="w-5 h-5 text-green-600" />
              Pasien yang Sudah Disetujui ({approvedPatients.length})
            </CardTitle>
          </CardHeader>
          <CardContent>
            {approvedPatients.length === 0 ? (
              <div className="text-center py-8 text-gray-500">
                Belum ada pasien yang disetujui
              </div>
            ) : (
              <div className="space-y-3">
                {approvedPatients.map((patient) => (
                  <div
                    key={patient.id}
                    className="bg-gray-50 rounded-lg p-4 border border-gray-200"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4 flex-1">
                        <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                          <User className="w-6 h-6 text-green-600" />
                        </div>
                        <div className="flex-1">
                          <h4 className="font-semibold text-gray-900">
                            {patient.fullName}
                          </h4>
                          <div className="flex items-center gap-4 text-sm text-gray-600 mt-1">
                            <span>No. RM: {patient.mrn}</span>
                            <span>•</span>
                            <span>{patient.diagnosis || "-"}</span>
                            <span>•</span>
                            <span className="flex items-center gap-1">
                              <Calendar className="w-3 h-3" />
                              {patient.surgeryDate
                                ? new Date(patient.surgeryDate).toLocaleDateString("id-ID")
                                : "-"}
                            </span>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <div className="text-right">
                          <p className="text-xs text-gray-500">Pemahaman</p>
                          <p className="text-lg font-bold text-blue-600">
                            {patient.comprehensionScore || 0}%
                          </p>
                        </div>
                        <Badge
                          className={
                            patient.comprehensionScore >= 80
                              ? "bg-green-100 text-green-800"
                              : "bg-blue-100 text-blue-800"
                          }
                        >
                          {patient.comprehensionScore >= 80 ? "Siap TTD" : "Belajar"}
                        </Badge>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Patients Need Anesthesia */}
        {patientsNeedAnesthesia.length > 0 && (
          <Card className="mb-6 border-blue-200 bg-blue-50">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-blue-900">
                <AlertCircle className="w-5 h-5" />
                Pasien yang Membutuhkan Anestesi ({patientsNeedAnesthesia.length})
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {patientsNeedAnesthesia.map((patient) => (
                  <div
                    key={patient.id}
                    className="bg-white rounded-lg p-4 border border-blue-200"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4">
                        <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                          <User className="w-6 h-6 text-blue-600" />
                        </div>
                        <div>
                          <h4 className="font-semibold text-gray-900">
                            {patient.fullName}
                          </h4>
                          <div className="flex items-center gap-4 text-sm text-gray-600 mt-1">
                            <span>No. RM: {patient.mrn}</span>
                            <span>•</span>
                            <span>NIK: {patient.nik}</span>
                            <span>•</span>
                            <span className="flex items-center gap-1">
                              <Phone className="w-3 h-3" />
                              {patient.phone}
                            </span>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <Badge className="bg-blue-100 text-blue-800">
                          Membutuhkan Anestesi
                        </Badge>
                        <Button
                          onClick={() => handleAssignAnesthesia(patient)}
                          className="bg-blue-600 hover:bg-blue-700"
                        >
                          Assign Anestesi
                        </Button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}

        {/* Modal Assign Anesthesia */}
        <Dialog open={selectedPatient !== null} onOpenChange={(open) => !open && setSelectedPatient(null)}>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle className="text-xl font-bold text-gray-900">
                Assign Jenis Anestesi untuk {selectedPatient?.fullName}
              </DialogTitle>
              <DialogDescription className="text-sm text-gray-500">
                Pilih jenis anestesi yang sesuai dengan kondisi pasien.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              {anesthesiaTypes.map((type) => (
                <div key={type} className="flex items-center gap-4">
                  <input
                    type="radio"
                    name="anesthesiaType"
                    value={type}
                    checked={selectedAnesthesia === type}
                    onChange={(e) => setSelectedAnesthesia(e.target.value)}
                    className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500"
                  />
                  <label className="text-sm text-gray-900">{type}</label>
                </div>
              ))}
            </div>
            <DialogFooter>
              <Button
                onClick={handleSaveAnesthesia}
                className="bg-blue-600 hover:bg-blue-700"
              >
                Simpan
              </Button>
              <Button
                onClick={() => setSelectedPatient(null)}
                variant="outline"
              >
                Batal
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
    </DoctorLayout>
  );
}
