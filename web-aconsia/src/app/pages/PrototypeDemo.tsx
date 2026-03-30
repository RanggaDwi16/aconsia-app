import { useState } from "react";
import { Card, CardContent } from "../components/ui/card";
import { Button } from "../components/ui/button";
import { Badge } from "../components/ui/badge";
import { useNavigate } from "react-router";
import { CheckCircle, PlayCircle, RefreshCw } from "lucide-react";

type DemoStage = 
  | "start"
  | "register"
  | "pending"
  | "doctor_review"
  | "approved"
  | "reading"
  | "ai_chat"
  | "schedule"
  | "complete";

export function PrototypeDemo() {
  const navigate = useNavigate();
  const [stage, setStage] = useState<DemoStage>("start");
  const [comprehensionScore, setComprehensionScore] = useState(0);

  const stages = [
    { id: "start", label: "Mulai", completed: false },
    { id: "register", label: "Registrasi Pasien", completed: stage !== "start" },
    { id: "pending", label: "Status: Pending", completed: ["doctor_review", "approved", "reading", "ai_chat", "schedule", "complete"].includes(stage) },
    { id: "doctor_review", label: "Dokter Review & Approve", completed: ["approved", "reading", "ai_chat", "schedule", "complete"].includes(stage) },
    { id: "approved", label: "Dashboard Pasien", completed: ["reading", "ai_chat", "schedule", "complete"].includes(stage) },
    { id: "reading", label: "Membaca Materi", completed: ["ai_chat", "schedule", "complete"].includes(stage) },
    { id: "ai_chat", label: "Chat dengan AI", completed: ["schedule", "complete"].includes(stage) },
    { id: "schedule", label: "Jadwalkan Consent", completed: stage === "complete" },
    { id: "complete", label: "Selesai", completed: stage === "complete" },
  ];

  const handleStageAction = (nextStage: DemoStage) => {
    setStage(nextStage);
    
    // Update comprehension score based on stage
    switch(nextStage) {
      case "reading":
        setComprehensionScore(25);
        break;
      case "ai_chat":
        setComprehensionScore(60);
        break;
      case "schedule":
        setComprehensionScore(85);
        break;
      case "complete":
        setComprehensionScore(100);
        break;
    }
  };

  const resetDemo = () => {
    setStage("start");
    setComprehensionScore(0);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-blue-50 to-cyan-50">
      <div className="container mx-auto px-4 py-8 max-w-5xl">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="inline-block px-4 py-2 bg-purple-600 text-white rounded-full text-sm font-bold mb-4">
            🎬 PROTOTYPE DEMO MODE
          </div>
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            ACONSIA - Demo Walkthrough
          </h1>
          <p className="text-gray-600">
            Simulasi lengkap alur sistem dari awal hingga akhir
          </p>
        </div>

        {/* Progress Bar */}
        <Card className="mb-8 border-blue-200">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-3">
              <h3 className="font-bold text-gray-900">Progress Demo:</h3>
              <Button 
                variant="outline" 
                size="sm"
                onClick={resetDemo}
              >
                <RefreshCw className="w-4 h-4 mr-2" />
                Reset Demo
              </Button>
            </div>
            <div className="space-y-2">
              {stages.map((s, idx) => (
                <div key={s.id} className="flex items-center gap-3">
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${
                    s.completed 
                      ? "bg-green-600 text-white" 
                      : s.id === stage
                        ? "bg-blue-600 text-white animate-pulse"
                        : "bg-gray-200 text-gray-600"
                  }`}>
                    {s.completed ? <CheckCircle className="w-4 h-4" /> : idx + 1}
                  </div>
                  <div className="flex-1">
                    <p className={`text-sm font-medium ${
                      s.id === stage ? "text-blue-600" : s.completed ? "text-gray-900" : "text-gray-500"
                    }`}>
                      {s.label}
                    </p>
                  </div>
                  {s.id === stage && (
                    <Badge className="bg-blue-600">Sedang Berlangsung</Badge>
                  )}
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Comprehension Score Tracker */}
        {comprehensionScore > 0 && (
          <Card className="mb-8 border-green-200 bg-green-50">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-3">
                <div>
                  <p className="text-sm text-gray-700 font-semibold">Tingkat Pemahaman Pasien</p>
                  <p className="text-xs text-gray-600">Terupdate otomatis seiring progress</p>
                </div>
                <div className="text-right">
                  <p className="text-3xl font-bold text-green-600">{comprehensionScore}%</p>
                  <p className="text-xs text-gray-600">
                    {comprehensionScore >= 80 ? "✅ Siap" : `${80 - comprehensionScore}% lagi`}
                  </p>
                </div>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-3">
                <div 
                  className="bg-green-600 h-3 rounded-full transition-all duration-500"
                  style={{ width: `${comprehensionScore}%` }}
                />
              </div>
            </CardContent>
          </Card>
        )}

        {/* Stage Content */}
        <Card>
          <CardContent className="p-8">
            {stage === "start" && (
              <div className="text-center">
                <PlayCircle className="w-20 h-20 text-blue-600 mx-auto mb-4" />
                <h2 className="text-2xl font-bold mb-4">Selamat Datang di Demo ACONSIA</h2>
                <p className="text-gray-600 mb-6">
                  Demo ini akan memandu Anda melalui seluruh alur sistem, dari registrasi pasien 
                  hingga penjadwalan informed consent.
                </p>
                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 text-left">
                  <h3 className="font-bold text-blue-900 mb-2">Yang akan Anda lihat:</h3>
                  <ul className="text-sm text-blue-800 space-y-1">
                    <li>✅ Registrasi pasien dengan pilihan dokter</li>
                    <li>✅ Status pending menunggu approval dokter</li>
                    <li>✅ Dokter review & pilih jenis anestesi</li>
                    <li>✅ Dashboard pasien dengan progress tracking</li>
                    <li>✅ Membaca materi dengan scroll tracking</li>
                    <li>✅ AI Proaktif yang menanyakan pertanyaan</li>
                    <li>✅ Penjadwalan informed consent (saat progress ≥80%)</li>
                  </ul>
                </div>
                <Button 
                  size="lg"
                  className="bg-blue-600 hover:bg-blue-700"
                  onClick={() => handleStageAction("register")}
                >
                  Mulai Demo <PlayCircle className="w-5 h-5 ml-2" />
                </Button>
              </div>
            )}

            {stage === "register" && (
              <div>
                <h2 className="text-2xl font-bold mb-4">1. Registrasi Pasien</h2>
                <div className="space-y-4">
                  <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">Form Registrasi Lengkap:</h3>
                    <ul className="text-sm text-gray-700 space-y-1">
                      <li>📝 Data Pribadi (Nama, DOB, Gender, Phone, Email, Alamat)</li>
                      <li>👨‍⚕️ Pilih Dokter Anestesi (Dropdown)</li>
                      <li>🏥 Jenis Operasi yang Direncanakan</li>
                      <li>📅 Tanggal Operasi (Estimate)</li>
                      <li>🩺 Riwayat Medis Lengkap</li>
                      <li>⚠️ Alergi (Obat, Makanan, Lainnya)</li>
                      <li>💊 Obat yang Sedang Dikonsumsi</li>
                      <li>📊 Status ASA (I, II, III, IV, V)</li>
                    </ul>
                  </div>
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                    <p className="text-sm text-green-800">
                      <strong>✅ Identitas Lengkap:</strong> Seperti informed consent asli di rumah sakit, 
                      dengan MRN, emergency contact, dll.
                    </p>
                  </div>
                  <div className="flex gap-3">
                    <Button 
                      variant="outline"
                      onClick={() => navigate('/register')}
                    >
                      Lihat Form Registrasi Real
                    </Button>
                    <Button 
                      className="bg-blue-600 hover:bg-blue-700"
                      onClick={() => handleStageAction("pending")}
                    >
                      Lanjut ke Status Pending →
                    </Button>
                  </div>
                </div>
              </div>
            )}

            {stage === "pending" && (
              <div>
                <h2 className="text-2xl font-bold mb-4">2. Status: Pending Approval</h2>
                <div className="space-y-4">
                  <Card className="border-orange-200 bg-orange-50">
                    <CardContent className="p-6 text-center">
                      <div className="w-16 h-16 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-3">
                        ⏳
                      </div>
                      <h3 className="font-bold text-lg mb-2">
                        Data Teknik Anestesi Anda Belum Dipilih Oleh Dokter
                      </h3>
                      <p className="text-sm text-gray-700">
                        Silahkan tunggu dokter mengkonfirmasi teknik anestesi anda / 
                        hubungi dokter yang berwenang untuk mengkonfirmasi teknik anestesi anda.
                      </p>
                    </CardContent>
                  </Card>
                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <p className="text-sm text-blue-800">
                      <strong>💡 Catatan:</strong> Pasien tidak bisa akses materi pembelajaran 
                      sebelum dokter memilih jenis anestesi yang sesuai.
                    </p>
                  </div>
                  <Button 
                    className="bg-blue-600 hover:bg-blue-700 w-full"
                    onClick={() => handleStageAction("doctor_review")}
                  >
                    Lanjut ke Dokter Review →
                  </Button>
                </div>
              </div>
            )}

            {stage === "doctor_review" && (
              <div>
                <h2 className="text-2xl font-bold mb-4">3. Dokter Review & Approve</h2>
                <div className="space-y-4">
                  <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-3">Dokter Melihat:</h3>
                    <div className="grid md:grid-cols-2 gap-4 text-sm">
                      <div>
                        <p className="font-medium text-gray-900">Identitas Pasien:</p>
                        <ul className="text-gray-700">
                          <li>• Nama: Ibu Sarah Wijaya</li>
                          <li>• Umur: 32 tahun</li>
                          <li>• MRN: 2026-001234</li>
                        </ul>
                      </div>
                      <div>
                        <p className="font-medium text-gray-900">Data Medis:</p>
                        <ul className="text-gray-700">
                          <li>• Operasi: Sectio Caesarea</li>
                          <li>• Riwayat: Sehat</li>
                          <li>• Status ASA: I</li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div className="bg-green-50 border border-green-200 rounded-lg p-6">
                    <h3 className="font-semibold mb-3">Dokter Memilih Jenis Anestesi:</h3>
                    <div className="bg-white border border-green-300 rounded p-3 mb-3">
                      <select className="w-full p-2 border rounded">
                        <option value="">-- Pilih Jenis Anestesi --</option>
                        <option value="general">Anestesi Umum</option>
                        <option value="spinal" selected>Anestesi Spinal ✓</option>
                        <option value="epidural">Anestesi Epidural</option>
                        <option value="regional">Anestesi Regional</option>
                        <option value="local">Anestesi Lokal + Sedasi</option>
                      </select>
                    </div>
                    <p className="text-sm text-green-800 mb-3">
                      ✅ Dokter memilih: <strong>Anestesi Spinal</strong>
                    </p>
                    <div className="flex gap-2">
                      <button className="flex-1 bg-green-600 text-white px-4 py-2 rounded font-semibold hover:bg-green-700">
                        ✓ ACC & Pilih Anestesi
                      </button>
                      <button className="px-4 py-2 border border-red-600 text-red-600 rounded font-semibold hover:bg-red-50">
                        ✗ Reject
                      </button>
                    </div>
                  </div>
                  <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
                    <p className="text-sm text-purple-800">
                      <strong>🎯 Filtering Otomatis:</strong> Sistem akan otomatis filter konten 
                      edukasi sesuai jenis anestesi yang dipilih (Anestesi Spinal).
                    </p>
                  </div>
                  <div className="flex gap-3">
                    <Button 
                      variant="outline"
                      onClick={() => navigate('/doctor/approval')}
                    >
                      Lihat Halaman Dokter Real
                    </Button>
                    <Button 
                      className="bg-blue-600 hover:bg-blue-700"
                      onClick={() => handleStageAction("approved")}
                    >
                      Lanjut ke Dashboard Pasien →
                    </Button>
                  </div>
                </div>
              </div>
            )}

            {stage === "approved" && (
              <div>
                <h2 className="text-2xl font-bold mb-4">4. Dashboard Pasien (Approved)</h2>
                <div className="space-y-4">
                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">Tingkat Pemahaman: 0%</h3>
                    <div className="w-full bg-gray-200 rounded-full h-3 mb-2">
                      <div className="bg-blue-600 h-3 rounded-full" style={{ width: "0%" }} />
                    </div>
                    <p className="text-sm text-gray-700">
                      📌 Pasien belum mulai belajar, jadi score masih 0%
                    </p>
                  </div>

                  <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">🤖 Rekomendasi AI:</h3>
                    <p className="text-sm text-gray-700 mb-3">
                      "Berdasarkan progress membaca, kami merekomendasikan materi:"
                    </p>
                    <div className="bg-white border rounded p-3">
                      <p className="font-medium">📖 Pengenalan Anestesi Spinal</p>
                      <p className="text-sm text-gray-600">Progress: 0% • Belum dibaca</p>
                      <Button size="sm" className="mt-2 w-full bg-blue-600">
                        Mulai
                      </Button>
                    </div>
                  </div>

                  <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">📚 Materi Pembelajaran (Filtered):</h3>
                    <ul className="text-sm text-gray-700 space-y-1">
                      <li>✅ Hanya materi <strong>Anestesi Spinal</strong></li>
                      <li>✅ Progress tracking per materi (0-100%)</li>
                      <li>✅ Estimasi waktu baca</li>
                    </ul>
                  </div>

                  <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">🔒 Jadwal Informed Consent:</h3>
                    <p className="text-sm text-gray-700">
                      Selesaikan pembelajaran minimal <strong>80%</strong> untuk dapat menjadwalkan 
                      informed consent
                    </p>
                  </div>

                  <div className="flex gap-3">
                    <Button 
                      variant="outline"
                      onClick={() => navigate('/patient')}
                    >
                      Lihat Dashboard Real
                    </Button>
                    <Button 
                      className="bg-blue-600 hover:bg-blue-700"
                      onClick={() => handleStageAction("reading")}
                    >
                      Mulai Membaca Materi →
                    </Button>
                  </div>
                </div>
              </div>
            )}

            {stage === "reading" && (
              <div>
                <h2 className="text-2xl font-bold mb-4">5. Membaca Materi (Scroll Tracking)</h2>
                <div className="space-y-4">
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">✅ Fitur Reading Material:</h3>
                    <ul className="text-sm text-gray-700 space-y-1">
                      <li>📚 Pure text/article (NO VIDEO)</li>
                      <li>📊 Auto scroll detection untuk tracking progress</li>
                      <li>⏱️ Time spent counter (real-time)</li>
                      <li>📈 Progress bar 0-100% di sticky header</li>
                      <li>✅ Badge "Selesai" saat scroll 100%</li>
                    </ul>
                  </div>

                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">Progress Setelah Membaca:</h3>
                    <p className="text-sm text-gray-700 mb-2">
                      Tingkat Pemahaman: <strong>0% → 25%</strong>
                    </p>
                    <div className="w-full bg-gray-200 rounded-full h-3">
                      <div className="bg-blue-600 h-3 rounded-full transition-all" style={{ width: "25%" }} />
                    </div>
                  </div>

                  <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                    <p className="text-sm text-yellow-800">
                      <strong>💡 Catatan:</strong> Scroll tracking otomatis mendeteksi 
                      seberapa jauh pasien membaca. Tidak bisa "skip" atau curang.
                    </p>
                  </div>

                  <div className="flex gap-3">
                    <Button 
                      variant="outline"
                      onClick={() => navigate('/patient/material/1')}
                    >
                      Lihat Material Reader Real
                    </Button>
                    <Button 
                      className="bg-blue-600 hover:bg-blue-700"
                      onClick={() => handleStageAction("ai_chat")}
                    >
                      Lanjut ke AI Chat →
                    </Button>
                  </div>
                </div>
              </div>
            )}

            {stage === "ai_chat" && (
              <div>
                <h2 className="text-2xl font-bold mb-4">6. Chat dengan AI Proaktif</h2>
                <div className="space-y-4">
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">🤖 AI Yang Menanyakan (Bukan Pasien!):</h3>
                    <div className="space-y-3 text-sm">
                      <div className="bg-white border rounded-lg p-3">
                        <p className="font-medium text-green-700 mb-1">AI:</p>
                        <p className="text-gray-700">
                          "Halo! Saya lihat Anda sudah membaca materi. Coba ceritakan 
                          dengan kata-kata sendiri: Apa yang Anda pahami tentang anestesi spinal?"
                        </p>
                      </div>
                      <div className="bg-blue-600 text-white rounded-lg p-3 ml-8">
                        <p className="font-medium mb-1">Pasien:</p>
                        <p>
                          "Anestesi spinal adalah..."
                        </p>
                      </div>
                      <div className="bg-white border rounded-lg p-3">
                        <p className="font-medium text-green-700 mb-1">AI:</p>
                        <p className="text-gray-700">
                          "Bagus! ✅ Sekarang, mengapa posisi pasien saat pemberian 
                          anestesi spinal sangat penting?"
                        </p>
                      </div>
                    </div>
                  </div>

                  <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">💡 AI Recommendations:</h3>
                    <p className="text-sm text-gray-700 mb-2">
                      Jika AI deteksi jawaban lemah:
                    </p>
                    <div className="bg-white border rounded p-3 text-sm">
                      <p className="text-purple-800">
                        "Hmm, sepertinya ada kebingungan. Saya rekomendasikan 
                        baca materi <strong>'Prosedur Pemberian Anestesi Spinal'</strong> 
                        dulu."
                      </p>
                    </div>
                  </div>

                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">Progress Setelah Chat:</h3>
                    <p className="text-sm text-gray-700 mb-2">
                      Tingkat Pemahaman: <strong>25% → 60%</strong>
                    </p>
                    <div className="w-full bg-gray-200 rounded-full h-3">
                      <div className="bg-blue-600 h-3 rounded-full transition-all" style={{ width: "60%" }} />
                    </div>
                  </div>

                  <div className="flex gap-3">
                    <Button 
                      variant="outline"
                      onClick={() => navigate('/patient/chat')}
                    >
                      Lihat AI Chat Real
                    </Button>
                    <Button 
                      className="bg-blue-600 hover:bg-blue-700"
                      onClick={() => handleStageAction("schedule")}
                    >
                      Lanjut ke Schedule (≥80%) →
                    </Button>
                  </div>
                </div>
              </div>
            )}

            {stage === "schedule" && (
              <div>
                <h2 className="text-2xl font-bold mb-4">7. Jadwalkan Informed Consent</h2>
                <div className="space-y-4">
                  <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">✅ Pasien Sudah Siap!</h3>
                    <p className="text-sm text-gray-700 mb-2">
                      Tingkat Pemahaman: <strong>85%</strong> (≥80%)
                    </p>
                    <div className="w-full bg-gray-200 rounded-full h-3">
                      <div className="bg-green-600 h-3 rounded-full transition-all" style={{ width: "85%" }} />
                    </div>
                  </div>

                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-3">📅 Pilih Jadwal Konsultasi:</h3>
                    <div className="space-y-2 text-sm">
                      <div className="bg-white border rounded p-3">
                        <p className="font-medium">📍 Lokasi:</p>
                        <p className="text-gray-700">Ruang Konsultasi Anestesi, RS Graha Medika</p>
                      </div>
                      <div className="bg-white border rounded p-3">
                        <p className="font-medium">👨‍⚕️ Dokter:</p>
                        <p className="text-gray-700">Dr. Ahmad Suryadi, Sp.An</p>
                      </div>
                      <div className="bg-white border rounded p-3">
                        <p className="font-medium">📆 Tanggal:</p>
                        <input type="date" className="w-full p-2 border rounded mt-1" />
                      </div>
                      <div className="bg-white border rounded p-3">
                        <p className="font-medium">🕒 Waktu:</p>
                        <select className="w-full p-2 border rounded mt-1">
                          <option>08:00 - 08:45 ✅</option>
                          <option>10:00 - 10:45 ✅</option>
                          <option>14:00 - 14:45 ❌ (Booked)</option>
                        </select>
                      </div>
                    </div>
                  </div>

                  <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
                    <h3 className="font-semibold mb-2">📧 Konfirmasi Otomatis:</h3>
                    <ul className="text-sm text-gray-700 space-y-1">
                      <li>✅ Email confirmation ke pasien & dokter</li>
                      <li>✅ SMS reminder H-1</li>
                      <li>✅ Calendar invite (.ical)</li>
                    </ul>
                  </div>

                  <Button 
                    className="bg-blue-600 hover:bg-blue-700 w-full"
                    onClick={() => handleStageAction("complete")}
                  >
                    Konfirmasi Jadwal & Selesai →
                  </Button>
                </div>
              </div>
            )}

            {stage === "complete" && (
              <div className="text-center">
                <div className="w-20 h-20 bg-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                  <CheckCircle className="w-12 h-12 text-white" />
                </div>
                <h2 className="text-3xl font-bold text-green-600 mb-4">
                  🎉 Demo Selesai!
                </h2>
                <p className="text-gray-700 mb-6">
                  Anda telah melihat seluruh alur sistem ACONSIA dari awal hingga akhir.
                </p>

                <div className="bg-green-50 border border-green-200 rounded-lg p-6 mb-6 text-left">
                  <h3 className="font-bold text-green-900 mb-3">📊 Summary:</h3>
                  <div className="space-y-2 text-sm text-gray-700">
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>Pasien daftar dengan data lengkap</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>Dokter review & pilih jenis anestesi (Spinal)</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>Konten otomatis di-filter sesuai jenis anestesi</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>Pasien baca materi (scroll tracking: 0% → 25%)</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>AI proaktif menanyakan pertanyaan (25% → 60%)</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>AI rekomendasikan materi jika ada weak areas (60% → 85%)</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>Jadwalkan informed consent (≥80% unlocked)</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-green-600" />
                      <span>Konfirmasi otomatis via email & SMS</span>
                    </div>
                  </div>
                </div>

                <div className="flex gap-3 justify-center">
                  <Button 
                    variant="outline"
                    onClick={resetDemo}
                  >
                    <RefreshCw className="w-4 h-4 mr-2" />
                    Ulangi Demo
                  </Button>
                  <Button 
                    className="bg-blue-600 hover:bg-blue-700"
                    onClick={() => navigate('/')}
                  >
                    Kembali ke Home
                  </Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Navigation Help */}
        {stage !== "start" && stage !== "complete" && (
          <Card className="mt-6 border-gray-200 bg-gray-50">
            <CardContent className="p-4 text-center">
              <p className="text-sm text-gray-600">
                💡 <strong>Tip:</strong> Anda juga bisa klik tombol "Lihat ... Real" 
                untuk melihat halaman aktual aplikasi
              </p>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}
