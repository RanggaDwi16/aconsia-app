import { useState, useEffect, useRef } from "react";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Progress } from "../../components/ui/progress";
import { useNavigate, useParams } from "react-router";
import { ArrowLeft, Clock, CheckCircle, BookOpen, TrendingUp } from "lucide-react";

interface MaterialContent {
  id: string;
  title: string;
  type: string;
  estimatedTime: string;
  sections: {
    id: string;
    title: string;
    content: string;
  }[];
}

export function MaterialReader() {
  const navigate = useNavigate();
  const { materialId } = useParams();
  const contentRef = useRef<HTMLDivElement>(null);
  
  const [readingProgress, setReadingProgress] = useState(0);
  const [timeSpent, setTimeSpent] = useState(0);
  const [isCompleted, setIsCompleted] = useState(false);
  const [currentSection, setCurrentSection] = useState(0);

  // Simulate material content
  const material: MaterialContent = {
    id: materialId || "1",
    title: "Pengenalan Anestesi Umum",
    type: "General Anesthesia",
    estimatedTime: "15 menit",
    sections: [
      {
        id: "1",
        title: "Apa Itu Anestesi Umum?",
        content: `Anestesi umum adalah prosedur medis yang membuat Anda tidak sadarkan diri sementara waktu selama operasi atau prosedur medis tertentu. Berbeda dengan anestesi lokal yang hanya membuat area tertentu mati rasa, anestesi umum mempengaruhi seluruh tubuh Anda.

Selama anestesi umum, Anda:
• Tidak sadar dan tidak merasakan sakit
• Tidak akan mengingat prosedur yang dilakukan
• Otot-otot tubuh menjadi rileks
• Refleks tubuh (seperti batuk) akan terhenti sementara

Anestesi umum sangat aman dan dilakukan oleh dokter spesialis anestesi (Sp.An) yang terlatih khusus. Dokter anestesi akan memantau kondisi Anda sepanjang waktu selama operasi.`,
      },
      {
        id: "2",
        title: "Bagaimana Cara Kerja Anestesi Umum?",
        content: `Anestesi umum bekerja dengan mempengaruhi sistem saraf pusat Anda, terutama otak dan sumsum tulang belakang. Obat-obatan anestesi akan:

1. Menghentikan sementara kemampuan otak untuk menerima dan memproses sinyal rasa sakit
2. Membuat Anda tidak sadarkan diri sehingga tidak mengalami trauma psikologis
3. Mengendurkan otot-otot sehingga dokter bedah dapat bekerja dengan lebih mudah
4. Mencegah pembentukan memori sehingga Anda tidak mengingat prosedur

Proses pemberian anestesi umum biasanya dilakukan melalui:
• Suntikan intravena (melalui infus) - bekerja dalam hitungan detik
• Gas anestesi yang dihirup melalui masker - bekerja dalam beberapa menit
• Atau kombinasi keduanya

Dokter anestesi akan memilih metode dan dosis yang paling sesuai untuk kondisi Anda.`,
      },
      {
        id: "3",
        title: "Tahapan Anestesi Umum",
        content: `Prosedur anestesi umum terdiri dari beberapa tahapan penting:

1. TAHAP PERSIAPAN (Pra-Anestesi)
   • Evaluasi kondisi kesehatan Anda
   • Diskusi tentang riwayat medis dan alergi
   • Penjelasan prosedur dan risiko
   • Instruksi puasa (biasanya 6-8 jam)

2. TAHAP INDUKSI (Memulai Anestesi)
   • Pemberian obat anestesi melalui infus atau gas
   • Anda akan mulai merasa mengantuk
   • Dalam beberapa detik/menit, Anda tidak sadarkan diri
   • Pemasangan alat bantu napas jika diperlukan

3. TAHAP PEMELIHARAAN (Maintenance)
   • Dokter anestesi terus memberikan obat anestesi
   • Pemantauan ketat terhadap tanda vital (tekanan darah, denyut jantung, saturasi oksigen)
   • Penyesuaian dosis sesuai kebutuhan
   • Durasi sesuai dengan lamanya operasi

4. TAHAP PEMULIHAN (Emergence)
   • Pemberian obat anestesi dihentikan
   • Anda akan mulai sadar secara bertahap
   • Pemindahan ke ruang pemulihan (recovery room)
   • Pemantauan hingga kondisi stabil`,
      },
      {
        id: "4",
        title: "Persiapan Sebelum Anestesi Umum",
        content: `Persiapan yang baik sangat penting untuk keamanan anestesi umum. Berikut hal-hal yang perlu Anda lakukan:

PUASA SEBELUM OPERASI:
• Makanan padat: minimal 6-8 jam sebelum operasi
• Cairan bening: boleh hingga 2 jam sebelum operasi
• Susu atau jus: minimal 6 jam sebelum operasi
• Alasan puasa: mencegah aspirasi (masuknya isi lambung ke paru-paru)

OBAT-OBATAN:
• Informasikan SEMUA obat yang Anda konsumsi
• Beberapa obat mungkin perlu dihentikan sementara (seperti pengencer darah)
• Beberapa obat penting tetap diminum (seperti obat jantung, tekanan darah)
• Ikuti instruksi dokter dengan tepat

HAL LAIN YANG PERLU DIPERSIAPKAN:
• Beri tahu dokter jika Anda merokok atau konsumsi alkohol
• Lepaskan semua perhiasan, lensa kontak, dan gigi palsu
• Jangan menggunakan makeup, cat kuku, atau losion
• Kenakan pakaian yang longgar dan nyaman
• Atur transportasi pulang (Anda tidak boleh menyetir setelah anestesi)

KONDISI KHUSUS:
• Kehamilan atau kemungkinan hamil
• Alergi obat atau makanan
• Gigi goyang atau gigi palsu
• Riwayat masalah dengan anestesi sebelumnya
• Kondisi medis lain (diabetes, asma, penyakit jantung, dll)`,
      },
      {
        id: "5",
        title: "Risiko dan Efek Samping",
        content: `Seperti prosedur medis lainnya, anestesi umum memiliki risiko dan efek samping. Namun, komplikasi serius sangat jarang terjadi.

EFEK SAMPING UMUM (Sering Terjadi):
• Mual dan muntah (20-30% pasien)
• Pusing dan kebingungan sementara
• Sakit tenggorokan (karena selang napas)
• Mulut kering
• Menggigil
• Rasa kantuk berkepanjangan
• Kebingungan ringan (terutama pada lansia)

RISIKO YANG LEBIH SERIUS (Jarang):
• Reaksi alergi terhadap obat anestesi
• Masalah pernapasan
• Perubahan tekanan darah atau detak jantung
• Kesadaran intra-operatif (awareness) - SANGAT JARANG
• Kerusakan gigi atau bibir
• Komplikasi paru-paru (pneumonia, aspirasi)

FAKTOR YANG MENINGKATKAN RISIKO:
• Usia lanjut (>70 tahun)
• Obesitas
• Merokok
• Sleep apnea
• Penyakit jantung atau paru-paru
• Diabetes
• Stroke atau penyakit neurologis
• Konsumsi alkohol berlebihan

Dokter anestesi Anda akan mengevaluasi semua faktor risiko ini dan mengambil langkah-langkah untuk meminimalkan kemungkinan komplikasi.`,
      },
      {
        id: "6",
        title: "Setelah Anestesi: Fase Pemulihan",
        content: `Setelah operasi selesai, Anda akan dipindahkan ke ruang pemulihan (recovery room) di mana tim medis akan memantau kondisi Anda.

DI RUANG PEMULIHAN:
• Pemantauan tanda vital (tekanan darah, nadi, pernapasan, suhu)
• Pemberian oksigen jika diperlukan
• Pengelolaan nyeri dengan obat-obatan
• Penanganan mual dan muntah jika terjadi
• Anda akan tetap di sini hingga kondisi stabil (biasanya 1-2 jam)

PROSES PULIH SADAR:
• Anda akan mulai sadar secara bertahap
• Mungkin merasa bingung atau disorientasi - ini normal
• Mulai dengan gerakan kecil (menggerakkan jari, membuka mata)
• Kemampuan berbicara dan bergerak akan kembali perlahan

GEJALA NORMAL SETELAH ANESTESI:
• Rasa lelah atau mengantuk (bisa berlangsung 24 jam)
• Sedikit mual atau tidak nafsu makan
• Sakit tenggorokan ringan
• Pusing saat bangun
• Kesulitan konsentrasi sementara
• Perubahan suasana hati

PERAWATAN DI RUMAH:
• Istirahat yang cukup
• Minum banyak air
• Hindari mengemudi selama 24 jam
• Hindari keputusan penting atau menandatangani dokumen
• Hindari alkohol selama 24 jam
• Makan makanan ringan dan mudah dicerna
• Minum obat nyeri sesuai anjuran dokter

KAPAN HARUS MENGHUBUNGI DOKTER:
• Demam tinggi (>38.5°C)
• Mual dan muntah yang tidak berhenti
• Sesak napas
• Nyeri dada
• Perdarahan atau pembengkakan di area operasi
• Kebingungan berat atau perubahan perilaku
• Kesulitan buang air kecil

Pemulihan penuh dari efek anestesi biasanya memerlukan waktu 24-48 jam, meskipun beberapa orang mungkin memerlukan waktu lebih lama.`,
      },
    ],
  };

  // Track scroll progress
  useEffect(() => {
    const handleScroll = () => {
      if (!contentRef.current) return;

      const element = contentRef.current;
      const scrollTop = element.scrollTop;
      const scrollHeight = element.scrollHeight - element.clientHeight;
      const progress = (scrollTop / scrollHeight) * 100;

      setReadingProgress(Math.min(Math.round(progress), 100));

      if (progress >= 95 && !isCompleted) {
        setIsCompleted(true);
      }
    };

    const element = contentRef.current;
    if (element) {
      element.addEventListener('scroll', handleScroll);
      return () => element.removeEventListener('scroll', handleScroll);
    }
  }, [isCompleted]);

  // Track time spent
  useEffect(() => {
    const interval = setInterval(() => {
      setTimeSpent(prev => prev + 1);
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-white">
      {/* Fixed Header */}
      <div className="sticky top-0 z-50 bg-white border-b shadow-sm">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between mb-3">
            <Button variant="ghost" size="sm" onClick={() => navigate('/patient')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Kembali
            </Button>
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2 text-sm text-gray-600">
                <Clock className="w-4 h-4" />
                <span>{formatTime(timeSpent)}</span>
              </div>
              {isCompleted && (
                <Badge className="bg-green-600">
                  <CheckCircle className="w-3 h-3 mr-1" />
                  Selesai
                </Badge>
              )}
            </div>
          </div>

          <div className="space-y-2">
            <div className="flex items-center justify-between text-sm">
              <span className="font-medium text-gray-700">Progress Membaca</span>
              <span className="font-bold text-blue-600">{readingProgress}%</span>
            </div>
            <Progress value={readingProgress} className="h-2" />
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-4 py-8 max-w-4xl">
        <div className="mb-6">
          <div className="flex items-center gap-2 mb-2">
            <BookOpen className="w-5 h-5 text-blue-600" />
            <Badge variant="secondary">{material.type}</Badge>
          </div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">{material.title}</h1>
          <p className="text-gray-600 flex items-center gap-2">
            <Clock className="w-4 h-4" />
            Estimasi waktu baca: {material.estimatedTime}
          </p>
        </div>

        {/* Reading Progress Card */}
        <Card className="mb-6 border-blue-200 bg-blue-50">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <TrendingUp className="w-5 h-5 text-blue-600" />
              <div className="flex-1">
                <p className="text-sm font-semibold text-blue-900">
                  {readingProgress < 25 && "Anda baru memulai. Teruskan membaca! 📖"}
                  {readingProgress >= 25 && readingProgress < 50 && "Bagus! Anda sudah 25% selesai. 💪"}
                  {readingProgress >= 50 && readingProgress < 75 && "Setengah perjalanan! Terus lanjutkan! 🚀"}
                  {readingProgress >= 75 && readingProgress < 100 && "Hampir selesai! Sedikit lagi! 🎯"}
                  {readingProgress >= 100 && "Selamat! Anda telah menyelesaikan materi ini! 🎉"}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Material Content */}
        <Card>
          <CardContent 
            ref={contentRef}
            className="p-8 max-h-[600px] overflow-y-auto prose prose-sm max-w-none"
          >
            {material.sections.map((section, index) => (
              <div key={section.id} className="mb-8">
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
                    {index + 1}
                  </div>
                  <h2 className="text-xl font-bold text-gray-900 m-0">{section.title}</h2>
                </div>
                <div className="text-gray-700 whitespace-pre-line leading-relaxed pl-11">
                  {section.content}
                </div>
              </div>
            ))}

            {/* End of Content Marker */}
            <div className="mt-12 p-6 bg-green-50 border-2 border-green-200 rounded-lg text-center">
              <CheckCircle className="w-12 h-12 text-green-600 mx-auto mb-3" />
              <h3 className="text-xl font-bold text-gray-900 mb-2">
                Anda Telah Menyelesaikan Materi Ini!
              </h3>
              <p className="text-gray-600 mb-4">
                Waktu baca: {formatTime(timeSpent)} • Progress: {readingProgress}%
              </p>
              <div className="bg-white border border-green-300 rounded-lg p-4 mb-4">
                <p className="text-sm text-gray-700 mb-3">
                  💡 <strong>Langkah Selanjutnya:</strong> Chat dengan AI Assistant untuk 
                  memastikan pemahaman Anda tentang materi ini.
                </p>
              </div>
              <div className="flex gap-3 justify-center flex-wrap">
                <Button 
                  onClick={() => navigate('/patient/chat')}
                  className="bg-green-600 hover:bg-green-700"
                  size="lg"
                >
                  💬 Chat dengan AI Assistant
                </Button>
                <Button 
                  variant="outline"
                  onClick={() => navigate('/patient')}
                  size="lg"
                >
                  Kembali ke Dashboard
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Next Steps */}
        {isCompleted && (
          <Card className="mt-6 border-purple-200 bg-gradient-to-br from-purple-50 to-pink-50">
            <CardContent className="p-6">
              <h3 className="font-bold text-gray-900 mb-3">🎯 Langkah Selanjutnya:</h3>
              <ul className="space-y-2 text-sm text-gray-700">
                <li>✅ <strong>Chat dengan AI</strong> - Konfirmasi pemahaman Anda</li>
                <li>📚 <strong>Baca materi berikutnya</strong> - "Persiapan Sebelum Anestesi"</li>
                <li>💬 <strong>Tanya dokter</strong> jika ada yang belum jelas</li>
                <li>📅 <strong>Jadwalkan informed consent</strong> setelah progress 80%</li>
              </ul>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}