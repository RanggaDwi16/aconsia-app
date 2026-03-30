import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Input } from "../../components/ui/input";
import { useNavigate } from "react-router";
import {
  Users,
  Clock,
  CheckCircle,
  AlertCircle,
  TrendingUp,
  Calendar,
  Search,
  Eye,
  FileText,
  MessageSquare,
  Activity,
} from "lucide-react";

interface Patient {
  id: string;
  fullName: string;
  mrn: string;
  surgeryType: string;
  surgeryDate: string;
  anesthesiaType: string | null;
  status: "pending" | "approved" | "in_progress" | "ready" | "completed";
  comprehensionScore: number;
  materialsCompleted: number;
  totalMaterials: number;
  lastActivity: string;
  scheduledConsentDate?: string;
}

export function EnhancedDoctorDashboard() {
  const navigate = useNavigate();
  const [patients, setPatients] = useState<Patient[]>([]);
  const [searchQuery, setSearchQuery] = useState("");
  const [filterStatus, setFilterStatus] = useState<string>("all");

  // Load patients from localStorage and sync
  useEffect(() => {
    const loadPatients = () => {
      let allPatients: Patient[] = [];

      // 1. Load demo patients from localStorage
      const demoPatients = JSON.parse(localStorage.getItem('demoPatients') || '[]');
      allPatients = demoPatients.map((p: any) => ({
        id: p.id,
        fullName: p.fullName,
        mrn: p.mrn,
        surgeryType: p.surgeryType || "Belum ditentukan",
        surgeryDate: p.surgeryDate || "Belum dijadwalkan",
        anesthesiaType: p.anesthesiaType || null,
        status: p.status || "pending",
        comprehensionScore: p.comprehensionScore || 0,
        materialsCompleted: p.materialsCompleted || 0,
        totalMaterials: p.totalMaterials || 0,
        lastActivity: p.lastActivity || "N/A",
        scheduledConsentDate: p.scheduledConsentDate,
      }));

      // 2. Sync with currentPatient from localStorage (new registrations)
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
            materialsCompleted: patientData.materialsCompleted || 0,
            totalMaterials: patientData.totalMaterials || 0,
            lastActivity: "Baru saja",
            scheduledConsentDate: patientData.scheduledConsentDate,
          });
        }
      }

      setPatients(allPatients);
    };

    loadPatients();

    // Sync every 2 seconds (simulate real-time)
    const interval = setInterval(loadPatients, 2000);
    return () => clearInterval(interval);
  }, []);

  // Filter patients
  const filteredPatients = patients.filter((patient) => {
    const matchesSearch =
      patient.fullName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      patient.mrn.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesFilter =
      filterStatus === "all" || patient.status === filterStatus;

    return matchesSearch && matchesFilter;
  });

  // Statistics
  const stats = {
    total: patients.length,
    pending: patients.filter((p) => p.status === "pending").length,
    inProgress: patients.filter((p) => p.status === "in_progress").length,
    ready: patients.filter((p) => p.status === "ready").length,
  };

  const getStatusBadge = (status: Patient["status"]) => {
    const variants: Record<Patient["status"], { variant: any; label: string; icon: any }> = {
      pending: { variant: "secondary", label: "Pending", icon: Clock },
      approved: { variant: "default", label: "Approved", icon: CheckCircle },
      in_progress: { variant: "default", label: "In Progress", icon: Activity },
      ready: { variant: "default", label: "Ready", icon: CheckCircle },
      completed: { variant: "default", label: "Completed", icon: CheckCircle },
    };

    const config = variants[status];
    const Icon = config.icon;

    return (
      <Badge
        variant={config.variant}
        className={
          status === "pending"
            ? "bg-yellow-100 text-yellow-800"
            : status === "ready"
            ? "bg-green-100 text-green-800"
            : status === "in_progress"
            ? "bg-blue-100 text-blue-800"
            : "bg-gray-100 text-gray-800"
        }
      >
        <Icon className="w-3 h-3 mr-1" />
        {config.label}
      </Badge>
    );
  };

  const getScoreBadge = (score: number) => {
    if (score >= 80) {
      return <Badge className="bg-green-100 text-green-800">✅ {score}%</Badge>;
    } else if (score >= 60) {
      return <Badge className="bg-yellow-100 text-yellow-800">⚠️ {score}%</Badge>;
    } else if (score > 0) {
      return <Badge className="bg-red-100 text-red-800">❌ {score}%</Badge>;
    } else {
      return <Badge variant="secondary">0%</Badge>;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50">
      {/* Header */}
      <div className="bg-white border-b shadow-sm">
        <div className="container mx-auto px-6 py-6">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">
                Dashboard Dokter
              </h1>
              <p className="text-gray-600 mt-1">
                Monitor pemahaman pasien secara real-time
              </p>
            </div>
            <div className="flex items-center gap-3">
              <Badge className="bg-blue-100 text-blue-800 text-sm px-4 py-2">
                <Activity className="w-4 h-4 mr-2" />
                Auto-sync setiap 2 detik
              </Badge>
            </div>
          </div>

          {/* Statistics Cards */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
            <Card className="border-blue-200 bg-blue-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">Total Pasien</p>
                    <p className="text-2xl font-bold text-blue-600">
                      {stats.total}
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
                    <p className="text-sm text-gray-600">Pending</p>
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
                    <p className="text-sm text-gray-600">In Progress</p>
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
                    <p className="text-sm text-gray-600">Ready</p>
                    <p className="text-2xl font-bold text-green-600">
                      {stats.ready}
                    </p>
                  </div>
                  <CheckCircle className="w-8 h-8 text-green-600" />
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-6 py-8">
        {/* Filters */}
        <Card className="mb-6">
          <CardContent className="p-6">
            <div className="flex flex-col md:flex-row gap-4">
              <div className="flex-1">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <Input
                    type="text"
                    placeholder="Cari nama atau MRN pasien..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="pl-10"
                  />
                </div>
              </div>
              <div className="flex gap-2">
                <Button
                  variant={filterStatus === "all" ? "default" : "outline"}
                  onClick={() => setFilterStatus("all")}
                  className={filterStatus === "all" ? "bg-blue-600" : ""}
                >
                  Semua
                </Button>
                <Button
                  variant={filterStatus === "pending" ? "default" : "outline"}
                  onClick={() => setFilterStatus("pending")}
                  className={filterStatus === "pending" ? "bg-yellow-600" : ""}
                >
                  Pending
                </Button>
                <Button
                  variant={filterStatus === "in_progress" ? "default" : "outline"}
                  onClick={() => setFilterStatus("in_progress")}
                  className={filterStatus === "in_progress" ? "bg-blue-600" : ""}
                >
                  In Progress
                </Button>
                <Button
                  variant={filterStatus === "ready" ? "default" : "outline"}
                  onClick={() => setFilterStatus("ready")}
                  className={filterStatus === "ready" ? "bg-green-600" : ""}
                >
                  Ready
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Patient List */}
        <div className="space-y-4">
          {filteredPatients.length === 0 ? (
            <Card>
              <CardContent className="p-12 text-center">
                <AlertCircle className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">Tidak ada pasien ditemukan</p>
              </CardContent>
            </Card>
          ) : (
            filteredPatients.map((patient) => (
              <Card
                key={patient.id}
                className="hover:shadow-lg transition-shadow"
              >
                <CardContent className="p-6">
                  <div className="flex items-start justify-between">
                    {/* Patient Info */}
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-2">
                        <h3 className="text-xl font-bold text-gray-900">
                          {patient.fullName}
                        </h3>
                        {getStatusBadge(patient.status)}
                      </div>

                      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-4">
                        <div>
                          <p className="text-xs text-gray-500">MRN</p>
                          <p className="text-sm font-semibold text-gray-900">
                            {patient.mrn}
                          </p>
                        </div>
                        <div>
                          <p className="text-xs text-gray-500">Jenis Operasi</p>
                          <p className="text-sm font-semibold text-gray-900">
                            {patient.surgeryType}
                          </p>
                        </div>
                        <div>
                          <p className="text-xs text-gray-500">Tanggal Operasi</p>
                          <p className="text-sm font-semibold text-gray-900 flex items-center gap-1">
                            <Calendar className="w-3 h-3" />
                            {new Date(patient.surgeryDate).toLocaleDateString("id-ID", {
                              day: "numeric",
                              month: "short",
                              year: "numeric",
                            })}
                          </p>
                        </div>
                        <div>
                          <p className="text-xs text-gray-500">Jenis Anestesi</p>
                          <p className="text-sm font-semibold text-blue-600">
                            {patient.anesthesiaType || (
                              <span className="text-gray-400 italic">
                                Belum dipilih
                              </span>
                            )}
                          </p>
                        </div>
                      </div>

                      {/* Progress */}
                      {patient.anesthesiaType && (
                        <div className="mt-4 space-y-3">
                          {/* Materials Progress */}
                          <div>
                            <div className="flex items-center justify-between mb-1">
                              <div className="flex items-center gap-2">
                                <FileText className="w-4 h-4 text-gray-600" />
                                <span className="text-sm text-gray-600">
                                  Progress Materi
                                </span>
                              </div>
                              <span className="text-sm font-semibold text-gray-900">
                                {patient.materialsCompleted}/{patient.totalMaterials}
                              </span>
                            </div>
                            <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                              <div
                                className="h-full bg-blue-600 rounded-full transition-all"
                                style={{
                                  width: `${
                                    (patient.materialsCompleted /
                                      patient.totalMaterials) *
                                    100
                                  }%`,
                                }}
                              />
                            </div>
                          </div>

                          {/* Comprehension Score */}
                          <div>
                            <div className="flex items-center justify-between mb-1">
                              <div className="flex items-center gap-2">
                                <TrendingUp className="w-4 h-4 text-gray-600" />
                                <span className="text-sm text-gray-600">
                                  Tingkat Pemahaman
                                </span>
                              </div>
                              {getScoreBadge(patient.comprehensionScore)}
                            </div>
                            <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                              <div
                                className={`h-full rounded-full transition-all ${
                                  patient.comprehensionScore >= 80
                                    ? "bg-green-600"
                                    : patient.comprehensionScore >= 60
                                    ? "bg-yellow-600"
                                    : patient.comprehensionScore > 0
                                    ? "bg-red-600"
                                    : "bg-gray-400"
                                }`}
                                style={{
                                  width: `${patient.comprehensionScore}%`,
                                }}
                              />
                            </div>
                          </div>

                          {/* Scheduled Consent */}
                          {patient.scheduledConsentDate && (
                            <div className="flex items-center gap-2 text-sm text-green-700 bg-green-50 p-2 rounded-lg">
                              <Calendar className="w-4 h-4" />
                              <span>
                                Jadwal TTD:{" "}
                                {new Date(
                                  patient.scheduledConsentDate
                                ).toLocaleString("id-ID", {
                                  day: "numeric",
                                  month: "long",
                                  year: "numeric",
                                  hour: "2-digit",
                                  minute: "2-digit",
                                })}
                              </span>
                            </div>
                          )}
                        </div>
                      )}

                      <div className="mt-3 flex items-center gap-2 text-xs text-gray-500">
                        <Clock className="w-3 h-3" />
                        <span>Aktivitas terakhir: {patient.lastActivity}</span>
                      </div>
                    </div>

                    {/* Actions */}
                    <div className="flex flex-col gap-2 ml-6">
                      {patient.status === "pending" ? (
                        <Button
                          onClick={() => navigate("/doctor/approval")}
                          className="bg-blue-600 hover:bg-blue-700"
                        >
                          <Eye className="w-4 h-4 mr-2" />
                          Review & ACC
                        </Button>
                      ) : (
                        <>
                          <Button
                            variant="outline"
                            onClick={() =>
                              navigate(`/doctor/patient/${patient.id}`)
                            }
                          >
                            <Eye className="w-4 h-4 mr-2" />
                            Detail
                          </Button>
                          <Button
                            variant="outline"
                            onClick={() =>
                              navigate(`/doctor/patient/${patient.id}/chat`)
                            }
                          >
                            <MessageSquare className="w-4 h-4 mr-2" />
                            Chat Log
                          </Button>
                        </>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </div>
      </div>
    </div>
  );
}