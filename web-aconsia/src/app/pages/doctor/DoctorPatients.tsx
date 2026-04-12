import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Input } from "../../components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../../components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "../../components/ui/table";
import { Badge } from "../../components/ui/badge";
import { Progress } from "../../components/ui/progress";
import { Button } from "../../components/ui/button";
import { Search, MessageCircle, TrendingUp, AlertCircle } from "lucide-react";
import { getDesktopSession } from "../../../core/auth/session";
import { userMessages } from "../../copy/userMessages";
import {
  getDoctorScopedPatients,
  type DoctorDashboardPatient,
} from "../../../modules/doctor/services/doctorDashboardService";

type DoctorPatient = {
  id: string;
  uid: string;
  name: string;
  mrn: string;
  surgery: string;
  anesthesia: string;
  comprehension: number;
  status: string;
  scheduledConsentDateText: string;
  scheduledConsentDateRaw: string;
  scheduledConsentTimeRaw: string;
  educationProgress: number;
};

function normalizeStatus(status: string): string {
  const s = status.toLowerCase().trim();
  if (!s) return "Pending";
  if (s === "ready" || s === "completed") return "Siap";
  if (s === "in_progress" || s === "approved") return "Edukasi";
  if (s === "pending") return "Pending";
  if (s === "rejected") return "Ditolak";
  return "Pending";
}

function getProgressFromStatus(status: string, score: number): number {
  const s = status.toLowerCase();
  if (s === "completed" || s === "ready") return 100;
  if (s === "in_progress") return Math.max(30, Math.min(95, score));
  if (s === "approved") return Math.max(20, Math.min(90, score || 40));
  if (s === "pending") return 5;
  return Math.max(0, Math.min(100, score));
}

function mapScopedPatient(patient: DoctorDashboardPatient): DoctorPatient {
  const rawStatus = patient.status ?? "pending";
  const comprehension = Number(patient.comprehensionScore || 0);
  const normalizedStatus = normalizeStatus(rawStatus);
  return {
    id: patient.id,
    uid: patient.pasienUid || patient.id,
    name: patient.fullName || "Pasien",
    mrn: patient.mrn || "Belum diisi",
    surgery: patient.diagnosis || "Belum diisi",
    anesthesia: patient.anesthesiaType || "Belum ditentukan",
    comprehension: Number.isFinite(comprehension) ? comprehension : 0,
    status: normalizedStatus,
    scheduledConsentDateText: patient.scheduleText || "Belum dijadwalkan",
    scheduledConsentDateRaw: patient.scheduleDateRaw || "",
    scheduledConsentTimeRaw: patient.scheduleTimeRaw || "",
    educationProgress: getProgressFromStatus(normalizedStatus.toLowerCase(), comprehension),
  };
}

export function DoctorPatients() {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState("");
  const [filterType, setFilterType] = useState("all");
  const [patients, setPatients] = useState<DoctorPatient[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState("");
  const session = getDesktopSession();

  useEffect(() => {
    const loadPatients = async () => {
      if (!session?.uid) {
        setLoadError("Sesi login dokter tidak ditemukan.");
        setIsLoading(false);
        return;
      }

      try {
        const scopedPatients = await getDoctorScopedPatients(session.uid);
        const mapped = scopedPatients.map(mapScopedPatient);

        console.info("[DoctorPatients] load summary", {
          doctor_uid: session.uid,
          mergedCount: mapped.length,
        });
        setPatients(mapped);
        setLoadError("");
      } catch (error) {
        const code =
          typeof error === "object" &&
          error !== null &&
          "code" in error &&
          typeof (error as { code?: unknown }).code === "string"
            ? String((error as { code?: string }).code)
            : "";

        console.error("[DoctorPatients] failed to load from Firestore", {
          error,
          code: code || "unknown",
          doctor_uid: session.uid,
        });

        if (code === "permission-denied") {
          setLoadError(userMessages.auth.accessDenied);
        } else if (code === "auth/session-mismatch" || code === "unauthenticated") {
          setLoadError(userMessages.doctorDashboard.sessionMismatch);
        } else {
          setLoadError(userMessages.doctorPatients.loadError);
        }
      } finally {
        setIsLoading(false);
      }
    };

    void loadPatients();
  }, [session?.uid]);

  const anesthesiaOptions = useMemo(() => {
    const types = new Set<string>();
    for (const patient of patients) {
      if (patient.anesthesia !== "Belum ditentukan") {
        types.add(patient.anesthesia);
      }
    }
    return Array.from(types);
  }, [patients]);

  const filteredPatients = useMemo(() => {
    const q = searchQuery.trim().toLowerCase();
    return patients.filter((patient) => {
      const matchesSearch =
        q.length === 0 ||
        patient.name.toLowerCase().includes(q) ||
        patient.mrn.toLowerCase().includes(q);

      const matchesType = filterType === "all" || patient.anesthesia === filterType;
      return matchesSearch && matchesType;
    });
  }, [patients, searchQuery, filterType]);

  const getStatusColor = (status: string) => {
    if (status === "Siap") return "bg-green-100 text-green-700";
    if (status === "Edukasi") return "bg-blue-100 text-blue-700";
    if (status === "Pending") return "bg-yellow-100 text-yellow-700";
    if (status === "Ditolak") return "bg-red-100 text-red-700";
    return "bg-gray-100 text-gray-700";
  };

  return (
    <DoctorLayout>
      <div className="p-8 space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Kelola Pasien</h1>
            <p className="text-gray-600 mt-1">{userMessages.doctorPatients.subtitle}</p>
          </div>
        </div>

        <Card className="border-amber-200 bg-amber-50">
          <CardContent className="pt-6 text-sm text-amber-900">
            {userMessages.doctorPatients.infoBanner}
          </CardContent>
        </Card>

        {isLoading && (
          <Card>
            <CardContent className="pt-6 text-gray-600 text-center">Memuat data pasien...</CardContent>
          </Card>
        )}

        {!isLoading && loadError && (
          <Card className="border-red-200">
            <CardContent className="pt-6 text-center text-red-700">
              <AlertCircle className="w-8 h-8 mx-auto mb-2" />
              {loadError}
            </CardContent>
          </Card>
        )}

        {!isLoading && !loadError && (
          <>
            <Card>
              <CardContent className="pt-6">
                <div className="flex gap-4">
                  <div className="flex-1 relative">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
                    <Input
                      placeholder="Cari pasien berdasarkan nama atau No. RM..."
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      className="pl-10"
                    />
                  </div>
                  <Select value={filterType} onValueChange={setFilterType}>
                    <SelectTrigger className="w-60">
                      <SelectValue placeholder="Filter jenis anestesi" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Semua Jenis</SelectItem>
                      {anesthesiaOptions.map((type) => (
                        <SelectItem key={type} value={type}>
                          {type}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Daftar Pasien</CardTitle>
                <CardDescription>
                  Total {filteredPatients.length} pasien. Pemahaman = skor sesi AI terakhir
                  yang tersimpan.
                </CardDescription>
              </CardHeader>
              <CardContent>
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Pasien</TableHead>
                      <TableHead>Operasi</TableHead>
                      <TableHead>Anestesi</TableHead>
                      <TableHead>Jadwal</TableHead>
                      <TableHead>Progress Edukasi</TableHead>
                      <TableHead>Pemahaman</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead>Aksi</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {filteredPatients.map((patient) => (
                      <TableRow key={patient.id}>
                        <TableCell>
                          <div>
                            <p className="font-medium">{patient.name}</p>
                            <p className="text-sm text-gray-500">{patient.mrn}</p>
                          </div>
                        </TableCell>
                        <TableCell>{patient.surgery}</TableCell>
                        <TableCell>
                          <Badge variant="outline">{patient.anesthesia}</Badge>
                        </TableCell>
                        <TableCell className="text-sm">{patient.scheduledConsentDateText}</TableCell>
                        <TableCell>
                          <div className="space-y-1 min-w-[120px]">
                            <div className="flex items-center justify-between text-xs">
                              <span>{patient.educationProgress}%</span>
                            </div>
                            <Progress value={patient.educationProgress} className="h-2" />
                          </div>
                        </TableCell>
                        <TableCell>
                          <div className="flex items-center gap-2">
                            <TrendingUp
                              className={`w-4 h-4 ${
                                patient.comprehension >= 90
                                  ? "text-green-500"
                                  : patient.comprehension >= 75
                                    ? "text-yellow-500"
                                    : "text-red-500"
                              }`}
                            />
                            <span className="font-semibold">{patient.comprehension}%</span>
                          </div>
                        </TableCell>
                        <TableCell>
                          <Badge className={getStatusColor(patient.status)}>{patient.status}</Badge>
                        </TableCell>
                        <TableCell>
                          <Button
                            variant="outline"
                            size="sm"
                            className="gap-2"
                            onClick={() => navigate(`/doctor/chat/${patient.id}`)}
                          >
                            <MessageCircle className="w-4 h-4" />
                            Chat
                          </Button>
                        </TableCell>
                      </TableRow>
                    ))}

                    {filteredPatients.length === 0 && (
                      <TableRow>
                        <TableCell colSpan={8} className="text-center text-gray-500 py-8">
                          Tidak ada data pasien yang sesuai filter.
                        </TableCell>
                      </TableRow>
                    )}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </>
        )}
      </div>
    </DoctorLayout>
  );
}
