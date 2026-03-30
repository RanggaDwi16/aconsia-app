// COMPLETE LEARNING MATERIALS BASED ON RSU PINDAD INFORMED CONSENT FORM
// 45 seconds reading time per part with quiz

export interface LearningMaterial {
  id: string;
  title: string;
  description: string;
  type: string; // Anesthesia Type
  section: number; // 1-10 sesuai form informed consent
  part: number; // Part number dalam section
  content: string;
  estimatedTime: string; // Always "45 detik"
  quiz: {
    question: string;
    options: string[];
    correctAnswer: number;
    explanation: string;
  };
  readingProgress?: number;
  status?: "not_started" | "in_progress" | "completed";
}

// ========================================
// GENERAL ANESTHESIA MATERIALS
// Fokus: Tindakan, Risiko, Komplikasi GENERAL ANESTHESIA SAJA!
// ========================================
export const generalAnesthesiaMaterials: LearningMaterial[] = [
  // SECTION 1: Penjelasan Tindakan Anestesi Umum (3 parts)
  {
    id: "gen-1-1",
    title: "Apa Itu Anestesi Umum?",
    description: "Memahami tindakan anestesi umum",
    type: "General Anesthesia",
    section: 1,
    part: 1,
    estimatedTime: "45 detik",
    content: `# Apa Itu Anestesi Umum?

Anestesi umum adalah tindakan medis untuk membuat Anda **tidak sadarkan diri** selama operasi.

## Yang Akan Terjadi:
- Anda akan **tidur nyenyak**
- **Tidak merasakan sakit** sama sekali
- **Tidak ada ingatan** tentang operasi
- **Otot tubuh rileks** sepenuhnya

## Tujuan:
1. Menghilangkan rasa sakit
2. Membuat Anda tidur
3. Merelaksasi otot
4. Menjaga keamanan selama operasi
`,
    quiz: {
      question: "Apa yang terjadi pada pasien selama anestesi umum?",
      options: [
        "Pasien tetap sadar tapi tidak merasakan sakit",
        "Pasien tidak sadarkan diri dan tidak merasakan sakit",
        "Pasien tidur ringan dan bisa dibangunkan kapan saja",
        "Hanya bagian tubuh tertentu yang mati rasa"
      ],
      correctAnswer: 1,
      explanation: "Pada anestesi umum, pasien tidak sadarkan diri sepenuhnya, tidak merasakan sakit, dan tidak memiliki ingatan tentang operasi."
    }
  },
  {
    id: "gen-1-2",
    title: "Bagaimana Prosedur Anestesi Umum?",
    description: "Tahapan tindakan anestesi umum",
    type: "General Anesthesia",
    section: 1,
    part: 2,
    estimatedTime: "45 detik",
    content: `# Prosedur Anestesi Umum

## Tahap 1: Persiapan
- Pasang jalur infus (selang di tangan)
- Pasang monitor detak jantung
- Cek tekanan darah

## Tahap 2: Induksi (Membuat Tidur)
- Suntik obat bius lewat infus
- Anda akan tidur dalam hitungan detik
- Dokter pasang selang napas

## Tahap 3: Pemeliharaan
- Dokter jaga Anda tetap tidur
- Monitor vital sign sepanjang operasi

## Tahap 4: Pemulihan
- Operasi selesai, obat dihentikan
- Anda akan bangun perlahan
- Selang napas dilepas
`,
    quiz: {
      question: "Apa yang dilakukan dokter untuk membuat pasien tidur dalam anestesi umum?",
      options: [
        "Memberikan pil tidur",
        "Suntik obat bius lewat infus",
        "Memberikan oksigen murni",
        "Memijat kepala pasien"
      ],
      correctAnswer: 1,
      explanation: "Dokter menyuntikkan obat bius melalui infus untuk membuat pasien tidur dalam hitungan detik."
    }
  },
  {
    id: "gen-1-3",
    title: "Kenapa Perlu Selang Napas?",
    description: "Fungsi selang napas dalam anestesi umum",
    type: "General Anesthesia",
    section: 1,
    part: 3,
    estimatedTime: "45 detik",
    content: `# Selang Napas (Intubasi)

## Mengapa Diperlukan?
Saat Anda tidur total, otot-otot napas ikut rileks, termasuk tenggorokan. Selang napas diperlukan untuk:

1. **Menjaga jalan napas tetap terbuka**
2. **Membantu Anda bernapas**
3. **Memberikan oksigen langsung ke paru-paru**
4. **Melindungi dari cairan masuk ke paru**

## Kapan Dipasang & Dilepas?
- **Dipasang**: Setelah Anda tidur total
- **Dilepas**: Setelah operasi selesai dan Anda mulai bangun

Anda tidak akan merasakan saat selang dipasang atau dilepas.
`,
    quiz: {
      question: "Mengapa selang napas diperlukan dalam anestesi umum?",
      options: [
        "Untuk memberikan obat bius",
        "Untuk menjaga jalan napas tetap terbuka dan membantu bernapas",
        "Untuk mengambil darah",
        "Untuk memasukkan cairan"
      ],
      correctAnswer: 1,
      explanation: "Selang napas diperlukan karena saat tidur total, otot napas rileks sehingga perlu bantuan untuk menjaga jalan napas tetap terbuka dan membantu bernapas."
    }
  },

  // SECTION 2: Risiko Umum Anestesi Umum (3 parts)
  {
    id: "gen-2-1",
    title: "Risiko Umum: Mual & Muntah",
    description: "Efek samping yang sering terjadi",
    type: "General Anesthesia",
    section: 2,
    part: 1,
    estimatedTime: "45 detik",
    content: `# Mual & Muntah Setelah Anestesi

Ini adalah efek samping yang **PALING SERING** terjadi setelah anestesi umum.

## Fakta:
- Terjadi pada **30-50% pasien**
- Muncul dalam **6-24 jam** setelah operasi
- Lebih sering pada wanita, anak-anak, riwayat mabuk perjalanan

## Penyebab:
- Obat anestesi mempengaruhi pusat muntah di otak
- Gerakan saat dipindahkan ke kamar rawat
- Makan/minum terlalu cepat setelah operasi

## Penanganan:
✅ **Obat anti-mual** diberikan dokter
✅ Makan/minum bertahap setelah operasi
✅ Biasanya hilang dalam 1-2 hari

**Ini NORMAL dan bisa diatasi!**
`,
    quiz: {
      question: "Berapa persen pasien yang mengalami mual dan muntah setelah anestesi umum?",
      options: [
        "5-10%",
        "30-50%",
        "70-80%",
        "Hampir 100%"
      ],
      correctAnswer: 1,
      explanation: "Mual dan muntah terjadi pada 30-50% pasien setelah anestesi umum. Ini efek samping yang sering tapi ringan dan bisa diatasi dengan obat anti-mual."
    }
  },
  {
    id: "gen-2-2",
    title: "Risiko Umum: Sakit Tenggorokan",
    description: "Akibat pemasangan selang napas",
    type: "General Anesthesia",
    section: 2,
    part: 2,
    estimatedTime: "45 detik",
    content: `# Sakit Tenggorokan

Hampir **40-60% pasien** merasakan sakit tenggorokan setelah anestesi umum.

## Penyebab:
- **Selang napas** yang dipasang di tenggorokan
- Gesekan saat selang dimasukkan dan dikeluarkan
- Iritasi ringan pada saluran napas

## Gejala:
- Tenggorokan terasa **perih** atau **kering**
- Sakit saat menelan
- Suara serak
- Batuk kering

## Penanganan:
✅ Minum air **hangat** (bukan dingin/panas)
✅ **Obat kumur** antiseptik
✅ Permen pelega tenggorokan
✅ Biasanya hilang dalam **2-3 hari**

**Tidak berbahaya dan akan sembuh sendiri!**
`,
    quiz: {
      question: "Apa penyebab sakit tenggorokan setelah anestesi umum?",
      options: [
        "Infeksi bakteri",
        "Selang napas yang dipasang di tenggorokan",
        "Alergi obat anestesi",
        "Suhu ruangan operasi yang dingin"
      ],
      correctAnswer: 1,
      explanation: "Sakit tenggorokan disebabkan oleh selang napas yang dipasang di tenggorokan selama operasi. Ini normal dan akan sembuh dalam 2-3 hari."
    }
  },
  {
    id: "gen-2-3",
    title: "Risiko Umum: Pusing & Mengantuk",
    description: "Efek sisa obat anestesi",
    type: "General Anesthesia",
    section: 2,
    part: 3,
    estimatedTime: "45 detik",
    content: `# Pusing & Mengantuk

**70-80% pasien** merasa pusing dan sangat mengantuk setelah bangun dari anestesi.

## Penyebab:
- **Efek sisa obat** anestesi dalam tubuh
- Tubuh butuh waktu untuk "membersihkan" obat

## Berapa Lama?
- Dewasa muda: **6-12 jam**
- Lansia (>60 tahun): **24-48 jam**
- Bisa lebih lama jika operasi >3 jam

## Yang Normal:
✅ Sulit fokus/konsentrasi
✅ Merasa "melayang"
✅ Butuh tidur terus
✅ Lupa hal-hal kecil (ingatan jangka pendek)

## Yang HARUS Dilakukan:
✅ **Jangan mengemudi** sampai 24 jam
✅ **Jangan putuskan hal penting** hari itu
✅ Istirahat total

**SEMUA NORMAL! Akan hilang sendiri.**
`,
    quiz: {
      question: "Berapa lama biasanya efek pusing dan mengantuk bertahan pada dewasa muda?",
      options: [
        "1-2 jam",
        "6-12 jam",
        "3-5 hari",
        "1-2 minggu"
      ],
      correctAnswer: 1,
      explanation: "Pada dewasa muda, efek pusing dan mengantuk biasanya bertahan 6-12 jam. Pada lansia bisa lebih lama (24-48 jam). Ini normal karena efek sisa obat anestesi."
    }
  },

  // SECTION 3: Risiko Sedang & Serius Anestesi Umum (3 parts)
  {
    id: "gen-3-1",
    title: "Risiko Sedang Anestesi Umum",
    description: "Komplikasi yang perlu perhatian medis",
    type: "General Anesthesia",
    section: 3,
    part: 1,
    estimatedTime: "45 detik",
    content: `# Risiko Sedang Anestesi

Ini risiko yang **JARANG** tapi **PERLU PERHATIAN**:

## 1. Reaksi Alergi Obat (1:10,000)
- Gatal, ruam, bengkak
- **Pencegahan:** Beritahu dokter jika punya alergi
- **Penanganan:** Tim siap dengan obat anti-alergi

## 2. Aspirasi - Makanan Masuk Paru (1:2,000-3,000)
- **Penyebab:** TIDAK PUASA dengan benar
- Bisa sebabkan pneumonia
- **PENCEGAHAN:** **PUASA KETAT 6-8 jam!**

## 3. Pneumonia (1-2%)
- **Pencegahan:** Latihan napas dalam setelah operasi
- **Penanganan:** Antibiotik

**KEJUJURAN tentang puasa = KESELAMATAN Anda!**
`,
    quiz: {
      question: "Apa yang dimaksud dengan aspirasi?",
      options: [
        "Alergi obat anestesi",
        "Makanan atau cairan dari lambung masuk ke paru-paru",
        "Bangun di tengah operasi",
        "Demam tinggi setelah operasi"
      ],
      correctAnswer: 1,
      explanation: "Aspirasi adalah kondisi ketika makanan/cairan dari lambung masuk ke paru-paru, bisa dicegah dengan PUASA KETAT 6-8 jam."
    }
  },
  {
    id: "gen-3-2",
    title: "Risiko Serius Anestesi Umum",
    description: "Komplikasi berat yang harus diketahui",
    type: "General Anesthesia",
    section: 3,
    part: 2,
    estimatedTime: "45 detik",
    content: `# Risiko Serius Anestesi

Ini risiko yang **SANGAT JARANG** tapi **HARUS DIKETAHUI**:

## 1. Henti Jantung (1:100,000)
- **Pasien berisiko:** Penyakit jantung, lansia >70 tahun
- **Penanganan:** Tim terlatih resusitasi, alat defibrilator siap

## 2. Stroke (1:10,000 pada pasien berisiko)
- **Gejala:** Wajah perot, lengan lemah, bicara pelo
- **SEGERA beritahu tim** jika ada gejala!

## 3. Malignant Hyperthermia (1:50,000-100,000)
- Reaksi genetik langka
- **WAJIB beritahu** jika keluarga pernah alami ini
- Obat antidote (Dantrolene) tersedia

**Tim siap menangani SEMUA komplikasi!**
`,
    quiz: {
      question: "Risiko kematian akibat anestesi umum adalah:",
      options: [
        "Sangat tinggi (1 dari 100)",
        "Tinggi (1 dari 1,000)",
        "Rendah (1 dari 10,000)",
        "Sangat rendah (1 dari 200,000-300,000)"
      ],
      correctAnswer: 3,
      explanation: "Risiko kematian akibat anestesi umum SANGAT RENDAH (1:200,000-300,000). Anestesi modern sangat aman!"
    }
  },
  {
    id: "gen-3-3",
    title: "Risiko Lainnya Anestesi Umum",
    description: "Komplikasi tambahan yang perlu diperhatikan",
    type: "General Anesthesia",
    section: 3,
    part: 3,
    estimatedTime: "45 detik",
    content: `# Risiko Lainnya Anestesi

Ini risiko yang **LANGKA** tapi **PERLU DIKETAHUI**:

## 1. Deep Vein Thrombosis (DVT) - Bekuan Darah di Kaki
- **Gejala:** Kaki bengkak, nyeri, merah
- **Risiko:** Bekuan bisa lepas → ke paru (FATAL)
- **Pencegahan:**
  ✅ **Jalan kaki** sesegera mungkin setelah operasi!
  ✅ Stocking kompresi
  ✅ Obat pengencer darah (jika perlu)

## 2. Infeksi Luka Operasi
- **Gejala (3-7 hari):** Luka merah, bengkak, nanah, demam
- **Pencegahan:** Antibiotik, teknik aseptik ketat

## 3. Delirium (Kebingungan pada Lansia)
- **Pasien berisiko:** Lansia >70 tahun
- **Penanganan:** Re-orientasi, keluarga di samping, biasanya hilang 1-7 hari

**MOBILISASI DINI = kunci pemulihan cepat!**
`,
    quiz: {
      question: "Apa cara terbaik mencegah DVT (bekuan darah di kaki)?",
      options: [
        "Berbaring terus tidak boleh bergerak",
        "Jalan kaki sesegera mungkin setelah diizinkan dokter",
        "Minum kopi banyak",
        "Tidur miring terus"
      ],
      correctAnswer: 1,
      explanation: "Cara terbaik mencegah DVT adalah MOBILISASI DINI - jalan kaki sesegera mungkin setelah diizinkan dokter untuk melancarkan sirkulasi darah."
    }
  },

  // SECTION 4: Komplikasi Anestesi Umum (3 parts)
  {
    id: "gen-4-1",
    title: "Komplikasi Pernapasan",
    description: "Masalah yang bisa terjadi pada sistem napas",
    type: "General Anesthesia",
    section: 4,
    part: 1,
    estimatedTime: "45 detik",
    content: `# Komplikasi Pernapasan

## 1. Laringospasme (Spasme Tenggorokan)
- Otot tenggorokan **menutup tiba-tiba**
- **Penanganan:** Oksigen 100%, obat pelemas otot
- Biasanya teratasi dalam 1-2 menit

## 2. Bronkospasme (Saluran Napas Menyempit)
- Mirip serangan asma
- **Pasien berisiko:** Punya asma/alergi, perokok
- **Pencegahan:** Beritahu dokter jika punya asma!
- **Penanganan:** Obat bronkodilator (pelebar saluran napas)

## 3. Pneumonia Aspirasi
- Sudah dijelaskan di section Risiko
- **PENCEGAHAN TERBAIK:** PUASA KETAT!

**Tim siap tangani semua komplikasi napas!**
`,
    quiz: {
      question: "Apa yang harus dilakukan untuk mencegah komplikasi bronkospasme?",
      options: [
        "Tidak perlu melakukan apa-apa",
        "Beritahu dokter jika punya asma atau alergi",
        "Minum kopi sebelum operasi",
        "Olahraga berat sebelum operasi"
      ],
      correctAnswer: 1,
      explanation: "Untuk mencegah bronkospasme, WAJIB beritahu dokter jika Anda punya asma, alergi, atau perokok agar bisa diberikan obat pencegahan."
    }
  },
  {
    id: "gen-4-2",
    title: "Komplikasi Jantung & Pembuluh Darah",
    description: "Masalah kardiovaskular yang mungkin terjadi",
    type: "General Anesthesia",
    section: 4,
    part: 2,
    estimatedTime: "45 detik",
    content: `# Komplikasi Kardiovaskular

## 1. Hipotensi (Tekanan Darah Turun)
- Tekanan darah <90/60 mmHg
- **Penyebab:** Obat anestesi, perdarahan, dehidrasi
- **Penanganan:** Cairan infus ditambah, obat penaik tekanan darah

## 2. Hipertensi (Tekanan Darah Naik)
- Tekanan darah >180/100 mmHg
- **Penyebab:** Nyeri tidak terkontrol, cemas
- **Penanganan:** Obat penurun tekanan darah, tambah obat pereda nyeri

## 3. Aritmia (Detak Jantung Tidak Teratur)
- **Penanganan:** Monitor EKG ketat, obat anti-aritmia

**Monitor terus dipasang untuk keamanan Anda!**
`,
    quiz: {
      question: "Apa yang dilakukan jika terjadi hipotensi (tekanan darah turun) saat operasi?",
      options: [
        "Dibiarkan saja",
        "Operasi dihentikan",
        "Cairan infus ditambah dan diberi obat penaik tekanan darah",
        "Pasien dibangunkan"
      ],
      correctAnswer: 2,
      explanation: "Jika terjadi hipotensi, tim anestesi akan menambah cairan infus dan memberikan obat penaik tekanan darah untuk stabilkan kondisi."
    }
  },
  {
    id: "gen-4-3",
    title: "Komplikasi Lain & Pencegahan",
    description: "Komplikasi tambahan dan cara mencegahnya",
    type: "General Anesthesia",
    section: 4,
    part: 3,
    estimatedTime: "45 detik",
    content: `# Komplikasi Lain

## 1. Deep Vein Thrombosis (DVT) - Bekuan Darah di Kaki
- **Gejala:** Kaki bengkak, nyeri, merah
- **Risiko:** Bekuan bisa lepas → ke paru (FATAL)
- **Pencegahan:**
  ✅ **Jalan kaki** sesegera mungkin setelah operasi!
  ✅ Stocking kompresi
  ✅ Obat pengencer darah (jika perlu)

## 2. Infeksi Luka Operasi
- **Gejala (3-7 hari):** Luka merah, bengkak, nanah, demam
- **Pencegahan:** Antibiotik, teknik aseptik ketat

## 3. Delirium (Kebingungan pada Lansia)
- **Pasien berisiko:** Lansia >70 tahun
- **Penanganan:** Re-orientasi, keluarga di samping, biasanya hilang 1-7 hari

**MOBILISASI DINI = kunci pemulihan cepat!**
`,
    quiz: {
      question: "Apa cara terbaik mencegah DVT (bekuan darah di kaki)?",
      options: [
        "Berbaring terus tidak boleh bergerak",
        "Jalan kaki sesegera mungkin setelah diizinkan dokter",
        "Minum kopi banyak",
        "Tidur miring terus"
      ],
      correctAnswer: 1,
      explanation: "Cara terbaik mencegah DVT adalah MOBILISASI DINI - jalan kaki sesegera mungkin setelah diizinkan dokter untuk melancarkan sirkulasi darah."
    }
  },

  // SECTION 5: Prognosis (3 parts)
  {
    id: "gen-5-1",
    title: "Pemulihan Jangka Pendek (0-24 Jam)",
    description: "Apa yang terjadi hari pertama setelah operasi",
    type: "General Anesthesia",
    section: 5,
    part: 1,
    estimatedTime: "45 detik",
    content: `# Pemulihan Jangka Pendek

## 0-2 Jam (Ruang Pemulihan):
- Bangun perlahan, masih **mengantuk** - NORMAL
- **Sakit tenggorokan**, mulut kering
- Mungkin **mual/muntah**
- Monitor tanda vital setiap 15 menit

## 6-12 Jam (Kamar Rawat):
- Sudah lebih sadar tapi masih mengantuk
- **Nyeri** bekas operasi → obat pereda nyeri diberikan
- Belum boleh makan (hanya minum sedikit)

## 12-24 Jam:
- **Kesadaran penuh**
- Mulai bisa **duduk**
- Boleh **makan makanan lunak**
- Efek anestesi 80-90% hilang

**Prognosis: BAIK ✅**
`,
    quiz: {
      question: "Kapan efek anestesi akan 80-90% hilang dari tubuh?",
      options: [
        "2 jam setelah operasi",
        "6 jam setelah operasi",
        "12-24 jam setelah operasi",
        "1 minggu setelah operasi"
      ],
      correctAnswer: 2,
      explanation: "Efek anestesi akan 80-90% hilang dalam 12-24 jam setelah operasi. Kesadaran penuh dan pasien sudah bisa duduk/makan."
    }
  },
  {
    id: "gen-5-2",
    title: "Pemulihan Jangka Menengah (1-7 Hari)",
    description: "Proses pemulihan minggu pertama",
    type: "General Anesthesia",
    section: 5,
    part: 2,
    estimatedTime: "45 detik",
    content: `# Pemulihan Jangka Menengah

## Hari Ke-2:
- Masih **terasa lelah** (butuh tidur lebih banyak)
- Nafsu makan mulai kembali
- Sudah bisa **jalan sendiri** ke kamar mandi
- Mulai bisa mandi (jika luka boleh kena air)

## Hari Ke-3-5:
- Jauh lebih **segar**
- Sudah bisa **makan normal**
- Nyeri minimal
- **Banyak pasien sudah boleh pulang** (tergantung jenis operasi)

## Hari Ke-6-7:
- Energi hampir kembali normal
- Luka operasi mulai sembuh
- Sudah bisa perawatan diri sendiri

**Prognosis: SANGAT BAIK ✅**
`,
    quiz: {
      question: "Pada hari ke berapa biasanya pasien sudah boleh pulang?",
      options: [
        "Hari yang sama setelah operasi",
        "Hari ke-1",
        "Hari ke-3-5 (tergantung jenis operasi)",
        "Harus 2 minggu di RS"
      ],
      correctAnswer: 2,
      explanation: "Banyak pasien sudah boleh pulang di hari ke-3-5 setelah operasi (tergantung jenis operasi dan kondisi pemulihan)."
    }
  },
  {
    id: "gen-5-3",
    title: "Pemulihan Jangka Panjang (1-4 Minggu)",
    description: "Kembali ke aktivitas normal",
    type: "General Anesthesia",
    section: 5,
    part: 3,
    estimatedTime: "45 detik",
    content: `# Pemulihan Jangka Panjang

## Minggu Ke-2:
- **Efek anestesi 100% HILANG**
- Luka sudah kering, jahitan mungkin dibuka
- Sudah bisa **aktivitas rumah tangga ringan**
- Sudah bisa **jalan santai** 15-30 menit

## Minggu Ke-3-4:
- Stamina sudah **80-90% normal**
- Sudah bisa **bekerja** (pekerjaan kantor/ringan)
- Sudah bisa **mengemudi**
- Tidak ada lagi keterbatasan dari sisi anestesi

## Kapan Bisa Kembali Bekerja?
- Pekerjaan kantor: **1-2 minggu**
- Pekerjaan fisik ringan: **3-4 minggu**
- Pekerjaan fisik berat: **6-8 minggu**

**Anda AKAN PULIH dengan BAIK! 💪**
`,
    quiz: {
      question: "Kapan efek anestesi umum akan hilang 100% dari tubuh?",
      options: [
        "24 jam setelah operasi",
        "3 hari setelah operasi",
        "1-2 minggu setelah operasi",
        "1 bulan setelah operasi"
      ],
      correctAnswer: 2,
      explanation: "Efek anestesi umum akan hilang 100% dalam 1-2 minggu setelah operasi. Tidak ada efek jangka panjang pada orang sehat."
    }
  },

  // SECTION 6: Persetujuan & Informasi Tambahan (4 parts)
  {
    id: "gen-6-1",
    title: "Arti Menandatangani Informed Consent",
    description: "Apa makna tanda tangan Anda",
    type: "General Anesthesia",
    section: 6,
    part: 1,
    estimatedTime: "45 detik",
    content: `# Arti Menandatangani Informed Consent

Dengan menandatangani, Anda menyatakan:

## 1. Anda SUDAH DIBERI INFORMASI LENGKAP tentang:
✅ Jenis anestesi (General Anesthesia)
✅ Prosedur yang akan dilakukan
✅ Risiko dan komplikasi
✅ Alternatif lain yang tersedia
✅ Prognosis (hasil yang diharapkan)

## 2. Anda SUDAH PAHAM:
✅ Apa yang akan terjadi
✅ Risiko yang mungkin dialami
✅ Apa yang harus dilakukan

## 3. Anda SETUJU SECARA SUKARELA:
✅ **TIDAK DIPAKSA** oleh siapapun
✅ Ini keputusan Anda sendiri

**Ini BUKAN "surat kebebasan" dokter - Anda tetap punya hak!**
`,
    quiz: {
      question: "Apa arti menandatangani informed consent?",
      options: [
        "Menyerahkan semua keputusan kepada dokter",
        "Menyatakan sudah diberi informasi lengkap, paham, dan setuju secara sukarela",
        "Membebaskan dokter dari tanggung jawab",
        "Hanya formalitas administrasi"
      ],
      correctAnswer: 1,
      explanation: "Menandatangani informed consent berarti menyatakan bahwa sudah diberi informasi lengkap, memahami risiko, dan setuju secara sukarela tanpa paksaan."
    }
  },
  {
    id: "gen-6-2",
    title: "Siapa yang Berhak Menandatangani?",
    description: "Aturan penandatanganan informed consent",
    type: "General Anesthesia",
    section: 6,
    part: 2,
    estimatedTime: "45 detik",
    content: `# Siapa yang Menandatangani?

## Pasien Dewasa Sadar (≥18 tahun):
✅ **ANDA SENDIRI** yang tanda tangan
- Tunjukkan KTP/identitas
- Baca dengan teliti
- Tanyakan jika tidak jelas

## Pasien Anak (<18 tahun):
✅ **Orang tua** atau **wali sah**
- Bawa Kartu Keluarga (KK)

## Pasien Tidak Sadar/Darurat:
✅ **Keluarga terdekat** (urutan):
1. Suami/Istri
2. Anak (dewasa)
3. Orang tua
4. Saudara kandung

## Jika TIDAK ADA KELUARGA & DARURAT:
- Dokter **BOLEH** langsung operasi untuk selamatkan nyawa (tanpa informed consent)

**Saksi diperlukan: 1 dari keluarga, 1 dari RS**
`,
    quiz: {
      question: "Siapa yang berhak menandatangani informed consent untuk pasien dewasa yang sadar?",
      options: [
        "Keluarga saja",
        "Dokter",
        "Pasien sendiri",
        "Perawat"
      ],
      correctAnswer: 2,
      explanation: "Untuk pasien dewasa (≥18 tahun) yang sadar, yang berhak menandatangani informed consent adalah PASIEN SENDIRI."
    }
  },
  {
    id: "gen-6-3",
    title: "Hak Anda Setelah Menandatangani",
    description: "Hak yang tetap Anda miliki",
    type: "General Anesthesia",
    section: 6,
    part: 3,
    estimatedTime: "45 detik",
    content: `# Hak Anda Setelah Tanda Tangan

## Anda TETAP BERHAK:

### 1. Bertanya & Minta Penjelasan Ulang
✅ Kapan saja jika ada yang lupa
✅ Sampai detik terakhir sebelum anestesi

### 2. Membatalkan Persetujuan
✅ **Sebelum obat anestesi masuk**
✅ Bahkan di ruang operasi
✅ Cara: Katakan dengan jelas, tulis pernyataan penolakan

### 3. Mendapat Salinan Dokumen
✅ Minta ke bagian administrasi
✅ **SIMPAN minimal 5-10 tahun**

### 4. Melaporkan Jika Ada Kelalaian
✅ Ke Komite Etik RS
✅ Ke MKDKI
✅ Ke Polisi (jika ada unsur pidana)

**Tanda tangan BUKAN penyerahan mutlak!**
`,
    quiz: {
      question: "Apakah pasien masih bisa membatalkan persetujuan setelah menandatangani?",
      options: [
        "Tidak boleh, sudah tanda tangan berarti final",
        "Boleh, asalkan sebelum obat anestesi masuk",
        "Harus bayar denda dulu",
        "Hanya bisa jika keluarga setuju"
      ],
      correctAnswer: 1,
      explanation: "Pasien BOLEH membatalkan persetujuan kapan saja, asalkan SEBELUM obat anestesi masuk, bahkan di ruang operasi."
    }
  },
  {
    id: "gen-6-4",
    title: "Informasi Penting Terakhir",
    description: "Hal krusial yang wajib diingat",
    type: "General Anesthesia",
    section: 6,
    part: 4,
    estimatedTime: "45 detik",
    content: `# Informasi Penting Terakhir

## WAJIB Beritahu Dokter Jika:
✅ **Alergi** obat/makanan/plester
✅ **Penyakit kronis** (jantung, diabetes, asma, ginjal)
✅ **Merokok/alkohol**
✅ **Hamil** atau curiga hamil (wanita)
✅ **Riwayat keluarga** masalah anestesi

## Jangan Tanda Tangan Jika:
❌ Anda **belum paham**
❌ Anda **masih ragu**
❌ Anda **merasa dipaksa**
❌ Masih **ada pertanyaan**

**Minta waktu berpikir - ini HAK Anda!**

## Dokumen yang Harus Disimpan:
📄 Salinan informed consent
📄 Resume medis
📄 Resep obat
📄 Hasil lab/pemeriksaan

**KEJUJURAN = KESELAMATAN ANDA! 🏥**
`,
    quiz: {
      question: "Kapan pasien TIDAK BOLEH menandatangani informed consent?",
      options: [
        "Jika sudah diberi penjelasan",
        "Jika belum paham, masih ragu, atau merasa dipaksa",
        "Jika keluarga sudah setuju",
        "Jika sudah di ruang operasi"
      ],
      correctAnswer: 1,
      explanation: "Pasien TIDAK BOLEH tanda tangan jika: belum paham, masih ragu, merasa dipaksa, atau masih ada pertanyaan. Minta waktu berpikir!"
    }
  }
];

// Helper function to get materials by anesthesia type
export function getMaterialsByType(anesthesiaType: string): LearningMaterial[] {
  switch (anesthesiaType) {
    case "General Anesthesia":
      return generalAnesthesiaMaterials;
    default:
      return generalAnesthesiaMaterials;
  }
}

// Helper function to check if content exists for a type
export function hasContentForType(anesthesiaType: string): boolean {
  return anesthesiaType === "General Anesthesia";
}

// Export all materials as flat array
export const learningMaterials: LearningMaterial[] = generalAnesthesiaMaterials;

// Get total parts in a section
export function getPartsInSection(section: number): number {
  return generalAnesthesiaMaterials.filter(m => m.section === section).length;
}

// Get materials by section
export function getMaterialsBySection(section: number): LearningMaterial[] {
  return generalAnesthesiaMaterials.filter(m => m.section === section);
}