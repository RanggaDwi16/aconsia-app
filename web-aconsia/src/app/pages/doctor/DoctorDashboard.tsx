import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Progress } from "../../components/ui/progress";
import { Users, BookOpen, TrendingUp, MessageSquare, FileDown } from "lucide-react";
import { useNavigate } from "react-router";
import { PDFGenerator, DoctorPerformanceData } from "../../utils/pdfGenerator";
import { toast } from "sonner";

export function DoctorDashboard() {
  const navigate = useNavigate();

  const stats = [
    {
      title: "Total Pasien",
      value: "32",
      icon: Users,
      change: "+5 minggu ini",
      color: "bg-blue-500"
    },
    {
      title: "Konten Edukasi",
      value: "18",
      icon: BookOpen,
      change: "6 jenis anestesi",
      color: "bg-green-500"
    },
    {
      title: "Rata-rata Pemahaman",
      value: "92%",
      icon: TrendingUp,
      change: "+3% dari bulan lalu",
      color: "bg-purple-500"
    },
    {
      title: "Interaksi Chatbot",
      value: "247",
      icon: MessageSquare,
      change: "Total minggu ini",
      color: "bg-orange-500"
    }
  ];

  const recentPatients = [
    { 
      name: "Ibu Sarah Wijaya", 
      mrn: "RM-2025-045", 
      surgery: "Operasi Caesar", 
      anesthesia: "Spinal",
      comprehension: 95,
      status: "Sudah siap"
    },
    { 
      name: "Bapak Andi Pratama", 
      mrn: "RM-2025-044", 
      surgery: "Appendectomy", 
      anesthesia: "Umum",
      comprehension: 88,
      status: "Dalam edukasi"
    },
    { 
      name: "Ibu Dewi Lestari", 
      mrn: "RM-2025-043", 
      surgery: "Operasi Tulang", 
      anesthesia: "Regional",
      comprehension: 78,
      status: "Perlu follow-up"
    },
  ];

  const upcomingProcedures = [
    {
      patient: "Ibu Sarah Wijaya",
      surgery: "Operasi Caesar",
      date: "Besok, 08:00 WIB",
      anesthesia: "Spinal"
    },
    {
      patient: "Bapak Andi Pratama",
      surgery: "Appendectomy",
      date: "Besok, 10:30 WIB",
      anesthesia: "Umum"
    },
    {
      patient: "Ibu Rina Kusuma",
      surgery: "Operasi Hernia",
      date: "8 Mar, 14:00 WIB",
      anesthesia: "Epidural"
    },
  ];

  const handleExportReport = () => {
    const reportData: DoctorPerformanceData = {
      doctorName: "Dr. Ahmad Suryadi, Sp.An",
      period: "Februari 2026",
      totalPatients: 32,
      avgComprehension: 92,
      contentsCreated: 18,
      topPatients: recentPatients.map(p => ({
        name: p.name,
        comprehension: p.comprehension
      })).slice(0, 5)
    };
    
    PDFGenerator.generateDoctorReport(reportData);
    toast.success("Laporan performa berhasil diunduh!");
  };

  return (
    <DashboardLayout role="doctor" userName="Dr. Ahmad Suryadi, Sp.An">
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Dashboard Dokter</h1>
            <p className="text-gray-600 mt-1">Selamat datang kembali, Dr. Ahmad</p>
          </div>
          <div className="flex gap-2">
            <Button 
              variant="outline" 
              onClick={handleExportReport}
              className="gap-2"
            >
              <FileDown className="w-4 h-4" />
              Export Laporan PDF
            </Button>
            <Button 
              onClick={() => navigate('/doctor/patients')} 
              className="bg-orange-600 hover:bg-orange-700"
            >
              <Users className="w-4 h-4 mr-2" />
              Approval Pasien Baru
            </Button>
            <Button onClick={() => navigate('/doctor/patients')} className="bg-blue-600 hover:bg-blue-700">
              Kelola Pasien
            </Button>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {stats.map((stat) => (
            <Card key={stat.title}>
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">{stat.title}</p>
                    <p className="text-3xl font-bold mt-2">{stat.value}</p>
                    <p className="text-xs text-gray-500 mt-2">{stat.change}</p>
                  </div>
                  <div className={`${stat.color} p-3 rounded-lg`}>
                    <stat.icon className="w-6 h-6 text-white" />
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Recent Patients */}
          <Card>
            <CardHeader>
              <CardTitle>Pasien Terbaru</CardTitle>
              <CardDescription>Status pemahaman dan kesiapan</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {recentPatients.map((patient) => (
                <div key={patient.mrn} className="p-4 border rounded-lg space-y-3">
                  <div className="flex items-start justify-between">
                    <div>
                      <p className="font-medium">{patient.name}</p>
                      <p className="text-sm text-gray-600">{patient.mrn}</p>
                    </div>
                    <span className={`text-xs px-2 py-1 rounded-full ${
                      patient.comprehension >= 90 ? 'bg-green-100 text-green-700' :
                      patient.comprehension >= 80 ? 'bg-yellow-100 text-yellow-700' :
                      'bg-red-100 text-red-700'
                    }`}>
                      {patient.status}
                    </span>
                  </div>
                  <div className="text-sm text-gray-600">
                    <p>{patient.surgery} • {patient.anesthesia}</p>
                  </div>
                  <div className="space-y-1">
                    <div className="flex items-center justify-between text-sm">
                      <span>Tingkat Pemahaman</span>
                      <span className="font-semibold">{patient.comprehension}%</span>
                    </div>
                    <Progress value={patient.comprehension} className="h-2" />
                  </div>
                </div>
              ))}
              <Button variant="outline" className="w-full" onClick={() => navigate('/doctor/patients')}>
                Lihat Semua Pasien
              </Button>
            </CardContent>
          </Card>
        </div>

        {/* Quick Actions */}
        <Card>
          <CardHeader>
            <CardTitle>Aksi Cepat</CardTitle>
            <CardDescription>Shortcut untuk tugas yang sering dilakukan</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <Button 
                variant="outline" 
                className="h-auto py-6 flex-col gap-2"
                onClick={() => navigate('/doctor/content')}
              >
                <BookOpen className="w-6 h-6" />
                <span>Upload Konten Baru</span>
              </Button>
              <Button 
                variant="outline" 
                className="h-auto py-6 flex-col gap-2"
                onClick={() => navigate('/doctor/patients')}
              >
                <Users className="w-6 h-6" />
                <span>Kelola Pasien</span>
              </Button>
              <Button 
                variant="outline" 
                className="h-auto py-6 flex-col gap-2"
                onClick={() => navigate('/doctor/profile')}
              >
                <TrendingUp className="w-6 h-6" />
                <span>Lihat Laporan</span>
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}
