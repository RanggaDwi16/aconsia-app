import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Users, Stethoscope, TrendingUp, FileCheck, FileDown } from "lucide-react";
import { Progress } from "../../components/ui/progress";
import { Button } from "../../components/ui/button";
import { PDFGenerator, HospitalReportData } from "../../utils/pdfGenerator";
import { toast } from "sonner";

export function AdminDashboard() {
  const stats = [
    {
      title: "Total Dokter Aktif",
      value: "24",
      icon: Stethoscope,
      change: "+2 bulan ini",
      color: "bg-blue-500"
    },
    {
      title: "Total Pasien",
      value: "156",
      icon: Users,
      change: "+15 bulan ini",
      color: "bg-green-500"
    },
    {
      title: "Rata-rata Pemahaman",
      value: "87%",
      icon: TrendingUp,
      change: "+5% dari bulan lalu",
      color: "bg-purple-500"
    },
    {
      title: "Consent Selesai",
      value: "142",
      icon: FileCheck,
      change: "91% completion rate",
      color: "bg-orange-500"
    }
  ];

  const topDoctors = [
    { name: "Dr. Ahmad Suryadi, Sp.An", patients: 32, comprehension: 92 },
    { name: "Dr. Siti Nurhaliza, Sp.An", patients: 28, comprehension: 89 },
    { name: "Dr. Budi Santoso, Sp.An", patients: 25, comprehension: 88 },
    { name: "Dr. Rina Kusuma, Sp.An", patients: 22, comprehension: 86 },
  ];

  const anesthesiaStats = [
    { type: "Anestesi Umum", count: 45, percentage: 29 },
    { type: "Anestesi Spinal", count: 52, percentage: 33 },
    { type: "Anestesi Epidural", count: 38, percentage: 24 },
    { type: "Anestesi Regional", count: 21, percentage: 14 },
  ];

  const handleExportReport = () => {
    const reportData: HospitalReportData = {
      period: "Februari 2026",
      totalDoctors: 24,
      totalPatients: 156,
      avgComprehension: 87,
      completionRate: 91,
      anesthesiaDistribution: anesthesiaStats
    };
    
    PDFGenerator.generateHospitalReport(reportData);
    toast.success("Laporan rumah sakit berhasil diunduh!");
  };

  return (
    <DashboardLayout role="admin" userName="Admin RS">
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Dashboard Administrator</h1>
            <p className="text-gray-600 mt-1">Sistem Edukasi Informed Consent Anestesi</p>
          </div>
          <Button 
            onClick={handleExportReport}
            className="bg-purple-600 hover:bg-purple-700 gap-2"
          >
            <FileDown className="w-4 h-4" />
            Export Laporan PDF
          </Button>
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
          {/* Top Doctors */}
          <Card>
            <CardHeader>
              <CardTitle>Performa Dokter Terbaik</CardTitle>
              <CardDescription>Berdasarkan tingkat pemahaman pasien</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {topDoctors.map((doctor, index) => (
                <div key={doctor.name} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 bg-blue-100 text-blue-700 rounded-full flex items-center justify-center font-bold text-sm">
                        {index + 1}
                      </div>
                      <div>
                        <p className="font-medium text-sm">{doctor.name}</p>
                        <p className="text-xs text-gray-500">{doctor.patients} pasien</p>
                      </div>
                    </div>
                    <span className="text-sm font-semibold text-green-600">
                      {doctor.comprehension}%
                    </span>
                  </div>
                  <Progress value={doctor.comprehension} className="h-2" />
                </div>
              ))}
            </CardContent>
          </Card>

          {/* Anesthesia Distribution */}
          <Card>
            <CardHeader>
              <CardTitle>Distribusi Jenis Anestesi</CardTitle>
              <CardDescription>Total 156 pasien bulan ini</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {anesthesiaStats.map((item) => (
                <div key={item.type} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium">{item.type}</span>
                    <span className="text-sm text-gray-600">
                      {item.count} pasien ({item.percentage}%)
                    </span>
                  </div>
                  <Progress value={item.percentage * 3} className="h-2" />
                </div>
              ))}
            </CardContent>
          </Card>
        </div>

        {/* Recent Activity */}
        <Card>
          <CardHeader>
            <CardTitle>Aktivitas Terbaru</CardTitle>
            <CardDescription>Log sistem 24 jam terakhir</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {[
                { time: "2 jam lalu", text: "Dr. Ahmad menambahkan konten edukasi untuk Anestesi Spinal", type: "content" },
                { time: "4 jam lalu", text: "Pasien RM-2025-045 menyelesaikan kuis dengan skor 95%", type: "quiz" },
                { time: "5 jam lalu", text: "Dr. Siti mendaftarkan pasien baru untuk operasi cito", type: "patient" },
                { time: "7 jam lalu", text: "Pasien RM-2025-042 mengakses chatbot AI sebanyak 5 kali", type: "chatbot" },
              ].map((activity, index) => (
                <div key={index} className="flex items-start gap-3 pb-4 border-b last:border-0">
                  <div className={`w-2 h-2 rounded-full mt-2 ${
                    activity.type === 'content' ? 'bg-blue-500' :
                    activity.type === 'quiz' ? 'bg-green-500' :
                    activity.type === 'patient' ? 'bg-purple-500' : 'bg-orange-500'
                  }`} />
                  <div className="flex-1">
                    <p className="text-sm">{activity.text}</p>
                    <p className="text-xs text-gray-500 mt-1">{activity.time}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}