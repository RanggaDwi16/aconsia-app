import { FileText, Calendar, User, Activity, CheckCircle, AlertCircle, Clock } from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../ui/card";
import { Badge } from "../ui/badge";

interface PatientReportCardProps {
  patient: {
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
    materialsCompleted?: number;
    totalMaterials?: number;
    lastActivity?: string;
    scheduledConsentDate?: string;
    createdAt?: string;
  };
}

export function PatientReportCard({ patient }: PatientReportCardProps) {
  const getStatusColor = (status: string) => {
    switch (status) {
      case "pending":
        return "bg-yellow-100 text-yellow-800 border-yellow-200";
      case "approved":
        return "bg-blue-100 text-blue-800 border-blue-200";
      case "in_progress":
        return "bg-blue-100 text-blue-800 border-blue-200";
      case "ready":
        return "bg-green-100 text-green-800 border-green-200";
      case "completed":
        return "bg-gray-100 text-gray-800 border-gray-200";
      default:
        return "bg-gray-100 text-gray-800 border-gray-200";
    }
  };

  const getScoreColor = (score: number) => {
    if (score >= 80) return "text-green-600";
    if (score >= 60) return "text-yellow-600";
    return "text-red-600";
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "ready":
        return <CheckCircle className="w-5 h-5" />;
      case "in_progress":
        return <Activity className="w-5 h-5" />;
      case "pending":
        return <Clock className="w-5 h-5" />;
      default:
        return <AlertCircle className="w-5 h-5" />;
    }
  };

  const registrationDate = patient.createdAt
    ? new Date(patient.createdAt).toLocaleDateString("id-ID", {
        day: "numeric",
        month: "long",
        year: "numeric",
      })
    : "N/A";

  const daysSinceRegistration = patient.createdAt
    ? Math.floor((Date.now() - new Date(patient.createdAt).getTime()) / (1000 * 60 * 60 * 24))
    : 0;

  return (
    <Card className="border-2 hover:shadow-lg transition-shadow">
      <CardHeader className="pb-3">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <CardTitle className="text-lg font-bold text-slate-900 mb-1">
              {patient.fullName}
            </CardTitle>
            <CardDescription className="text-sm space-y-1">
              <div className="flex items-center gap-2 text-slate-600">
                <FileText className="w-4 h-4" />
                <span>MRN: {patient.mrn}</span>
              </div>
              {patient.nik && (
                <div className="flex items-center gap-2 text-slate-600">
                  <User className="w-4 h-4" />
                  <span>NIK: {patient.nik}</span>
                </div>
              )}
            </CardDescription>
          </div>
          <Badge className={`${getStatusColor(patient.status)} border flex items-center gap-1`}>
            {getStatusIcon(patient.status)}
            <span className="font-semibold">
              {patient.status === "pending"
                ? "Pending"
                : patient.status === "ready"
                ? "Siap TTD"
                : patient.status === "in_progress"
                ? "Belajar"
                : patient.status === "approved"
                ? "Disetujui"
                : "Selesai"}
            </span>
          </Badge>
        </div>
      </CardHeader>

      <CardContent className="space-y-4">
        {/* Patient Demographics */}
        {patient.dateOfBirth && (
          <div className="bg-slate-50 rounded-lg p-3 text-sm">
            <div className="grid grid-cols-2 gap-2">
              <div>
                <p className="text-xs text-slate-500 mb-1">Usia</p>
                <p className="font-semibold text-slate-900">{patient.age} tahun</p>
              </div>
              <div>
                <p className="text-xs text-slate-500 mb-1">Jenis Kelamin</p>
                <p className="font-semibold text-slate-900 capitalize">{patient.gender}</p>
              </div>
            </div>
          </div>
        )}

        {/* Medical Information */}
        <div className="space-y-3">
          <div>
            <p className="text-xs text-slate-500 mb-1">Diagnosis</p>
            <p className="font-semibold text-slate-900">{patient.diagnosis || "Belum ditentukan"}</p>
          </div>

          <div>
            <p className="text-xs text-slate-500 mb-1">Jenis Operasi</p>
            <p className="font-semibold text-slate-900">{patient.surgeryType}</p>
          </div>

          <div className="flex items-center gap-2">
            <Calendar className="w-4 h-4 text-blue-600" />
            <div className="flex-1">
              <p className="text-xs text-slate-500">Tanggal Operasi</p>
              <p className="font-semibold text-blue-600">
                {new Date(patient.surgeryDate).toLocaleDateString("id-ID", {
                  day: "numeric",
                  month: "long",
                  year: "numeric",
                })}
              </p>
            </div>
          </div>

          <div>
            <p className="text-xs text-slate-500 mb-1">Jenis Anestesi</p>
            <Badge className="bg-purple-100 text-purple-800 border-purple-200">
              {patient.anesthesiaType || "Belum dipilih"}
            </Badge>
          </div>
        </div>

        {/* Learning Progress */}
        {patient.status !== "pending" && (
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
            <div className="flex items-center justify-between mb-2">
              <p className="text-sm font-semibold text-blue-900">Progress Pembelajaran</p>
              <span className={`text-xl font-bold ${getScoreColor(patient.comprehensionScore)}`}>
                {patient.comprehensionScore}%
              </span>
            </div>
            
            <div className="h-3 bg-blue-100 rounded-full overflow-hidden mb-2">
              <div
                className={`h-full rounded-full transition-all ${
                  patient.comprehensionScore >= 80
                    ? "bg-green-600"
                    : patient.comprehensionScore >= 60
                    ? "bg-yellow-600"
                    : "bg-red-600"
                }`}
                style={{ width: `${patient.comprehensionScore}%` }}
              />
            </div>

            <div className="flex items-center justify-between text-xs text-blue-700">
              <span>
                Materi: {patient.materialsCompleted || 0}/{patient.totalMaterials || 0}
              </span>
              <span>{patient.lastActivity || "N/A"}</span>
            </div>
          </div>
        )}

        {/* Consent Schedule */}
        {patient.scheduledConsentDate && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-3">
            <div className="flex items-center gap-2">
              <CheckCircle className="w-5 h-5 text-green-600" />
              <div className="flex-1">
                <p className="text-xs text-green-700 font-semibold">Jadwal TTD Informed Consent</p>
                <p className="text-sm text-green-900 font-bold">
                  {new Date(patient.scheduledConsentDate).toLocaleString("id-ID", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                    hour: "2-digit",
                    minute: "2-digit",
                  })}
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Registration Info */}
        <div className="pt-3 border-t border-slate-200 text-xs text-slate-500">
          <div className="flex items-center justify-between">
            <span>Terdaftar: {registrationDate}</span>
            <span className="font-semibold">{daysSinceRegistration} hari lalu</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
