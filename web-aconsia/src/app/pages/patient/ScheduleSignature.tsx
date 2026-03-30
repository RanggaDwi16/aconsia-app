import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Card, CardContent } from "../../components/ui/card";
import { Calendar, Clock, CheckCircle, ArrowLeft } from "lucide-react";
import { toast } from "sonner";

export function ScheduleSignature() {
  const navigate = useNavigate();
  const [patientData, setPatientData] = useState<any>(null);
  const [selectedDate, setSelectedDate] = useState("");
  const [selectedTime, setSelectedTime] = useState("");

  useEffect(() => {
    const currentPatient = localStorage.getItem("currentPatient");
    if (currentPatient) {
      const data = JSON.parse(currentPatient);
      setPatientData(data);
      if (data.scheduledSignatureDate) {
        setSelectedDate(data.scheduledSignatureDate);
        setSelectedTime(data.scheduledSignatureTime || "");
      }
    }
  }, []);

  const handleSave = () => {
    if (!selectedDate || !selectedTime) {
      toast.error("Mohon pilih tanggal dan waktu");
      return;
    }

    const updatedPatient = {
      ...patientData,
      scheduledSignatureDate: selectedDate,
      scheduledSignatureTime: selectedTime,
    };

    localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
    toast.success("Jadwal tanda tangan berhasil disimpan!");
    
    setTimeout(() => {
      navigate("/patient/dashboard-new");
    }, 1000);
  };

  if (!patientData) {
    return null;
  }

  const comprehensionScore = patientData.comprehensionScore || 0;

  if (comprehensionScore < 80) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center p-6">
        <Card className="max-w-md">
          <CardContent className="p-8 text-center">
            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Clock className="w-8 h-8 text-red-600" />
            </div>
            <h2 className="text-xl font-bold text-gray-900 mb-2">Belum Memenuhi Syarat</h2>
            <p className="text-gray-600 mb-6">
              Anda perlu mencapai pemahaman minimal 80% sebelum dapat menjadwalkan tanda tangan. 
              Saat ini: {comprehensionScore}%
            </p>
            <Button onClick={() => navigate("/patient/dashboard-new")} variant="outline" className="w-full">
              Kembali ke Dashboard
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="bg-white border-b border-gray-200">
        <div className="container mx-auto px-6 py-4">
          <Button 
            variant="ghost" 
            onClick={() => navigate("/patient/dashboard-new")}
            className="mb-2"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Kembali
          </Button>
          <h1 className="text-2xl font-bold text-gray-900">Jadwal Tanda Tangan</h1>
          <p className="text-sm text-gray-600 mt-1">Informed Consent Anestesi</p>
        </div>
      </div>

      <div className="container mx-auto px-6 py-8 max-w-2xl">
        <Card>
          <CardContent className="p-8">
            <div className="mb-6">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <CheckCircle className="w-8 h-8 text-green-600" />
              </div>
              <h2 className="text-center text-xl font-bold text-gray-900 mb-2">
                Selamat! Anda Sudah Memenuhi Syarat
              </h2>
              <p className="text-center text-gray-600">
                Pemahaman Anda: <span className="font-bold text-green-600">{comprehensionScore}%</span>
              </p>
            </div>

            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
              <p className="text-sm text-blue-900">
                💡 <strong>Catatan:</strong> Tanda tangan informed consent akan dilakukan secara fisik di rumah sakit. 
                Silakan pilih tanggal dan waktu yang sesuai dengan jadwal Anda.
              </p>
            </div>

            <div className="space-y-6">
              <div className="space-y-2">
                <Label htmlFor="date" className="flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-gray-600" />
                  Tanggal
                </Label>
                <Input
                  id="date"
                  type="date"
                  value={selectedDate}
                  onChange={(e) => setSelectedDate(e.target.value)}
                  min={new Date().toISOString().split("T")[0]}
                  className="text-lg"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="time" className="flex items-center gap-2">
                  <Clock className="w-4 h-4 text-gray-600" />
                  Waktu
                </Label>
                <Input
                  id="time"
                  type="time"
                  value={selectedTime}
                  onChange={(e) => setSelectedTime(e.target.value)}
                  className="text-lg"
                />
              </div>

              <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                <h3 className="font-semibold text-gray-900 mb-3">Info Operasi Anda</h3>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between">
                    <span className="text-gray-600">Jenis Operasi:</span>
                    <span className="font-medium text-gray-900">{patientData.surgeryType}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-600">Tanggal Operasi:</span>
                    <span className="font-medium text-gray-900">
                      {new Date(patientData.surgeryDate).toLocaleDateString('id-ID')}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-600">Rumah Sakit:</span>
                    <span className="font-medium text-gray-900">{patientData.hospitalName}</span>
                  </div>
                </div>
              </div>

              <div className="flex gap-3">
                <Button
                  variant="outline"
                  onClick={() => navigate("/patient/dashboard-new")}
                  className="flex-1"
                >
                  Batal
                </Button>
                <Button
                  onClick={handleSave}
                  className="flex-1 bg-green-600 hover:bg-green-700"
                >
                  Simpan Jadwal
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
