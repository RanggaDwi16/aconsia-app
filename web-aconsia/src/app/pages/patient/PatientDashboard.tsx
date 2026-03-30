import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Progress } from "../../components/ui/progress";
import { BookOpen, MessageSquare, ClipboardCheck, Award, Calendar, Stethoscope, FileDown, User } from "lucide-react";
import { useNavigate } from "react-router";
import { PDFGenerator, PatientReportData } from "../../utils/pdfGenerator";
import { toast } from "sonner";

export function PatientDashboard() {
  const navigate = useNavigate();

  const patientInfo = {
    name: "Jordan Smith",
    mrn: "MRN-2026-001",
    dateOfBirth: "-",
    age: "- tahun",
    gender: "-",
    phone: "-",
    bloodType: "-",
    diagnosis: "-",
    surgery: "Laparoscopic Appendectomy",
    anesthesia: "General Anesthesia",
    scheduledDate: "2026-03-15",
    doctor: "Dr. Ahmad Suryadi, Sp.An",
    hospital: "-",
    comprehension: 95,
    educationProgress: 100,
    quizzesTaken: 3
  };

  const menuItems = [
    {
      icon: BookOpen,
      title: "Materi Edukasi",
      description: "Pelajari tentang anestesi spinal Anda",
      color: "bg-blue-500",
      path: "/patient/education"
    },
    {
      icon: MessageSquare,
      title: "Chatbot AI",
      description: "Tanya jawab dengan asisten AI",
      color: "bg-green-500",
      path: "/patient/chatbot"
    },
    {
      icon: ClipboardCheck,
      title: "Kuis Pemahaman",
      description: "Ukur pemahaman Anda",
      color: "bg-purple-500",
      path: "/patient/quiz"
    }
  ];

  const achievements = [
    { icon: Award, text: "Menyelesaikan 3 kuis", color: "text-yellow-500" },
    { icon: BookOpen, text: "Membaca semua materi", color: "text-blue-500" },
    { icon: MessageSquare, text: "Aktif bertanya", color: "text-green-500" },
  ];

  const handleExportReport = () => {
    const reportData: PatientReportData = {
      patientName: patientInfo.name,
      mrn: patientInfo.mrn,
      surgery: patientInfo.surgery,
      anesthesiaType: patientInfo.anesthesia,
      scheduledDate: patientInfo.scheduledDate,
      doctor: patientInfo.doctor,
      comprehensionScore: patientInfo.comprehension,
      quizzesTaken: patientInfo.quizzesTaken,
      educationProgress: patientInfo.educationProgress,
      contentsViewed: 6,
      chatbotInteractions: 15
    };
    
    PDFGenerator.generatePatientReport(reportData);
    toast.success("Laporan pemahaman Anda berhasil diunduh!");
  };

  return (
    <DashboardLayout role="patient" userName="Jordan Smith">
      <div className="space-y-6">
        {/* Page Header with Download Button */}
        <div className="mb-6 flex items-start justify-between">
          <div>
            <h1 className="text-4xl font-bold text-gray-900">Dashboard Pasien</h1>
            <p className="text-gray-600 mt-1">Pantau progress pembelajaran Anda</p>
          </div>
          <Button 
            variant="outline"
            onClick={handleExportReport}
            className="gap-2 border-gray-300 text-gray-700 hover:bg-gray-50"
          >
            <FileDown className="w-4 h-4" />
            Download Laporan
          </Button>
        </div>

        {/* Patient Identity Card - SIMPLIFIED */}
        <Card className="bg-gradient-to-br from-cyan-50 via-blue-50 to-cyan-50 border-cyan-100">
          <CardHeader className="pb-4">
            <CardTitle className="flex items-center gap-2 text-gray-800">
              <User className="w-5 h-5 text-cyan-700" />
              Identitas Pasien
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {/* Column 1 */}
              <div className="space-y-4">
                <div>
                  <p className="text-xs text-gray-600 mb-1">Nama Lengkap</p>
                  <p className="font-semibold text-gray-900">{patientInfo.name}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-600 mb-1">Jenis Kelamin</p>
                  <p className="font-medium text-gray-900">{patientInfo.gender}</p>
                </div>
              </div>

              {/* Column 2 */}
              <div className="space-y-4">
                <div>
                  <p className="text-xs text-gray-600 mb-1">No. Rekam Medis</p>
                  <p className="font-semibold text-gray-900">{patientInfo.mrn}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-600 mb-1">No. Telepon</p>
                  <p className="font-medium text-gray-900">{patientInfo.phone}</p>
                </div>
              </div>

              {/* Column 3 */}
              <div className="space-y-4">
                <div>
                  <p className="text-xs text-gray-600 mb-1">Tanggal Lahir / Umur</p>
                  <p className="font-medium text-gray-900">{patientInfo.dateOfBirth} / {patientInfo.age}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-600 mb-1">Golongan Darah</p>
                  <p className="font-medium text-gray-900">{patientInfo.bloodType}</p>
                </div>
              </div>
            </div>

            {/* Divider */}
            <div className="border-t border-gray-300 my-5"></div>

            {/* Data Operasi & Anestesi Section */}
            <div>
              <h3 className="font-bold text-gray-800 mb-4 text-sm">Data Operasi & Anestesi</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* Column 1 */}
                <div className="space-y-4">
                  <div>
                    <p className="text-xs text-gray-600 mb-1">Diagnosis</p>
                    <p className="font-medium text-gray-900">{patientInfo.diagnosis}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-600 mb-1">Jenis Anestesi</p>
                    <Badge className="bg-blue-600 hover:bg-blue-700 text-white text-xs">
                      {patientInfo.anesthesia}
                    </Badge>
                  </div>
                </div>

                {/* Column 2 */}
                <div className="space-y-4">
                  <div>
                    <p className="text-xs text-gray-600 mb-1">Jenis Operasi</p>
                    <p className="font-semibold text-gray-900">{patientInfo.surgery}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-600 mb-1">Dokter Anestesi</p>
                    <p className="font-semibold text-gray-900">{patientInfo.doctor}</p>
                  </div>
                </div>

                {/* Column 3 */}
                <div className="space-y-4">
                  <div>
                    <p className="text-xs text-gray-600 mb-1">Tanggal Operasi</p>
                    <p className="font-semibold text-gray-900">{patientInfo.scheduledDate}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-600 mb-1">Rumah Sakit</p>
                    <p className="font-medium text-gray-900">{patientInfo.hospital}</p>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Procedure Info Card */}
        <Card className="border-l-4 border-l-blue-600">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Calendar className="w-5 h-5 text-blue-600" />
              Informasi Prosedur Anda
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-600">No. Rekam Medis</p>
                <p className="font-semibold">{patientInfo.mrn}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600">Jenis Operasi</p>
                <p className="font-semibold">{patientInfo.surgery}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600">Jenis Anestesi</p>
                <p className="font-semibold text-blue-600">{patientInfo.anesthesia}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600">Jadwal</p>
                <p className="font-semibold text-red-600">{patientInfo.scheduledDate}</p>
              </div>
              <div className="md:col-span-2">
                <p className="text-sm text-gray-600">Dokter Anestesi</p>
                <div className="flex items-center gap-2 mt-1">
                  <Stethoscope className="w-4 h-4 text-blue-600" />
                  <p className="font-semibold">{patientInfo.doctor}</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Progress Section */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card>
            <CardContent className="p-6">
              <div className="text-center">
                <div className="inline-flex items-center justify-center w-20 h-20 bg-green-100 rounded-full mb-4">
                  <span className="text-3xl font-bold text-green-600">{patientInfo.comprehension}%</span>
                </div>
                <p className="font-semibold mb-1">Tingkat Pemahaman</p>
                <p className="text-sm text-gray-600">Excellent! Anda sudah siap</p>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="text-center">
                <div className="inline-flex items-center justify-center w-20 h-20 bg-blue-100 rounded-full mb-4">
                  <span className="text-3xl font-bold text-blue-600">{patientInfo.educationProgress}%</span>
                </div>
                <p className="font-semibold mb-1">Progress Edukasi</p>
                <p className="text-sm text-gray-600">Semua materi selesai</p>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="text-center">
                <div className="inline-flex items-center justify-center w-20 h-20 bg-purple-100 rounded-full mb-4">
                  <span className="text-3xl font-bold text-purple-600">{patientInfo.quizzesTaken}</span>
                </div>
                <p className="font-semibold mb-1">Kuis Diselesaikan</p>
                <p className="text-sm text-gray-600">Keep learning!</p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Quick Access Menu */}
        <Card>
          <CardHeader>
            <CardTitle>Menu Edukasi</CardTitle>
            <CardDescription>Pilih aktivitas untuk mempersiapkan diri Anda</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {menuItems.map((item) => (
                <button
                  key={item.title}
                  onClick={() => navigate(item.path)}
                  className="p-6 border rounded-lg hover:shadow-lg transition-shadow text-left group"
                >
                  <div className={`${item.color} w-12 h-12 rounded-lg flex items-center justify-center mb-4 group-hover:scale-110 transition-transform`}>
                    <item.icon className="w-6 h-6 text-white" />
                  </div>
                  <h3 className="font-semibold mb-2">{item.title}</h3>
                  <p className="text-sm text-gray-600">{item.description}</p>
                </button>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Achievements */}
        <Card>
          <CardHeader>
            <CardTitle>Pencapaian Anda</CardTitle>
            <CardDescription>Badge yang telah Anda raih</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {achievements.map((achievement, index) => (
                <div key={index} className="flex items-center gap-3 p-4 border rounded-lg">
                  <achievement.icon className={`w-8 h-8 ${achievement.color}`} />
                  <p className="font-medium">{achievement.text}</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Tips Card */}
        <Card className="bg-gradient-to-r from-green-50 to-blue-50 border-green-200">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <span>💚</span>
              Tips Persiapan Operasi
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-2 text-sm">
              <li>✓ Puasa sebelum operasi sesuai instruksi dokter</li>
              <li>✓ Informasikan alergi obat atau riwayat kesehatan</li>
              <li>✓ Jangan ragu untuk bertanya jika ada yang belum jelas</li>
              <li>✓ Bawa hasil pemeriksaan medis terbaru</li>
              <li>✓ Pastikan didampingi keluarga saat operasi</li>
            </ul>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}