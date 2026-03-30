import { useState } from "react";
import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "../../components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../../components/ui/select";
import { Label } from "../../components/ui/label";
import { Textarea } from "../../components/ui/textarea";
import { toast } from "sonner";
import { UserCheck, Clock, CheckCircle, XCircle, FileText, AlertCircle } from "lucide-react";

interface PendingPatient {
  id: string;
  name: string;
  age: number;
  gender: string;
  mrn: string;
  registrationDate: string;
  plannedSurgery: string;
  surgeryDate: string;
  medicalHistory: string;
  allergies: string;
  currentMedications: string;
  asaStatus: string;
  status: "pending" | "approved" | "rejected";
}

export function PatientApproval() {
  const [selectedPatient, setSelectedPatient] = useState<PendingPatient | null>(null);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedAnesthesia, setSelectedAnesthesia] = useState("");
  const [notes, setNotes] = useState("");

  const [patients, setPatients] = useState<PendingPatient[]>([
    {
      id: "1",
      name: "Ibu Sarah Wijaya",
      age: 32,
      gender: "Perempuan",
      mrn: "RM-2026-001",
      registrationDate: "2026-03-06",
      plannedSurgery: "Operasi Caesar (C-Section)",
      surgeryDate: "2026-03-15",
      medicalHistory: "Kehamilan pertama, tidak ada riwayat penyakit kronis",
      allergies: "Tidak ada alergi yang diketahui",
      currentMedications: "Vitamin prenatal, asam folat",
      asaStatus: "ASA I",
      status: "pending",
    },
    {
      id: "2",
      name: "Bapak Andi Pratama",
      age: 45,
      gender: "Laki-laki",
      mrn: "RM-2026-002",
      registrationDate: "2026-03-06",
      plannedSurgery: "Appendektomi (Operasi Usus Buntu)",
      surgeryDate: "2026-03-08",
      medicalHistory: "Hipertensi terkontrol sejak 2 tahun lalu",
      allergies: "Alergi seafood",
      currentMedications: "Amlodipine 5mg 1x1",
      asaStatus: "ASA II",
      status: "pending",
    },
    {
      id: "3",
      name: "Ibu Dewi Kusuma",
      age: 58,
      gender: "Perempuan",
      mrn: "RM-2026-003",
      registrationDate: "2026-03-05",
      plannedSurgery: "Operasi Katarak Mata Kanan",
      surgeryDate: "2026-03-12",
      medicalHistory: "Diabetes Mellitus tipe 2, terkontrol dengan obat",
      allergies: "Tidak ada",
      currentMedications: "Metformin 500mg 2x1, Glimepiride 2mg 1x1",
      asaStatus: "ASA II",
      status: "pending",
    },
  ]);

  const anesthesiaTypes = [
    { value: "general", label: "Anestesi Umum (General Anesthesia)", description: "Pasien tidak sadar, untuk operasi besar" },
    { value: "spinal", label: "Anestesi Spinal", description: "Injeksi di tulang belakang, untuk operasi bawah pusar" },
    { value: "epidural", label: "Anestesi Epidural", description: "Injeksi di ruang epidural, fleksibel untuk persalinan" },
    { value: "regional", label: "Anestesi Regional", description: "Blok saraf untuk area tertentu" },
    { value: "local", label: "Anestesi Lokal + Sedasi", description: "Untuk prosedur kecil dengan sedasi ringan" },
  ];

  const handleApprove = (patient: PendingPatient) => {
    setSelectedPatient(patient);
    setIsDialogOpen(true);
  };

  const handleConfirmApproval = () => {
    if (!selectedAnesthesia) {
      toast.error("Pilih jenis anestesi terlebih dahulu");
      return;
    }

    if (!selectedPatient) return;

    // Update patient status and save anesthesia type
    setPatients(prev => prev.map(p => 
      p.id === selectedPatient.id 
        ? { ...p, status: "approved" as const, anesthesiaType: selectedAnesthesia }
        : p
    ));

    // Save to localStorage for patient access
    const approvedPatientData = {
      ...selectedPatient,
      status: "approved",
      anesthesiaType: selectedAnesthesia,
      doctorNotes: notes,
      approvalDate: new Date().toISOString(),
    };
    
    localStorage.setItem(`patient-${selectedPatient.id}`, JSON.stringify(approvedPatientData));
    
    // Also update currentPatient if this is the active patient
    const currentPatient = localStorage.getItem("currentPatient");
    if (currentPatient) {
      const current = JSON.parse(currentPatient);
      if (current.mrn === selectedPatient.mrn) {
        localStorage.setItem("currentPatient", JSON.stringify({
          ...current,
          status: "approved",
          anesthesiaType: selectedAnesthesia,
          doctorNotes: notes,
        }));
      }
    }

    toast.success(`Pasien ${selectedPatient.name} disetujui dengan ${anesthesiaTypes.find(a => a.value === selectedAnesthesia)?.label}`);
    setIsDialogOpen(false);
    setSelectedAnesthesia("");
    setNotes("");
  };

  const handleReject = (patientId: string) => {
    if (confirm("Apakah Anda yakin ingin menolak pasien ini?")) {
      setPatients(patients.map(p => 
        p.id === patientId 
          ? { ...p, status: "rejected" as const }
          : p
      ));
      toast.error("Pasien ditolak");
    }
  };

  const pendingPatients = patients.filter(p => p.status === "pending");
  const approvedPatients = patients.filter(p => p.status === "approved");

  return (
    <DashboardLayout role="doctor" userName="Dr. Ahmad Suryadi, Sp.An">
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center">
              <UserCheck className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Persetujuan Pasien</h1>
              <p className="text-gray-600 mt-1">Review dan tentukan jenis anestesi untuk pasien baru</p>
            </div>
          </div>
          <div className="text-right">
            <div className="text-3xl font-bold text-orange-600">{pendingPatients.length}</div>
            <div className="text-sm text-gray-600">Menunggu Persetujuan</div>
          </div>
        </div>

        {/* Statistics */}
        <div className="grid md:grid-cols-3 gap-4">
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">Menunggu Review</p>
                  <p className="text-2xl font-bold text-orange-600">{pendingPatients.length}</p>
                </div>
                <Clock className="w-8 h-8 text-orange-600" />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">Disetujui</p>
                  <p className="text-2xl font-bold text-green-600">{approvedPatients.length}</p>
                </div>
                <CheckCircle className="w-8 h-8 text-green-600" />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">Total Pasien Hari Ini</p>
                  <p className="text-2xl font-bold text-blue-600">{patients.length}</p>
                </div>
                <FileText className="w-8 h-8 text-blue-600" />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Pending Patients */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Clock className="w-5 h-5 text-orange-600" />
              Pasien Menunggu Persetujuan
            </CardTitle>
            <CardDescription>Pasien baru yang perlu di-review dan ditentukan jenis anestesinya</CardDescription>
          </CardHeader>
          <CardContent>
            {pendingPatients.length === 0 ? (
              <div className="text-center py-8 text-gray-500">
                <CheckCircle className="w-12 h-12 mx-auto mb-3 text-gray-300" />
                <p>Tidak ada pasien yang menunggu persetujuan</p>
              </div>
            ) : (
              <div className="space-y-4">
                {pendingPatients.map((patient) => (
                  <Card key={patient.id} className="border-orange-200">
                    <CardContent className="p-6">
                      <div className="flex items-start justify-between mb-4">
                        <div>
                          <div className="flex items-center gap-2">
                            <h3 className="text-lg font-semibold">{patient.name}</h3>
                            <Badge variant="secondary">{patient.age} tahun</Badge>
                            <Badge variant="outline">{patient.gender}</Badge>
                          </div>
                          <p className="text-sm text-gray-600">No. RM: {patient.mrn}</p>
                          <p className="text-sm text-gray-600">Terdaftar: {new Date(patient.registrationDate).toLocaleDateString('id-ID')}</p>
                        </div>
                        <Badge className="bg-orange-100 text-orange-800">
                          <Clock className="w-3 h-3 mr-1" />
                          Pending
                        </Badge>
                      </div>

                      <div className="grid md:grid-cols-2 gap-4 mb-4">
                        <div>
                          <p className="text-sm font-semibold text-gray-700 mb-1">Jenis Operasi:</p>
                          <p className="text-sm text-gray-600">{patient.plannedSurgery}</p>
                        </div>
                        <div>
                          <p className="text-sm font-semibold text-gray-700 mb-1">Tanggal Operasi:</p>
                          <p className="text-sm text-gray-600">{new Date(patient.surgeryDate).toLocaleDateString('id-ID')}</p>
                        </div>
                      </div>

                      <div className="space-y-2 mb-4 p-4 bg-gray-50 rounded-lg">
                        <div>
                          <p className="text-sm font-semibold text-gray-700">Riwayat Medis:</p>
                          <p className="text-sm text-gray-600">{patient.medicalHistory}</p>
                        </div>
                        <div>
                          <p className="text-sm font-semibold text-gray-700">Alergi:</p>
                          <p className="text-sm text-gray-600">{patient.allergies}</p>
                        </div>
                        <div>
                          <p className="text-sm font-semibold text-gray-700">Obat Saat Ini:</p>
                          <p className="text-sm text-gray-600">{patient.currentMedications}</p>
                        </div>
                        <div>
                          <p className="text-sm font-semibold text-gray-700">Status ASA:</p>
                          <Badge variant="secondary">{patient.asaStatus}</Badge>
                        </div>
                      </div>

                      <div className="flex gap-2">
                        <Button 
                          onClick={() => handleApprove(patient)}
                          className="bg-green-600 hover:bg-green-700 flex-1"
                        >
                          <CheckCircle className="w-4 h-4 mr-2" />
                          Setujui & Pilih Anestesi
                        </Button>
                        <Button 
                          onClick={() => handleReject(patient.id)}
                          variant="outline"
                          className="text-red-600 border-red-300 hover:bg-red-50"
                        >
                          <XCircle className="w-4 h-4 mr-2" />
                          Tolak
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Approved Patients */}
        {approvedPatients.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-600" />
                Pasien yang Sudah Disetujui
              </CardTitle>
              <CardDescription>Pasien dapat mengakses materi edukasi yang sesuai</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {approvedPatients.map((patient) => (
                  <div key={patient.id} className="flex items-center justify-between p-4 bg-green-50 rounded-lg border border-green-200">
                    <div>
                      <p className="font-semibold">{patient.name}</p>
                      <p className="text-sm text-gray-600">{patient.plannedSurgery}</p>
                    </div>
                    <Badge className="bg-green-600">
                      <CheckCircle className="w-3 h-3 mr-1" />
                      Disetujui
                    </Badge>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}
      </div>

      {/* Approval Dialog */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Pilih Jenis Anestesi</DialogTitle>
            <DialogDescription>
              Tentukan jenis anestesi yang sesuai untuk {selectedPatient?.name}
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-6">
            {/* Patient Summary */}
            <div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
              <div className="flex items-start gap-3">
                <AlertCircle className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
                <div className="text-sm">
                  <p className="font-semibold text-blue-900 mb-1">Ringkasan Pasien:</p>
                  <ul className="text-blue-800 space-y-1">
                    <li>• <strong>Operasi:</strong> {selectedPatient?.plannedSurgery}</li>
                    <li>• <strong>Status ASA:</strong> {selectedPatient?.asaStatus}</li>
                    <li>• <strong>Riwayat:</strong> {selectedPatient?.medicalHistory}</li>
                  </ul>
                </div>
              </div>
            </div>

            {/* Anesthesia Selection */}
            <div className="space-y-2">
              <Label htmlFor="anesthesia">Jenis Anestesi *</Label>
              <Select value={selectedAnesthesia} onValueChange={setSelectedAnesthesia}>
                <SelectTrigger>
                  <SelectValue placeholder="Pilih jenis anestesi yang sesuai" />
                </SelectTrigger>
                <SelectContent>
                  {anesthesiaTypes.map((type) => (
                    <SelectItem key={type.value} value={type.value}>
                      <div>
                        <div className="font-semibold">{type.label}</div>
                        <div className="text-xs text-gray-500">{type.description}</div>
                      </div>
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {selectedAnesthesia && (
                <p className="text-sm text-gray-600 mt-2">
                  ✅ Konten edukasi <strong>{anesthesiaTypes.find(a => a.value === selectedAnesthesia)?.label}</strong> akan otomatis tersedia untuk pasien
                </p>
              )}
            </div>

            {/* Notes */}
            <div className="space-y-2">
              <Label htmlFor="notes">Catatan untuk Pasien (Opsional)</Label>
              <Textarea
                id="notes"
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                placeholder="Tambahkan catatan atau instruksi khusus untuk pasien..."
                rows={3}
              />
            </div>

            {/* Action Buttons */}
            <div className="flex gap-2 justify-end">
              <Button variant="outline" onClick={() => setIsDialogOpen(false)}>
                Batal
              </Button>
              <Button onClick={handleConfirmApproval} className="bg-green-600 hover:bg-green-700">
                <CheckCircle className="w-4 h-4 mr-2" />
                Konfirmasi Persetujuan
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </DashboardLayout>
  );
}