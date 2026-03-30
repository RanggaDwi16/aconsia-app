import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { useNavigate } from "react-router";
import {
  ArrowLeft,
  User,
  Calendar,
  MapPin,
  Phone,
  Mail,
  Heart,
  Activity,
  AlertCircle,
  FileText,
  Users,
  Home,
  CreditCard,
  Briefcase,
} from "lucide-react";

export function PatientProfile() {
  const navigate = useNavigate();
  const [patientData, setPatientData] = useState<any>(null);

  useEffect(() => {
    const currentPatient = localStorage.getItem("currentPatient");
    if (currentPatient) {
      setPatientData(JSON.parse(currentPatient));
    }
  }, []);

  if (!patientData) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <Card className="max-w-md">
          <CardContent className="p-8 text-center">
            <AlertCircle className="w-16 h-16 text-red-600 mx-auto mb-4" />
            <h3 className="text-xl font-bold mb-2">Data Tidak Ditemukan</h3>
            <p className="text-gray-600 mb-4">Silakan login kembali</p>
            <Button onClick={() => navigate("/login")} className="w-full">
              Kembali ke Login
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

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

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center gap-4">
            <Button
              variant="outline"
              size="sm"
              onClick={() => navigate("/patient/dashboard-new")}
              className="border-gray-300"
            >
              <ArrowLeft className="w-4 h-4 mr-2" />
              Kembali
            </Button>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Profil Pasien</h1>
              <p className="text-sm text-gray-600 mt-1">Identitas Lengkap</p>
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-6 py-8 max-w-4xl">
        {/* Header Card */}
        <Card className="mb-6 bg-gradient-to-r from-blue-600 to-cyan-600 text-white border-0">
          <CardContent className="p-6">
            <div className="flex items-center gap-4">
              <div className="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center">
                <User className="w-10 h-10 text-white" />
              </div>
              <div className="flex-1">
                <h2 className="text-2xl font-bold mb-1">{patientData.fullName}</h2>
                <div className="flex items-center gap-4 text-blue-100">
                  <span>No. RM: {patientData.mrn}</span>
                  <span>•</span>
                  <span>NIK: {patientData.nik}</span>
                </div>
              </div>
              <Badge className="bg-white text-blue-600 font-semibold">
                {patientData.status === "approved" ? "✓ Disetujui" : "⏳ Pending"}
              </Badge>
            </div>
          </CardContent>
        </Card>

        <div className="grid md:grid-cols-2 gap-6">
          {/* Data Pribadi */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <User className="w-5 h-5 text-blue-600" />
                Data Pribadi
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <p className="text-xs text-gray-500 mb-1">Nama Lengkap</p>
                <p className="font-medium text-gray-900">{patientData.fullName}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">NIK</p>
                <p className="font-medium text-gray-900">{patientData.nik}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Tanggal Lahir</p>
                <p className="font-medium text-gray-900">
                  {new Date(patientData.dateOfBirth).toLocaleDateString("id-ID", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })}
                </p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Umur</p>
                <p className="font-medium text-gray-900">{patientData.age} tahun</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Jenis Kelamin</p>
                <p className="font-medium text-gray-900">
                  {patientData.gender === "male" ? "Laki-laki" : "Perempuan"}
                </p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Agama</p>
                <p className="font-medium text-gray-900">{patientData.religion}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Status Pernikahan</p>
                <p className="font-medium text-gray-900">
                  {patientData.maritalStatus === "married"
                    ? "Menikah"
                    : patientData.maritalStatus === "single"
                    ? "Belum Menikah"
                    : "Cerai"}
                </p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Pendidikan Terakhir</p>
                <p className="font-medium text-gray-900">{patientData.education || "-"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Pekerjaan</p>
                <p className="font-medium text-gray-900">{patientData.occupation || "-"}</p>
              </div>
            </CardContent>
          </Card>

          {/* Kontak & Alamat */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <Phone className="w-5 h-5 text-green-600" />
                Kontak & Alamat
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <p className="text-xs text-gray-500 mb-1">No. Telepon</p>
                <p className="font-medium text-gray-900">{patientData.phone}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Email</p>
                <p className="font-medium text-gray-900">{patientData.email || "-"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Alamat Lengkap</p>
                <p className="font-medium text-gray-900">{patientData.address}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">RT / RW</p>
                <p className="font-medium text-gray-900">
                  {patientData.rt} / {patientData.rw}
                </p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Kelurahan/Desa</p>
                <p className="font-medium text-gray-900">{patientData.kelurahan}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Kecamatan</p>
                <p className="font-medium text-gray-900">{patientData.kecamatan}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Kota/Kabupaten</p>
                <p className="font-medium text-gray-900">{patientData.city}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Provinsi</p>
                <p className="font-medium text-gray-900">{patientData.province}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Kode Pos</p>
                <p className="font-medium text-gray-900">{patientData.postalCode || "-"}</p>
              </div>
            </CardContent>
          </Card>

          {/* Penanggung Jawab */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <Users className="w-5 h-5 text-purple-600" />
                Penanggung Jawab
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <p className="text-xs text-gray-500 mb-1">Nama Penanggung Jawab</p>
                <p className="font-medium text-gray-900">{patientData.guardianName}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Hubungan dengan Pasien</p>
                <p className="font-medium text-gray-900">{patientData.guardianRelation}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">No. Telepon Penanggung Jawab</p>
                <p className="font-medium text-gray-900">{patientData.guardianPhone}</p>
              </div>
            </CardContent>
          </Card>

          {/* Asuransi */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <CreditCard className="w-5 h-5 text-orange-600" />
                Asuransi & Pembayaran
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <p className="text-xs text-gray-500 mb-1">Jenis Asuransi</p>
                <Badge className="bg-blue-100 text-blue-800">
                  {patientData.insuranceType === "bpjs"
                    ? "BPJS Kesehatan"
                    : patientData.insuranceType === "private"
                    ? "Asuransi Swasta"
                    : "Umum (Pribadi)"}
                </Badge>
              </div>
              {patientData.insuranceNumber && (
                <div>
                  <p className="text-xs text-gray-500 mb-1">No. Asuransi</p>
                  <p className="font-medium text-gray-900">{patientData.insuranceNumber}</p>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Info Kesehatan */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <Heart className="w-5 h-5 text-red-600" />
                Informasi Kesehatan
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <p className="text-xs text-gray-500 mb-1">Tinggi Badan</p>
                <p className="font-medium text-gray-900">{patientData.height} cm</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Berat Badan</p>
                <p className="font-medium text-gray-900">{patientData.weight} kg</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Golongan Darah</p>
                <Badge className="bg-red-100 text-red-800">{patientData.bloodType}</Badge>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Alergi</p>
                <p className="font-medium text-gray-900">{patientData.allergies || "Tidak ada"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Riwayat Penyakit</p>
                <p className="font-medium text-gray-900">
                  {patientData.medicalHistory || "Tidak ada"}
                </p>
              </div>
            </CardContent>
          </Card>

          {/* Info Operasi & Anestesi */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <Activity className="w-5 h-5 text-cyan-600" />
                Informasi Operasi & Anestesi
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <p className="text-xs text-gray-500 mb-1">Diagnosis Medis</p>
                <p className="font-medium text-gray-900">{patientData.diagnosis || "-"}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Jenis Operasi</p>
                <p className="font-medium text-gray-900">{patientData.surgeryType}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Tanggal Operasi</p>
                <p className="font-medium text-gray-900">
                  {new Date(patientData.surgeryDate).toLocaleDateString("id-ID", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })}
                </p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Jenis Anestesi</p>
                <Badge className="bg-blue-600 text-white">
                  {getAnesthesiaLabel(patientData.anesthesiaType)}
                </Badge>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Dokter Anestesi</p>
                <p className="font-medium text-gray-900">
                  {patientData.doctorName || patientData.anesthesiologistName}
                </p>
              </div>
              <div>
                <p className="text-xs text-gray-500 mb-1">Rumah Sakit</p>
                <p className="font-medium text-gray-900">{patientData.hospitalName || "-"}</p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Back Button */}
        <div className="mt-6">
          <Button
            onClick={() => navigate("/patient/dashboard-new")}
            className="w-full bg-blue-600 hover:bg-blue-700"
          >
            Kembali ke Dashboard
          </Button>
        </div>
      </div>
    </div>
  );
}
