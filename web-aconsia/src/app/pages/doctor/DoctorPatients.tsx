import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../../components/ui/select";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "../../components/ui/dialog";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "../../components/ui/table";
import { Badge } from "../../components/ui/badge";
import { Progress } from "../../components/ui/progress";
import { Plus, Search, Eye, TrendingUp } from "lucide-react";
import { useState } from "react";

export function DoctorPatients() {
  const [searchQuery, setSearchQuery] = useState("");
  const [filterType, setFilterType] = useState("all");

  const patients = [
    {
      id: "1",
      name: "Ibu Sarah Wijaya",
      mrn: "RM-2025-045",
      surgery: "Operasi Caesar",
      anesthesia: "Spinal",
      comprehension: 95,
      status: "Siap",
      scheduledDate: "8 Mar 2026",
      quizzesTaken: 3,
      educationProgress: 100
    },
    {
      id: "2",
      name: "Bapak Andi Pratama",
      mrn: "RM-2025-044",
      surgery: "Appendectomy",
      anesthesia: "Umum",
      comprehension: 88,
      status: "Edukasi",
      scheduledDate: "8 Mar 2026",
      quizzesTaken: 2,
      educationProgress: 75
    },
    {
      id: "3",
      name: "Ibu Dewi Lestari",
      mrn: "RM-2025-043",
      surgery: "Operasi Tulang",
      anesthesia: "Regional",
      comprehension: 78,
      status: "Follow-up",
      scheduledDate: "9 Mar 2026",
      quizzesTaken: 2,
      educationProgress: 60
    },
    {
      id: "4",
      name: "Bapak Joko Susilo",
      mrn: "RM-2025-042",
      surgery: "Operasi Hernia",
      anesthesia: "Epidural",
      comprehension: 92,
      status: "Siap",
      scheduledDate: "10 Mar 2026",
      quizzesTaken: 3,
      educationProgress: 100
    },
  ];

  const getStatusColor = (status: string) => {
    if (status === "Siap") return "bg-green-100 text-green-700";
    if (status === "Edukasi") return "bg-blue-100 text-blue-700";
    return "bg-yellow-100 text-yellow-700";
  };

  return (
    <DashboardLayout role="doctor" userName="Dr. Ahmad Suryadi, Sp.An">
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Kelola Pasien</h1>
            <p className="text-gray-600 mt-1">Monitoring pemahaman dan kesiapan pasien</p>
          </div>
          
          <Dialog>
            <DialogTrigger asChild>
              <Button className="bg-blue-600 hover:bg-blue-700 gap-2">
                <Plus className="w-4 h-4" />
                Tambah Pasien
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
              <DialogHeader>
                <DialogTitle>Tambah Pasien Baru</DialogTitle>
                <DialogDescription>
                  Masukkan data pasien dan informasi prosedur anestesi
                </DialogDescription>
              </DialogHeader>
              
              <div className="space-y-4 py-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="patientName">Nama Lengkap Pasien</Label>
                    <Input id="patientName" placeholder="Nama lengkap" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="mrn">No. Rekam Medis</Label>
                    <Input id="mrn" placeholder="RM-2025-XXX" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="nik">NIK</Label>
                    <Input id="nik" placeholder="16 digit NIK" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="dob">Tanggal Lahir</Label>
                    <Input id="dob" type="date" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="gender">Jenis Kelamin</Label>
                    <Select>
                      <SelectTrigger id="gender">
                        <SelectValue placeholder="Pilih jenis kelamin" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="male">Laki-laki</SelectItem>
                        <SelectItem value="female">Perempuan</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="phone">No. WhatsApp</Label>
                    <Input id="phone" placeholder="+62" />
                  </div>
                </div>

                <div className="pt-4 border-t">
                  <h3 className="font-semibold mb-4">Informasi Prosedur</h3>
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="surgery">Jenis Operasi</Label>
                      <Input id="surgery" placeholder="Contoh: Appendectomy" />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="anesthesia">Teknik Anestesi</Label>
                      <Select>
                        <SelectTrigger id="anesthesia">
                          <SelectValue placeholder="Pilih jenis anestesi" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="general">Anestesi Umum</SelectItem>
                          <SelectItem value="spinal">Anestesi Spinal</SelectItem>
                          <SelectItem value="epidural">Anestesi Epidural</SelectItem>
                          <SelectItem value="regional">Anestesi Regional</SelectItem>
                          <SelectItem value="local">Anestesi Lokal</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="scheduledDate">Tanggal Terjadwal</Label>
                      <Input id="scheduledDate" type="datetime-local" />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="asa">Status ASA</Label>
                      <Select>
                        <SelectTrigger id="asa">
                          <SelectValue placeholder="Pilih ASA" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="I">ASA I</SelectItem>
                          <SelectItem value="II">ASA II</SelectItem>
                          <SelectItem value="III">ASA III</SelectItem>
                          <SelectItem value="IV">ASA IV</SelectItem>
                          <SelectItem value="V">ASA V</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                </div>

                <div className="pt-4 border-t">
                  <h3 className="font-semibold mb-4">Data Wali Pasien (Opsional)</h3>
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="guardianName">Nama Wali</Label>
                      <Input id="guardianName" placeholder="Nama lengkap wali" />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="guardianRelation">Hubungan</Label>
                      <Input id="guardianRelation" placeholder="Contoh: Suami, Istri" />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="guardianPhone">No. HP Wali</Label>
                      <Input id="guardianPhone" placeholder="+62" />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="guardianEmail">Email Wali</Label>
                      <Input id="guardianEmail" type="email" placeholder="email@contoh.com" />
                    </div>
                  </div>
                </div>

                <div className="flex justify-end gap-2 pt-4">
                  <Button variant="outline">Batal</Button>
                  <Button className="bg-blue-600 hover:bg-blue-700">Simpan Pasien</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        </div>

        {/* Filters */}
        <Card>
          <CardContent className="pt-6">
            <div className="flex gap-4">
              <div className="flex-1 relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <Input
                  placeholder="Cari pasien berdasarkan nama atau No. RM..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10"
                />
              </div>
              <Select value={filterType} onValueChange={setFilterType}>
                <SelectTrigger className="w-48">
                  <SelectValue placeholder="Filter jenis anestesi" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Semua Jenis</SelectItem>
                  <SelectItem value="general">Anestesi Umum</SelectItem>
                  <SelectItem value="spinal">Anestesi Spinal</SelectItem>
                  <SelectItem value="epidural">Anestesi Epidural</SelectItem>
                  <SelectItem value="regional">Anestesi Regional</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </CardContent>
        </Card>

        {/* Patients Table */}
        <Card>
          <CardHeader>
            <CardTitle>Daftar Pasien</CardTitle>
            <CardDescription>Total {patients.length} pasien aktif</CardDescription>
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
                {patients.map((patient) => (
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
                    <TableCell className="text-sm">{patient.scheduledDate}</TableCell>
                    <TableCell>
                      <div className="space-y-1 min-w-[120px]">
                        <div className="flex items-center justify-between text-xs">
                          <span>{patient.educationProgress}%</span>
                          <span className="text-gray-500">{patient.quizzesTaken} kuis</span>
                        </div>
                        <Progress value={patient.educationProgress} className="h-2" />
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <TrendingUp className={`w-4 h-4 ${
                          patient.comprehension >= 90 ? 'text-green-500' : 
                          patient.comprehension >= 80 ? 'text-yellow-500' : 'text-red-500'
                        }`} />
                        <span className="font-semibold">{patient.comprehension}%</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge className={getStatusColor(patient.status)}>
                        {patient.status}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <Button variant="outline" size="sm" className="gap-2">
                        <Eye className="w-4 h-4" />
                        Detail
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}
