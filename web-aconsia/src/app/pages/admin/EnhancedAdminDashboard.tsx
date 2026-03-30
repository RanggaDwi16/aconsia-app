import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import {
  Users,
  Stethoscope,
  TrendingUp,
  FileCheck,
  Activity,
  Clock,
  CheckCircle,
  AlertCircle,
  FileText,
  LogOut,
} from "lucide-react";
import { getAdminDashboardPatients } from "../../../modules/admin/services/adminDashboardService";
import { getDesktopSession } from "../../../core/auth/session";
import { signOutDesktop } from "../../../core/auth/service";
import { writeAuditLog } from "../../../modules/admin/services/auditWriterService";

interface PatientData {
  id: string;
  fullName: string;
  mrn: string;
  surgeryType: string;
  surgeryDate: string;
  anesthesiaType: string | null;
  status: "pending" | "approved" | "in_progress" | "ready" | "completed";
  comprehensionScore: number;
  assignedDoctorId: string;
  scheduledConsentDate?: string;
}

interface DoctorData {
  id: string;
  fullName: string;
  patientsCount: number;
  avgComprehension: number;
}

export function EnhancedAdminDashboard() {
  const navigate = useNavigate();
  const [patients, setPatients] = useState<PatientData[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [adminName, setAdminName] = useState("Admin");

  // Resolve current admin session
  useEffect(() => {
    const session = getDesktopSession();
    if (!session || session.role !== "admin") {
      navigate("/login");
      return;
    }

    setAdminName(session.displayName || session.email || "Admin");
  }, [navigate]);

  // Load patients from Firestore first, fallback to localStorage
  useEffect(() => {
    const loadData = async () => {
      let allPatients: PatientData[] = [];

      try {
        allPatients = await getAdminDashboardPatients();
        setPatients(allPatients);
        setIsLoading(false);
        return;
      } catch (error) {
        console.warn("[AdminDashboard] Firestore load failed, fallback mode", error);
      }

      // Fallback local storage mode
      const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
      allPatients = demoPatients.map((p: any) => ({
        id: p.id,
        fullName: p.fullName,
        mrn: p.mrn,
        surgeryType: p.surgeryType || "Belum ditentukan",
        surgeryDate: p.surgeryDate || "Belum dijadwalkan",
        anesthesiaType: p.anesthesiaType || null,
        status: p.status || "pending",
        comprehensionScore: p.comprehensionScore || 0,
        assignedDoctorId: p.assignedDoctorId || "doctor-001",
        scheduledConsentDate: p.scheduledConsentDate,
      }));

      // 2. Sync with current patient from localStorage (new registrations)
      const currentPatient = localStorage.getItem("currentPatient");
      if (currentPatient) {
        const patientData = JSON.parse(currentPatient);
        const index = allPatients.findIndex((p) => p.id === patientData.id);
        if (index !== -1) {
          // Update existing patient
          allPatients[index] = {
            ...allPatients[index],
            anesthesiaType: patientData.anesthesiaType || allPatients[index].anesthesiaType,
            status: patientData.status || allPatients[index].status,
            comprehensionScore: patientData.comprehensionScore || 0,
            scheduledConsentDate: patientData.scheduledConsentDate,
          };
        } else {
          // Add new patient (from registration)
          allPatients.unshift({
            id: patientData.id,
            fullName: patientData.fullName || patientData.name || "Pasien Baru",
            mrn: patientData.mrn || "N/A",
            surgeryType: patientData.surgeryType || "Belum ditentukan",
            surgeryDate: patientData.surgeryDate || "Belum dijadwalkan",
            anesthesiaType: patientData.anesthesiaType || null,
            status: patientData.status || "pending",
            comprehensionScore: patientData.comprehensionScore || 0,
            assignedDoctorId: patientData.assignedDoctorId || "doctor-001",
            scheduledConsentDate: patientData.scheduledConsentDate,
          });
        }
      }

      setPatients(allPatients);
      setIsLoading(false);
    };

    void loadData();

    // Auto-sync every 5 seconds
    const interval = setInterval(() => {
      void loadData();
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  const handleLogout = async () => {
    const session = getDesktopSession();
    if (session) {
      await writeAuditLog({
        actorUid: session.uid,
        actorRole: "admin",
        actorName: session.displayName || session.email,
        actionType: "LOGOUT",
        entityType: "auth",
        message: "Admin signed out from desktop portal",
      });
    }

    await signOutDesktop();
    navigate("/login");
  };

  // Calculate statistics
  const stats = {
    totalPatients: patients.length,
    pending: patients.filter((p) => p.status === "pending").length,
    inProgress: patients.filter((p) => p.status === "in_progress").length,
    ready: patients.filter((p) => p.status === "ready").length,
    completed: patients.filter((p) => p.status === "completed").length,
    avgComprehension: Math.round(
      patients.reduce((sum, p) => sum + p.comprehensionScore, 0) / patients.length || 0
    ),
  };

  // Anesthesia type distribution
  const anesthesiaDistribution = {
    general: patients.filter((p) => p.anesthesiaType === "General Anesthesia").length,
    spinal: patients.filter((p) => p.anesthesiaType === "Spinal Anesthesia").length,
    epidural: patients.filter((p) => p.anesthesiaType === "Epidural Anesthesia").length,
    regional: patients.filter((p) => p.anesthesiaType === "Regional Anesthesia").length,
    local: patients.filter((p) => p.anesthesiaType === "Local Anesthesia + Sedation").length,
  };

  // Doctor performance (mock)
  const doctors: DoctorData[] = [
    {
      id: "doctor-001",
      fullName: "Dr. Ahmad Suryadi, Sp.An",
      patientsCount: patients.filter((p) => p.assignedDoctorId === "doctor-001").length,
      avgComprehension: Math.round(
        patients
          .filter((p) => p.assignedDoctorId === "doctor-001")
          .reduce((sum, p) => sum + p.comprehensionScore, 0) /
          patients.filter((p) => p.assignedDoctorId === "doctor-001").length || 0
      ),
    },
    {
      id: "doctor-002",
      fullName: "Dr. Siti Rahmawati, Sp.An",
      patientsCount: patients.filter((p) => p.assignedDoctorId === "doctor-002").length,
      avgComprehension: Math.round(
        patients
          .filter((p) => p.assignedDoctorId === "doctor-002")
          .reduce((sum, p) => sum + p.comprehensionScore, 0) /
          patients.filter((p) => p.assignedDoctorId === "doctor-002").length || 0
      ),
    },
  ];

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-purple-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Memuat data...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-50">
      {/* Auto-sync indicator */}
      <div className="bg-purple-600 text-white text-xs py-1 text-center">
        <Activity className="w-3 h-3 inline mr-1 animate-pulse" />
        Dashboard ter-sinkronisasi dengan semua pasien & dokter secara real-time
      </div>

      {/* Header */}
      <div className="bg-white border-b shadow-sm">
        <div className="container mx-auto px-6 py-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">
                Dashboard Administrator
              </h1>
              <p className="text-gray-600 mt-1">
                Sistem Edukasi Informed Consent Anestesi · {adminName}
              </p>
            </div>
            <div className="flex items-center gap-3">
              <Badge className="bg-purple-100 text-purple-800 text-sm px-4 py-2">
                <Activity className="w-4 h-4 mr-2" />
                Auto-sync setiap 2 detik
              </Badge>
              <Button
                variant="outline"
                onClick={() => navigate('/admin/audit-trail')}
                className="border-purple-300 text-purple-600 hover:bg-purple-50"
              >
                <FileText className="w-4 h-4 mr-2" />
                Audit Trail
              </Button>
              <Button
                variant="outline"
                onClick={() => navigate('/admin/reports')}
                className="border-blue-300 text-blue-600 hover:bg-blue-50"
              >
                <FileText className="w-4 h-4 mr-2" />
                Lihat Laporan
              </Button>
              <Button
                variant="outline"
                onClick={handleLogout}
                className="border-red-300 text-red-600 hover:bg-red-50"
              >
                <LogOut className="w-4 h-4 mr-2" />
                Logout
              </Button>
            </div>
          </div>

          {/* Statistics Cards */}
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mt-6">
            <Card className="border-blue-200 bg-blue-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Total Pasien</p>
                    <p className="text-2xl font-bold text-blue-600">
                      {stats.totalPatients}
                    </p>
                  </div>
                  <Users className="w-8 h-8 text-blue-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-yellow-200 bg-yellow-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Pending</p>
                    <p className="text-2xl font-bold text-yellow-600">
                      {stats.pending}
                    </p>
                  </div>
                  <Clock className="w-8 h-8 text-yellow-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-blue-200 bg-blue-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">In Progress</p>
                    <p className="text-2xl font-bold text-blue-600">
                      {stats.inProgress}
                    </p>
                  </div>
                  <Activity className="w-8 h-8 text-blue-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-green-200 bg-green-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Ready</p>
                    <p className="text-2xl font-bold text-green-600">
                      {stats.ready}
                    </p>
                  </div>
                  <CheckCircle className="w-8 h-8 text-green-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-gray-200 bg-gray-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Completed</p>
                    <p className="text-2xl font-bold text-gray-600">
                      {stats.completed}
                    </p>
                  </div>
                  <FileCheck className="w-8 h-8 text-gray-600" />
                </div>
              </CardContent>
            </Card>

            <Card className="border-purple-200 bg-purple-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs text-gray-600">Avg Score</p>
                    <p className="text-2xl font-bold text-purple-600">
                      {stats.avgComprehension}%
                    </p>
                  </div>
                  <TrendingUp className="w-8 h-8 text-purple-600" />
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-6 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Doctor Performance */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Stethoscope className="w-5 h-5" />
                Performa Dokter
              </CardTitle>
              <CardDescription>Berdasarkan rata-rata pemahaman pasien</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {doctors.map((doctor) => (
                <div key={doctor.id} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium text-sm">{doctor.fullName}</p>
                      <p className="text-xs text-gray-500">
                        {doctor.patientsCount} pasien
                      </p>
                    </div>
                    <Badge
                      className={
                        doctor.avgComprehension >= 80
                          ? "bg-green-100 text-green-800"
                          : doctor.avgComprehension >= 60
                          ? "bg-yellow-100 text-yellow-800"
                          : "bg-red-100 text-red-800"
                      }
                    >
                      {doctor.avgComprehension}%
                    </Badge>
                  </div>
                  <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all ${
                        doctor.avgComprehension >= 80
                          ? "bg-green-600"
                          : doctor.avgComprehension >= 60
                          ? "bg-yellow-600"
                          : "bg-red-600"
                      }`}
                      style={{ width: `${doctor.avgComprehension}%` }}
                    />
                  </div>
                </div>
              ))}
            </CardContent>
          </Card>

          {/* Anesthesia Distribution */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <FileText className="w-5 h-5" />
                Distribusi Jenis Anestesi
              </CardTitle>
              <CardDescription>Total {stats.totalPatients} pasien</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {[
                { label: "General Anesthesia", count: anesthesiaDistribution.general, color: "blue" },
                { label: "Spinal Anesthesia", count: anesthesiaDistribution.spinal, color: "green" },
                { label: "Epidural Anesthesia", count: anesthesiaDistribution.epidural, color: "purple" },
                { label: "Regional Anesthesia", count: anesthesiaDistribution.regional, color: "orange" },
                { label: "Local + Sedation", count: anesthesiaDistribution.local, color: "pink" },
              ].map((item) => {
                const percentage = stats.totalPatients > 0
                  ? Math.round((item.count / stats.totalPatients) * 100)
                  : 0;

                return (
                  <div key={item.label} className="space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium">{item.label}</span>
                      <span className="text-sm text-gray-600">
                        {item.count} ({percentage}%)
                      </span>
                    </div>
                    <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                      <div
                        className={`h-full bg-${item.color}-600 rounded-full transition-all`}
                        style={{ width: `${percentage}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </CardContent>
          </Card>

          {/* Recent Patients */}
          <Card className="lg:col-span-2">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Users className="w-5 h-5" />
                Status Pasien Real-Time
              </CardTitle>
              <CardDescription>Update otomatis setiap 2 detik</CardDescription>
            </CardHeader>
            <CardContent>
              {patients.length === 0 ? (
                <div className="text-center py-12">
                  <AlertCircle className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                  <p className="text-gray-600">Tidak ada pasien terdaftar</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {patients.map((patient) => (
                    <div
                      key={patient.id}
                      className="p-4 border rounded-lg hover:shadow-md transition-shadow"
                    >
                      <div className="flex items-start justify-between">
                        <div className="flex-1">
                          <div className="flex items-center gap-3 mb-2">
                            <h4 className="font-bold text-gray-900">
                              {patient.fullName}
                            </h4>
                            <Badge
                              variant="secondary"
                              className={
                                patient.status === "pending"
                                  ? "bg-yellow-100 text-yellow-800"
                                  : patient.status === "ready"
                                  ? "bg-green-100 text-green-800"
                                  : patient.status === "in_progress"
                                  ? "bg-blue-100 text-blue-800"
                                  : "bg-gray-100 text-gray-800"
                              }
                            >
                              {patient.status === "pending"
                                ? "Pending"
                                : patient.status === "ready"
                                ? "Ready"
                                : patient.status === "in_progress"
                                ? "In Progress"
                                : patient.status === "approved"
                                ? "Approved"
                                : "Completed"}
                            </Badge>
                          </div>

                          <div className="grid grid-cols-4 gap-4 text-sm">
                            <div>
                              <p className="text-xs text-gray-500">MRN</p>
                              <p className="font-semibold">{patient.mrn}</p>
                            </div>
                            <div>
                              <p className="text-xs text-gray-500">Operasi</p>
                              <p className="font-semibold">{patient.surgeryType}</p>
                            </div>
                            <div>
                              <p className="text-xs text-gray-500">Anestesi</p>
                              <p className="font-semibold text-blue-600">
                                {patient.anesthesiaType || (
                                  <span className="text-gray-400 italic">Belum dipilih</span>
                                )}
                              </p>
                            </div>
                            <div>
                              <p className="text-xs text-gray-500">Pemahaman</p>
                              <Badge
                                className={
                                  patient.comprehensionScore >= 80
                                    ? "bg-green-100 text-green-800"
                                    : patient.comprehensionScore >= 60
                                    ? "bg-yellow-100 text-yellow-800"
                                    : patient.comprehensionScore > 0
                                    ? "bg-red-100 text-red-800"
                                    : "bg-gray-100 text-gray-800"
                                }
                              >
                                {patient.comprehensionScore}%
                              </Badge>
                            </div>
                          </div>

                          {patient.scheduledConsentDate && (
                            <div className="mt-2 text-xs text-green-700 bg-green-50 p-2 rounded">
                              📅 Jadwal TTD:{" "}
                              {new Date(patient.scheduledConsentDate).toLocaleString("id-ID", {
                                day: "numeric",
                                month: "long",
                                year: "numeric",
                                hour: "2-digit",
                                minute: "2-digit",
                              })}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}