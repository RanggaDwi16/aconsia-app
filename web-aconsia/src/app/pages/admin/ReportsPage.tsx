import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { PatientReportCard } from "../../components/reports/PatientReportCard";
import {
  FileText,
  Download,
  Filter,
  TrendingUp,
  Users,
  Clock,
  CheckCircle,
  Activity,
  ArrowLeft,
} from "lucide-react";
import { getAdminDashboardPatients } from "../../../modules/admin/services/adminDashboardService";
import { userMessages } from "../../copy/userMessages";

interface PatientData {
  id: string;
  fullName: string;
  mrn: string;
  nik?: string;
  dateOfBirth?: string;
  age?: string;
  gender?: string;
  diagnosis?: string;
  surgeryType: string;
  surgeryDate: string;
  anesthesiaType: string | null;
  status: "pending" | "approved" | "in_progress" | "ready" | "completed";
  comprehensionScore: number;
  assignedDoctorId: string;
  materialsCompleted?: number;
  totalMaterials?: number;
  lastActivity?: string;
  scheduledConsentDate?: string;
  createdAt?: string;
}

export function ReportsPage() {
  const navigate = useNavigate();
  const [patients, setPatients] = useState<PatientData[]>([]);
  const [filterStatus, setFilterStatus] = useState<string>("all");
  const [filterAnesthesia, setFilterAnesthesia] = useState<string>("all");
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState("");

  useEffect(() => {
    const loadPatients = async () => {
      try {
        const firestorePatients = await getAdminDashboardPatients();
        const allPatients = firestorePatients.map((p) => ({
          id: p.id,
          fullName: p.fullName,
          mrn: p.mrn,
          nik: p.nik,
          dateOfBirth: p.dateOfBirth,
          age: p.age,
          gender: p.gender,
          diagnosis: p.diagnosis,
          surgeryType: p.surgeryType,
          surgeryDate: p.surgeryDate,
          anesthesiaType: p.anesthesiaType,
          status: p.status,
          comprehensionScore: p.comprehensionScore,
          assignedDoctorId: p.assignedDoctorId,
          materialsCompleted: p.materialsCompleted,
          totalMaterials: p.totalMaterials,
          lastActivity: p.lastActivity,
          scheduledConsentDate: p.scheduledConsentDate,
          createdAt: p.createdAt,
        }));

        setPatients(allPatients);
        setLoadError("");
        setIsLoading(false);
        return;
      } catch (error) {
        console.error("[ReportsPage] Firestore load failed", error);
        setLoadError(userMessages.admin.reportsLoadError);
        setIsLoading(false);
      }
    };

    void loadPatients();
    const interval = setInterval(() => {
      void loadPatients();
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  // Statistics
  const stats = {
    totalPatients: patients.length,
    pending: patients.filter((p) => p.status === "pending").length,
    inProgress: patients.filter((p) => p.status === "in_progress").length,
    ready: patients.filter((p) => p.status === "ready").length,
    completed: patients.filter((p) => p.status === "completed").length,
    avgComprehension:
      patients.length > 0
        ? Math.round(patients.reduce((sum, p) => sum + p.comprehensionScore, 0) / patients.length)
        : 0,
    highPerformers: patients.filter((p) => p.comprehensionScore >= 80).length,
    needsAttention: patients.filter((p) => p.comprehensionScore < 60 && p.status === "in_progress")
      .length,
  };

  // Filter patients
  const filteredPatients = patients.filter((p) => {
    if (filterStatus !== "all" && p.status !== filterStatus) return false;
    if (filterAnesthesia !== "all" && p.anesthesiaType !== filterAnesthesia) return false;
    return true;
  });

  // Generate report summary
  const generateReport = () => {
    const report = {
      generatedAt: new Date().toISOString(),
      summary: stats,
      patients: filteredPatients,
    };

    const blob = new Blob([JSON.stringify(report, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `patient-report-${new Date().toISOString().split("T")[0]}.json`;
    a.click();
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4" />
          <p className="text-slate-600">Memuat laporan...</p>
        </div>
      </div>
    );
  }

  if (loadError) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center p-6">
        <Card className="max-w-lg w-full border-red-200">
          <CardHeader>
            <CardTitle className="text-red-700">Gagal Memuat Laporan</CardTitle>
            <CardDescription>{loadError}</CardDescription>
          </CardHeader>
          <CardContent className="flex gap-3">
            <Button variant="outline" onClick={() => navigate("/admin")}>Kembali ke Dashboard</Button>
            <Button onClick={() => window.location.reload()}>Coba Lagi</Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Header */}
      <div className="bg-white border-b shadow-sm sticky top-0 z-10">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <Button variant="ghost" onClick={() => navigate("/admin")} className="gap-2">
                <ArrowLeft className="w-4 h-4" />
                Kembali
              </Button>
              <div>
                <h1 className="text-2xl font-bold text-slate-900">Laporan Pasien</h1>
                <p className="text-sm text-slate-600">
                  Data real-time dari {patients.length} pasien terdaftar
                </p>
              </div>
            </div>
            <Button onClick={generateReport} className="bg-green-600 hover:bg-green-700 gap-2">
              <Download className="w-4 h-4" />
              Export Laporan
            </Button>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-6 py-8">
        {/* Summary Statistics */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <Card className="border-blue-200 bg-blue-50">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-blue-700 font-semibold">Total Pasien</p>
                  <p className="text-3xl font-bold text-blue-600">{stats.totalPatients}</p>
                </div>
                <Users className="w-10 h-10 text-blue-600 opacity-50" />
              </div>
            </CardContent>
          </Card>

          <Card className="border-yellow-200 bg-yellow-50">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-yellow-700 font-semibold">Pending</p>
                  <p className="text-3xl font-bold text-yellow-600">{stats.pending}</p>
                </div>
                <Clock className="w-10 h-10 text-yellow-600 opacity-50" />
              </div>
            </CardContent>
          </Card>

          <Card className="border-blue-200 bg-blue-50">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-blue-700 font-semibold">Sedang Belajar</p>
                  <p className="text-3xl font-bold text-blue-600">{stats.inProgress}</p>
                </div>
                <Activity className="w-10 h-10 text-blue-600 opacity-50" />
              </div>
            </CardContent>
          </Card>

          <Card className="border-green-200 bg-green-50">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-green-700 font-semibold">Siap TTD</p>
                  <p className="text-3xl font-bold text-green-600">{stats.ready}</p>
                </div>
                <CheckCircle className="w-10 h-10 text-green-600 opacity-50" />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Performance Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <Card className="border-2 border-purple-200">
            <CardHeader className="pb-3">
              <CardTitle className="text-base font-bold flex items-center gap-2">
                <TrendingUp className="w-5 h-5 text-purple-600" />
                Rata-rata Pemahaman
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-4xl font-bold text-purple-600 mb-2">
                {stats.avgComprehension}%
              </div>
              <div className="h-2 bg-purple-100 rounded-full overflow-hidden">
                <div
                  className="h-full bg-purple-600 rounded-full"
                  style={{ width: `${stats.avgComprehension}%` }}
                />
              </div>
            </CardContent>
          </Card>

          <Card className="border-2 border-green-200">
            <CardHeader className="pb-3">
              <CardTitle className="text-base font-bold flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-600" />
                Pemahaman Baik
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-4xl font-bold text-green-600 mb-2">
                {stats.highPerformers}
              </div>
              <p className="text-sm text-slate-600">Skor ≥ 80% (siap untuk consent)</p>
            </CardContent>
          </Card>

          <Card className="border-2 border-red-200">
            <CardHeader className="pb-3">
              <CardTitle className="text-base font-bold flex items-center gap-2">
                <Activity className="w-5 h-5 text-red-600" />
                Perlu Perhatian
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-4xl font-bold text-red-600 mb-2">{stats.needsAttention}</div>
              <p className="text-sm text-slate-600">Skor &lt; 60% (butuh pendampingan)</p>
            </CardContent>
          </Card>
        </div>

        {/* Filters */}
        <Card className="mb-6">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Filter className="w-5 h-5" />
              Filter Laporan
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex flex-wrap gap-4">
              <div>
                <label className="block text-sm font-semibold text-slate-700 mb-2">Status</label>
                <select
                  value={filterStatus}
                  onChange={(e) => setFilterStatus(e.target.value)}
                  className="px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                >
                  <option value="all">Semua Status</option>
                  <option value="pending">Pending</option>
                  <option value="approved">Approved</option>
                  <option value="in_progress">In Progress</option>
                  <option value="ready">Ready</option>
                  <option value="completed">Completed</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-semibold text-slate-700 mb-2">
                  Jenis Anestesi
                </label>
                <select
                  value={filterAnesthesia}
                  onChange={(e) => setFilterAnesthesia(e.target.value)}
                  className="px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                >
                  <option value="all">Semua Jenis</option>
                  <option value="General Anesthesia">General Anesthesia</option>
                  <option value="Spinal Anesthesia">Spinal Anesthesia</option>
                  <option value="Epidural Anesthesia">Epidural Anesthesia</option>
                  <option value="Regional Anesthesia">Regional Anesthesia</option>
                  <option value="Local Anesthesia + Sedation">Local Anesthesia + Sedation</option>
                </select>
              </div>

              <div className="flex items-end">
                <Button
                  variant="outline"
                  onClick={() => {
                    setFilterStatus("all");
                    setFilterAnesthesia("all");
                  }}
                >
                  Reset Filter
                </Button>
              </div>
            </div>

            <div className="mt-4 text-sm text-slate-600">
              Menampilkan <span className="font-bold">{filteredPatients.length}</span> dari{" "}
              <span className="font-bold">{patients.length}</span> pasien
            </div>
          </CardContent>
        </Card>

        {/* Patient Reports Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredPatients.map((patient) => (
            <PatientReportCard key={patient.id} patient={patient} />
          ))}
        </div>

        {filteredPatients.length === 0 && (
          <Card className="border-2 border-dashed">
            <CardContent className="py-12 text-center">
              <FileText className="w-16 h-16 text-slate-300 mx-auto mb-4" />
              <p className="text-slate-600 font-semibold mb-2">Tidak ada data yang cocok</p>
              <p className="text-sm text-slate-500">Coba ubah filter untuk melihat data lain</p>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}
