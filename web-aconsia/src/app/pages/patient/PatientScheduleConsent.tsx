import { useState } from "react";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { 
  ArrowLeft, 
  Calendar,
  Clock,
  MapPin,
  User,
  Phone,
  Mail,
  Stethoscope,
  FileText,
  CheckCircle,
  AlertTriangle
} from "lucide-react";
import { useNavigate } from "react-router";
import {
  AlertDialog,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "../../components/ui/alert-dialog";

export function PatientScheduleConsent() {
  const navigate = useNavigate();
  
  // Patient data
  const patientData = {
    fullName: "Jordan Smith",
    mrn: "2026-001234",
    dateOfBirth: "15 Januari 1992",
    age: 34,
    gender: "Laki-laki",
    phone: "+62 812-3456-7890",
    email: "jordan.smith@email.com",
    address: "Jl. Merdeka No. 123, Jakarta Pusat",
    surgeryType: "Sectio Caesarea",
    surgeryDate: "15 Maret 2026",
    asaStatus: "I",
    anesthesiaType: "Anestesi Spinal",
  };

  // Doctor data
  const doctorData = {
    fullName: "Dr. Emily Carter, Sp.An",
    specialization: "Spesialis Anestesiologi",
    str: "Nomor STR: 1234567890",
    sip: "Nomor SIP: SIP-2024-01-12345",
    sipExpiry: "SIP Kadaluarsa: 20/10/2026",
    hospital: "RS Graha Medika Jakarta",
    email: "dr.emily@grahamedika.com",
    phone: "+62 811-2222-3344",
    experience: "8 tahun pengalaman",
  };

  const [selectedDate, setSelectedDate] = useState("");
  const [selectedTime, setSelectedTime] = useState("");
  const [showConfirmation, setShowConfirmation] = useState(false);
  const [showSuccess, setShowSuccess] = useState(false);
  const [showWarning, setShowWarning] = useState(false);

  // Comprehension score (simulate from localStorage or props)
  const comprehensionScore = 85; // Should be >= 80%

  const availableSlots = [
    { date: "2026-03-10", label: "Senin, 10 Maret 2026" },
    { date: "2026-03-11", label: "Selasa, 11 Maret 2026" },
    { date: "2026-03-12", label: "Rabu, 12 Maret 2026" },
  ];

  const timeSlots = [
    { time: "08:00", label: "08:00 - 08:45", available: true },
    { time: "09:00", label: "09:00 - 09:45", available: true },
    { time: "10:00", label: "10:00 - 10:45", available: false },
    { time: "13:00", label: "13:00 - 13:45", available: true },
    { time: "14:00", label: "14:00 - 14:45", available: true },
  ];

  const handleSubmit = () => {
    if (!selectedDate || !selectedTime) {
      alert("Pilih tanggal dan waktu terlebih dahulu");
      return;
    }

    if (comprehensionScore < 80) {
      setShowWarning(true);
      return;
    }

    setShowConfirmation(true);
  };

  const handleConfirm = () => {
    setShowConfirmation(false);
    setShowSuccess(true);
  };

  const handleSuccessClose = () => {
    setShowSuccess(false);
    navigate('/patient');
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="bg-white border-b sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4 max-w-2xl">
          <div className="flex items-center gap-3">
            <Button variant="ghost" size="sm" onClick={() => navigate('/patient')}>
              <ArrowLeft className="w-5 h-5" />
            </Button>
            <div>
              <h1 className="text-xl font-bold text-gray-900">Penjadwalan Tanda Tangan</h1>
              <p className="text-sm text-gray-600">Informed Consent Anestesi</p>
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-6 max-w-2xl space-y-4">
        {/* Comprehension Score Badge */}
        <Card className={`border-2 ${
          comprehensionScore >= 80 
            ? "border-green-200 bg-green-50" 
            : "border-orange-200 bg-orange-50"
        }`}>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-semibold text-gray-700">Tingkat Pemahaman Anda</p>
                <p className="text-xs text-gray-600 mt-0.5">
                  {comprehensionScore >= 80 
                    ? "✅ Anda siap untuk informed consent" 
                    : `⚠️ Minimal 80% diperlukan (kurang ${80 - comprehensionScore}%)`
                  }
                </p>
              </div>
              <div className="text-right">
                <p className={`text-3xl font-bold ${
                  comprehensionScore >= 80 ? "text-green-600" : "text-orange-600"
                }`}>
                  {comprehensionScore}%
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Patient Information */}
        <Card>
          <CardContent className="p-0">
            <div className="bg-blue-600 text-white p-4 rounded-t-lg">
              <div className="flex items-center gap-2 mb-1">
                <User className="w-5 h-5" />
                <h3 className="font-bold text-lg">Informasi Pasien</h3>
              </div>
              <p className="text-sm text-blue-100">Data identitas lengkap</p>
            </div>
            <div className="p-4 space-y-3">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <p className="text-xs text-gray-600">Nama Lengkap</p>
                  <p className="font-semibold text-gray-900">{patientData.fullName}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-600">No. Rekam Medis</p>
                  <p className="font-semibold text-gray-900">{patientData.mrn}</p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <p className="text-xs text-gray-600">Tanggal Lahir</p>
                  <p className="font-semibold text-gray-900">{patientData.dateOfBirth}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-600">Usia / Jenis Kelamin</p>
                  <p className="font-semibold text-gray-900">{patientData.age} tahun / {patientData.gender}</p>
                </div>
              </div>

              <div>
                <p className="text-xs text-gray-600 flex items-center gap-1">
                  <Phone className="w-3 h-3" /> Nomor Telepon
                </p>
                <p className="font-semibold text-gray-900">{patientData.phone}</p>
              </div>

              <div>
                <p className="text-xs text-gray-600 flex items-center gap-1">
                  <Mail className="w-3 h-3" /> Email
                </p>
                <p className="font-semibold text-gray-900">{patientData.email}</p>
              </div>

              <div>
                <p className="text-xs text-gray-600 flex items-center gap-1">
                  <MapPin className="w-3 h-3" /> Alamat
                </p>
                <p className="font-semibold text-gray-900">{patientData.address}</p>
              </div>

              <div className="pt-3 border-t">
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <p className="text-xs text-gray-600">Jenis Operasi</p>
                    <p className="font-semibold text-gray-900">{patientData.surgeryType}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-600">Tanggal Operasi</p>
                    <p className="font-semibold text-gray-900">{patientData.surgeryDate}</p>
                  </div>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <p className="text-xs text-gray-600">Status ASA</p>
                  <Badge className="bg-blue-600">{patientData.asaStatus}</Badge>
                </div>
                <div>
                  <p className="text-xs text-gray-600">Jenis Anestesi</p>
                  <Badge variant="outline">{patientData.anesthesiaType}</Badge>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Doctor Information */}
        <Card>
          <CardContent className="p-0">
            <div className="bg-green-600 text-white p-4 rounded-t-lg">
              <div className="flex items-center gap-2 mb-1">
                <Stethoscope className="w-5 h-5" />
                <h3 className="font-bold text-lg">Informasi Dokter</h3>
              </div>
              <p className="text-sm text-green-100">Dokter anestesi yang menangani</p>
            </div>
            <div className="p-4 space-y-3">
              <div>
                <p className="text-xs text-gray-600">Nama Lengkap</p>
                <p className="font-bold text-lg text-gray-900">{doctorData.fullName}</p>
                <p className="text-sm text-gray-600">{doctorData.specialization}</p>
              </div>

              <div className="bg-gray-50 rounded-lg p-3 space-y-2">
                <div>
                  <p className="text-xs text-gray-600 flex items-center gap-1">
                    <FileText className="w-3 h-3" /> {doctorData.str}
                  </p>
                </div>
                <div>
                  <p className="text-xs text-gray-600">{doctorData.sip}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-600">{doctorData.sipExpiry}</p>
                </div>
              </div>

              <div>
                <p className="text-xs text-gray-600 flex items-center gap-1">
                  <MapPin className="w-3 h-3" /> Rumah Sakit
                </p>
                <p className="font-semibold text-gray-900">{doctorData.hospital}</p>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <p className="text-xs text-gray-600 flex items-center gap-1">
                    <Mail className="w-3 h-3" /> Email
                  </p>
                  <p className="text-sm font-semibold text-gray-900">{doctorData.email}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-600 flex items-center gap-1">
                    <Phone className="w-3 h-3" /> Telepon
                  </p>
                  <p className="text-sm font-semibold text-gray-900">{doctorData.phone}</p>
                </div>
              </div>

              <div className="pt-3 border-t">
                <Badge variant="secondary" className="bg-green-100 text-green-800">
                  {doctorData.experience}
                </Badge>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Schedule Selection */}
        <Card>
          <CardContent className="p-0">
            <div className="bg-purple-600 text-white p-4 rounded-t-lg">
              <div className="flex items-center gap-2 mb-1">
                <Calendar className="w-5 h-5" />
                <h3 className="font-bold text-lg">Pilih Jadwal Konsultasi</h3>
              </div>
              <p className="text-sm text-purple-100">Ruang Konsultasi Anestesi</p>
            </div>
            <div className="p-4 space-y-4">
              {/* Date Selection */}
              <div>
                <label className="text-sm font-semibold text-gray-900 mb-2 block">
                  Tanggal Konsultasi
                </label>
                <div className="space-y-2">
                  {availableSlots.map((slot) => (
                    <button
                      key={slot.date}
                      onClick={() => setSelectedDate(slot.date)}
                      className={`w-full p-3 text-left border-2 rounded-lg transition-all ${
                        selectedDate === slot.date
                          ? "border-blue-600 bg-blue-50"
                          : "border-gray-200 hover:border-gray-300"
                      }`}
                    >
                      <div className="flex items-center gap-2">
                        <Calendar className="w-4 h-4 text-gray-600" />
                        <span className="font-medium text-gray-900">{slot.label}</span>
                      </div>
                    </button>
                  ))}
                </div>
              </div>

              {/* Time Selection */}
              {selectedDate && (
                <div>
                  <label className="text-sm font-semibold text-gray-900 mb-2 block">
                    Waktu Konsultasi
                  </label>
                  <div className="space-y-2">
                    {timeSlots.map((slot) => (
                      <button
                        key={slot.time}
                        onClick={() => slot.available && setSelectedTime(slot.time)}
                        disabled={!slot.available}
                        className={`w-full p-3 text-left border-2 rounded-lg transition-all ${
                          !slot.available
                            ? "border-gray-200 bg-gray-100 opacity-50 cursor-not-allowed"
                            : selectedTime === slot.time
                              ? "border-blue-600 bg-blue-50"
                              : "border-gray-200 hover:border-gray-300"
                        }`}
                      >
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-2">
                            <Clock className="w-4 h-4 text-gray-600" />
                            <span className="font-medium text-gray-900">{slot.label}</span>
                          </div>
                          {!slot.available && (
                            <Badge variant="secondary" className="bg-red-100 text-red-800">
                              Tidak Tersedia
                            </Badge>
                          )}
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Location Info */}
              {selectedDate && selectedTime && (
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                  <p className="text-sm font-semibold text-blue-900 mb-2">
                    📍 Lokasi Konsultasi:
                  </p>
                  <p className="text-sm text-blue-800">
                    Ruang Konsultasi Anestesi Lt. 2<br />
                    {doctorData.hospital}
                  </p>
                  <p className="text-xs text-blue-700 mt-2">
                    💡 Durasi: 30-45 menit
                  </p>
                </div>
              )}
            </div>
          </CardContent>
        </Card>

        {/* Submit Button */}
        <Button 
          onClick={handleSubmit}
          disabled={!selectedDate || !selectedTime || comprehensionScore < 80}
          className="w-full bg-blue-600 hover:bg-blue-700 h-12 text-base font-semibold"
        >
          Konfirmasi Jadwal
        </Button>

        {comprehensionScore < 80 && (
          <Card className="border-orange-200 bg-orange-50">
            <CardContent className="p-4">
              <div className="flex items-start gap-3">
                <AlertTriangle className="w-5 h-5 text-orange-600 flex-shrink-0 mt-0.5" />
                <div className="text-sm text-orange-900">
                  <p className="font-semibold mb-1">Tingkat pemahaman belum mencukupi</p>
                  <p className="text-orange-800">
                    Silakan selesaikan pembelajaran hingga minimal 80% untuk dapat 
                    menjadwalkan informed consent.
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        )}
      </div>

      {/* Confirmation Dialog */}
      <AlertDialog open={showConfirmation} onOpenChange={setShowConfirmation}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Calendar className="w-8 h-8 text-blue-600" />
            </div>
            <AlertDialogTitle className="text-center">Konfirmasi Jadwal</AlertDialogTitle>
            <AlertDialogDescription className="text-center">
              <div className="space-y-2 text-gray-700">
                <p className="font-semibold text-base">
                  {availableSlots.find(s => s.date === selectedDate)?.label}
                </p>
                <p className="font-semibold text-base">
                  Pukul {timeSlots.find(s => s.time === selectedTime)?.label}
                </p>
                <p className="text-sm mt-4">
                  Apakah Anda yakin ingin menjadwalkan konsultasi 
                  informed consent pada waktu tersebut?
                </p>
              </div>
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter className="flex-col gap-2">
            <Button 
              onClick={handleConfirm}
              className="w-full bg-blue-600 hover:bg-blue-700"
            >
              Ya, Konfirmasi
            </Button>
            <Button 
              onClick={() => setShowConfirmation(false)}
              variant="outline" 
              className="w-full"
            >
              Batal
            </Button>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* Success Dialog */}
      <AlertDialog open={showSuccess} onOpenChange={setShowSuccess}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <CheckCircle className="w-8 h-8 text-green-600" />
            </div>
            <AlertDialogTitle className="text-center">Jadwal Terkonfirmasi!</AlertDialogTitle>
            <AlertDialogDescription className="text-center">
              <div className="space-y-3 text-gray-700">
                <div className="bg-green-50 border border-green-200 rounded-lg p-4 mt-4">
                  <p className="font-semibold text-green-900 mb-2">
                    {availableSlots.find(s => s.date === selectedDate)?.label}
                  </p>
                  <p className="font-semibold text-green-900">
                    Pukul {timeSlots.find(s => s.time === selectedTime)?.label}
                  </p>
                </div>
                <p className="text-sm">
                  📧 Email konfirmasi telah dikirim<br />
                  📱 SMS reminder akan dikirim H-1<br />
                  📅 Calendar invite tersedia di email
                </p>
              </div>
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <Button 
              onClick={handleSuccessClose}
              className="w-full bg-green-600 hover:bg-green-700"
            >
              Kembali ke Dashboard
            </Button>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* Warning Dialog (< 80%) */}
      <AlertDialog open={showWarning} onOpenChange={setShowWarning}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <AlertTriangle className="w-8 h-8 text-red-600" />
            </div>
            <AlertDialogTitle className="text-center">PERHATIAN!!!</AlertDialogTitle>
            <AlertDialogDescription className="text-center">
              <p className="text-gray-700">
                Anda tidak bisa memilih Jadwal untuk tanda tangan lembar Anestesi ini 
                sebelum membaca persiapan anestesi.
              </p>
              <p className="text-sm text-gray-600 mt-3">
                Tingkat pemahaman Anda saat ini: <strong>{comprehensionScore}%</strong><br />
                Minimum yang diperlukan: <strong>80%</strong>
              </p>
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <Button 
              onClick={() => setShowWarning(false)}
              className="w-full"
            >
              Kembali
            </Button>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
