# ✅❌ CHECKLIST FITUR - APA YANG KURANG & SUDAH ADA

**Last Updated:** 18 Maret 2026  
**Project:** ACONSIA - Sistem Edukasi Informed Consent Anestesi

---

## 📊 RINGKASAN STATUS

| Kategori | Sudah Ada | Kurang/Perlu Diperbaiki | Total |
|----------|-----------|-------------------------|-------|
| **Data & Konten** | 3 | 7 | 10 |
| **Sistem AI** | 1 | 3 | 4 |
| **Tracking & Progress** | 2 | 2 | 4 |
| **Flow User** | 5 | 3 | 8 |
| **UI/UX** | 4 | 2 | 6 |
| **TOTAL** | 15 | 17 | 32 |

**Progress Overall: 46.9% (15/32)**

---

## 🔴 PRIORITAS TINGGI - YANG KURANG

### **1. DATA KONTEN PEMBELAJARAN (CRITICAL!)**

#### ❌ **KURANG: 10 Section Materi Sesuai Form Informed Consent Asli**

**Status Sekarang:**
- ✅ Hanya ada 3-6 materi per jenis anestesi
- ❌ Tidak sesuai dengan 10 section form informed consent RS

**Yang Dibutuhkan (Sesuai Background User):**
```
10 SECTION WAJIB (Sesuai Form IC Asli RS):

1. Definisi & Tujuan Anestesi
   - Apa itu anestesi (general/regional/lokal)
   - Kenapa diperlukan untuk operasi ini
   - Manfaat anestesi

2. Prosedur Teknik Anestesi
   - Tahapan pemberian anestesi
   - Alat yang digunakan
   - Proses induksi, maintenance, emergence

3. Risiko & Komplikasi Anestesi
   - Risiko ringan (mual, pusing, sakit tenggorokan)
   - Risiko sedang (alergi, gangguan napas)
   - Risiko berat (komplikasi jantung, stroke, kematian)
   - Probabilitas masing-masing risiko

4. Alternatif Teknik Anestesi
   - Pilihan lain selain teknik yang dipilih
   - Kelebihan & kekurangan alternatif
   - Kenapa teknik ini yang dipilih dokter

5. Persiapan Pra-Anestesi
   - Puasa (berapa jam sebelum operasi)
   - Obat yang harus dihentikan/dilanjutkan
   - Persiapan fisik & mental
   - Checklist yang harus dibawa

6. Prosedur Saat Operasi
   - Apa yang terjadi di ruang operasi
   - Monitoring yang dilakukan
   - Peran tim anestesi

7. Pemulihan Pasca-Anestesi
   - Recovery room/RR
   - Efek samping normal setelah bangun
   - Berapa lama efek anestesi hilang
   - Kapan bisa makan/minum

8. Kondisi Khusus Pasien
   - Untuk pasien diabetes
   - Untuk pasien hipertensi
   - Untuk ibu hamil/menyusui
   - Untuk pasien obesitas
   - Untuk lansia

9. Hak & Kewajiban Pasien
   - Hak bertanya & mendapat penjelasan
   - Hak menolak prosedur
   - Kewajiban memberikan informasi lengkap
   - Kewajiban mengikuti instruksi

10. Informed Consent & Legalitas
    - Apa itu informed consent
    - Kenapa harus tanda tangan
    - Siapa yang berhak menandatangani
    - Dokumen yang harus disiapkan
```

**File yang Perlu Diupdate:**
- `/src/app/pages/patient/EnhancedPatientHome.tsx` → Update `allMaterials` array
- Buat file baru untuk konten lengkap: `/src/data/learningMaterials.ts`

**Action Required:**
```typescript
// Struktur data yang dibutuhkan
const learningMaterials = {
  general: [
    { id: '1', title: 'Definisi & Tujuan Anestesi Umum', section: 1, ... },
    { id: '2', title: 'Prosedur Teknik General Anesthesia', section: 2, ... },
    // ... 8 section lainnya
  ],
  spinal: [
    { id: '11', title: 'Definisi & Tujuan Anestesi Spinal', section: 1, ... },
    // ... 9 section lainnya
  ],
  epidural: [...],
  regional: [...],
  local: [...]
};
```

---

#### ❌ **KURANG: Mapping Type Anestesi Tidak Konsisten**

**Masalah:**
```typescript
// Dokter pilih di approval:
anesthesiaType: "general" // lowercase

// Tapi di material data:
type: "General Anesthesia" // Title Case dengan spasi

// Filter TIDAK AKAN MATCH! ❌
```

**Fix Required:**
```typescript
// Standardisasi: Semua pakai lowercase
anesthesiaType: "general" | "spinal" | "epidural" | "regional" | "local"
material.type: "general" | "spinal" | "epidural" | "regional" | "local"

// Update di PatientApprovalNew.tsx
<option value="general">🔴 Anestesi Umum</option>
<option value="spinal">🔵 Anestesi Spinal</option>
<option value="epidural">🔵 Anestesi Epidural</option>
<option value="regional">🔵 Anestesi Regional</option>
<option value="local">🟢 Anestesi Lokal + Sedasi</option>

// Update material data
{ type: "general", title: "..." }
{ type: "spinal", title: "..." }
```

---

#### ❌ **KURANG: Konten Materi Hanya Ada untuk General & Spinal**

**Status Sekarang:**
- ✅ General Anesthesia: 3 materi (KURANG 7)
- ✅ Spinal Anesthesia: 3 materi (KURANG 7)
- ❌ Epidural Anesthesia: TIDAK ADA
- ❌ Regional Anesthesia: TIDAK ADA
- ❌ Local Anesthesia: TIDAK ADA

**Action Required:**
Buat 10 section untuk SETIAP jenis anestesi = **50 materi total**

---

### **2. SISTEM AI PROAKTIF**

#### ❌ **KURANG: AI Tidak Menanyakan Pertanyaan**

**Status Sekarang:**
- ✅ Ada placeholder AI recommendations di dashboard
- ❌ AI TIDAK proaktif menanyakan pertanyaan untuk menguji pemahaman

**Yang Dibutuhkan (Sesuai Background User):**
```
CONTOH FLOW AI PROAKTIF:

Pasien selesai baca Section 1: "Definisi Anestesi Umum"
↓
AI POPUP: 🤖 "Hai! Untuk memastikan Anda paham, saya ingin tanya:

Pertanyaan 1: Apa perbedaan utama anestesi umum dengan anestesi lokal?
a) Anestesi umum hanya untuk operasi besar
b) Anestesi umum membuat Anda tidak sadar, lokal hanya mati rasa
c) Anestesi umum lebih murah
d) Tidak ada perbedaan

[Pilih Jawaban]

↓ Pasien jawab BENAR
AI: "✅ Benar! Anda sudah memahami perbedaan keduanya. 
     Progress pemahaman: +10%. Lanjut ke section 2?"

↓ Pasien jawab SALAH
AI: "❌ Kurang tepat. Mari saya jelaskan lagi...
     💡 Rekomendasi: Baca ulang bagian 'Perbedaan Anestesi Umum vs Lokal'
     Progress pemahaman: +0%"
```

**Checkpoint Quiz Wajib:**
- Setiap selesai baca 1 section → AI tanya 2-3 pertanyaan
- Harus jawab benar minimal 70% untuk unlock section berikutnya
- Progress hanya naik jika jawab benar

**File yang Perlu Dibuat:**
- `/src/app/components/AIQuizDialog.tsx` → Component quiz popup
- `/src/data/quizQuestions.ts` → Database pertanyaan per section
- `/src/app/pages/patient/MaterialReader.tsx` → Integrate quiz after reading

---

#### ❌ **KURANG: AI Rekomendasi Berdasarkan Jawaban Salah**

**Yang Dibutuhkan:**
```
Pasien jawab salah pertanyaan tentang "Risiko Anestesi"
↓
AI detect: Pasien tidak paham section 3
↓
AI CREATE RECOMMENDATION:
{
  title: "Pelajari Ulang: Risiko & Komplikasi Anestesi",
  reason: "Anda belum memahami dengan baik tentang risiko anestesi. 
          Ini penting untuk informed consent.",
  priority: "high",
  link: "/patient/material/3",
  action: "Baca Ulang"
}
↓
Muncul di Dashboard di card "Rekomendasi AI"
```

**File yang Perlu Dibuat:**
- `/src/utils/aiRecommendationEngine.ts` → Logic generate rekomendasi
- Update `/src/app/pages/patient/EnhancedPatientHome.tsx` → Dynamic AI recommendations

---

#### ❌ **KURANG: AI Chat Dialog untuk Tanya Jawab**

**Status Sekarang:**
- ✅ Ada fitur "Hubungi Dokter" (real-time chat dengan dokter)
- ❌ Tidak ada AI chatbot untuk tanya jawab instant

**Yang Dibutuhkan:**
```
Floating Button: 💬 "Tanya AI"
↓
Dialog Chat:
┌─────────────────────────────────────┐
│ 🤖 AI Assistant                     │
├─────────────────────────────────────┤
│ Pasien: Apa itu intubasi?           │
│                                     │
│ AI: Intubasi adalah proses          │
│     memasukkan selang ke...         │
│                                     │
│ [Ketik pertanyaan Anda...]          │
└─────────────────────────────────────┘
```

**Catatan:** Ini bisa pakai mock AI responses atau integrate dengan Gemini API

---

### **3. TRACKING PROGRESS 0-100%**

#### ❌ **KURANG: Perhitungan Progress Tidak Akurat**

**Status Sekarang:**
```typescript
comprehensionScore: 0 // Static, tidak terupdate
```

**Yang Dibutuhkan:**
```typescript
// Setiap pasien jawab quiz:
if (jawabBenar) {
  comprehensionScore += (100 / totalSections); // Jika 10 section, +10% per section
}

// Contoh:
- Selesai Section 1 + Quiz Benar → 10%
- Selesai Section 2 + Quiz Benar → 20%
- ... 
- Selesai Section 10 + Quiz Benar → 100%

// Jika jawab salah:
comprehensionScore += 0; // Harus baca ulang
```

**Formula:**
```
comprehensionScore = (sectionsCompleted / totalSections) * 100

Tapi hanya dihitung jika:
1. Section sudah dibaca sampai habis
2. Quiz checkpoint passed (minimal 70% benar)
```

---

#### ✅ **SUDAH ADA: Display Progress Bar**

**Status:** ✅ Sudah ada di dashboard pasien
- Progress bar visual
- Percentage number
- Color coding (red <50%, yellow 50-79%, green ≥80%)

---

### **4. FLOW DOCTOR DASHBOARD**

#### ❌ **KURANG: List Pasien Pending Tidak Real**

**Status Sekarang:**
- ✅ Dashboard dokter ada
- ❌ List pasien pending hardcoded (data dummy)

**Yang Dibutuhkan:**
```typescript
// Load dari localStorage semua pasien dengan status "pending"
const allPatients = getAllPatientsFromLocalStorage();
const pendingPatients = allPatients.filter(p => p.status === "pending");

// Display di dashboard:
pendingPatients.map(patient => (
  <PatientCard 
    name={patient.fullName}
    mrn={patient.mrn}
    registrationDate={patient.createdAt}
    onClick={() => navigate(`/doctor/approval?patientId=${patient.id}`)}
  />
))
```

**File yang Perlu Diupdate:**
- `/src/app/pages/doctor/DoctorDashboardNew.tsx`
- `/src/utils/patientStorage.ts` → Helper untuk load all patients

---

#### ❌ **KURANG: Monitoring Progress Pasien Real-time**

**Yang Dibutuhkan:**
```
Dashboard Dokter → Tab "Pasien Aktif"
┌─────────────────────────────────────────────┐
│ Nama: John Doe                              │
│ MRN: MRN-2026-001                           │
│ Jenis Anestesi: General                     │
│ Progress Pemahaman: 45% (Section 4/10)      │ ← Real-time!
│ Status: Sedang Belajar                      │
│ [Lihat Detail Progress]                     │
└─────────────────────────────────────────────┘
```

Dokter bisa lihat:
- Section mana yang sudah selesai
- Quiz score per section
- Berapa lama waktu baca per materi
- Apakah pasien stuck di section tertentu

---

### **5. ASESMEN PRA-OPERASI**

#### ✅ **SUDAH ADA: Form Asesmen**

**Status:** ✅ Sudah ada di `/patient/pre-operative-assessment`
- Form riwayat anestesi, alergi, obat rutin, kebiasaan, riwayat penyakit
- Status "Selesai" muncul di dashboard setelah diisi

---

#### ❌ **KURANG: Data Asesmen Tidak Tersimpan Persistent**

**Masalah:** Data hanya di state, tidak save ke localStorage

**Fix Required:**
```typescript
// Setelah submit assessment
const updatedPatient = {
  ...currentPatient,
  assessmentData: formData,
  assessmentCompleted: true,
  assessmentDate: new Date().toISOString()
};

localStorage.setItem('currentPatient', JSON.stringify(updatedPatient));
localStorage.setItem(updatedPatient.id, JSON.stringify(updatedPatient));
```

---

### **6. JADWAL INFORMED CONSENT**

#### ✅ **SUDAH ADA: Schedule Consent Dialog**

**Status:** ✅ Sudah ada
- Dialog pilih tanggal & waktu
- Lock jika progress <80%
- Badge "Terjadwal" setelah pilih

---

#### ❌ **KURANG: Jadwal Tidak Sync ke Dokter**

**Yang Dibutuhkan:**
```
Pasien jadwalkan consent → 15 Maret 2026, 10:00 WIB
↓
Dokter lihat di dashboard:
┌─────────────────────────────────────────────┐
│ 📅 Jadwal Informed Consent Hari Ini         │
├─────────────────────────────────────────────┤
│ 10:00 - John Doe (MRN-2026-001)             │
│         Progress: 85% ✅                     │
│         [Konfirmasi] [Reschedule]           │
└─────────────────────────────────────────────┘
```

---

### **7. CHAT REAL-TIME DOKTER-PASIEN**

#### ✅ **SUDAH ADA: UI Chat**

**Status:** ✅ Sudah ada
- Contact Doctor dialog popup
- Halaman chat lengkap `/patient/contact-doctor`

---

#### ❌ **KURANG: Chat Tidak Real-time**

**Masalah:** 
- Chat hanya mock data
- Tidak ada sistem kirim pesan real
- Tidak ada notifikasi untuk dokter

**Yang Dibutuhkan:**
```
Option 1: LocalStorage Sync (Simple)
- Save messages ke localStorage dengan timestamp
- Polling setiap 2 detik untuk check new messages
- Update UI jika ada pesan baru

Option 2: Supabase Real-time (Advanced)
- Gunakan Supabase Realtime channels
- Push notification untuk pesan baru
- Typing indicator
```

---

### **8. PWA FEATURES**

#### ❌ **KURANG: Service Worker untuk Offline Mode**

**Status Sekarang:**
- ❌ Tidak ada service worker
- ❌ Tidak bisa akses offline

**Yang Dibutuhkan:**
```javascript
// File: /public/sw.js
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open('aconsia-v1').then((cache) => {
      return cache.addAll([
        '/',
        '/patient',
        '/doctor/dashboard',
        '/static/css/main.css',
        '/static/js/main.js'
      ]);
    })
  );
});
```

**File yang Perlu Dibuat:**
- `/public/sw.js` → Service worker
- `/public/manifest.json` → PWA manifest
- Update `/index.html` → Register service worker

---

#### ❌ **KURANG: Push Notifications**

**Yang Dibutuhkan:**
```
Event: Dokter approve pasien
↓
Send Push Notification ke Pasien:
"✅ Akun Anda telah disetujui! Mulai belajar sekarang."

Event: Progress pasien 80%
↓
Send Push Notification ke Dokter:
"🎉 John Doe sudah mencapai 80%. Siap jadwal IC."

Event: Jadwal IC besok
↓
Send Push Notification ke Pasien & Dokter:
"📅 Reminder: Jadwal IC besok pukul 10:00 WIB"
```

---

### **9. VALIDATION & ERROR HANDLING**

#### ❌ **KURANG: Validasi Field Registrasi**

**Masalah:** 
- NIK bisa diisi sembarang
- No. HP tidak ada format validation
- Email tidak di-validate

**Fix Required:**
```typescript
// NIK: Harus 16 digit angka
if (!/^\d{16}$/.test(formData.nik)) {
  errors.nik = "NIK harus 16 digit angka";
}

// No. HP: Format Indonesia
if (!/^(\+62|62|0)[0-9]{9,12}$/.test(formData.phone)) {
  errors.phone = "Format no. HP tidak valid";
}

// Email
if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
  errors.email = "Format email tidak valid";
}
```

---

#### ❌ **KURANG: Handle Duplicate MRN**

**Masalah:** Bisa daftar 2x dengan MRN sama

**Fix Required:**
```typescript
const checkDuplicateMRN = (mrn: string) => {
  const allPatients = Object.keys(localStorage)
    .filter(key => key.startsWith('patient-'))
    .map(key => JSON.parse(localStorage.getItem(key)));
  
  return allPatients.some(p => p.mrn === mrn);
};

if (checkDuplicateMRN(generatedMRN)) {
  // Generate MRN baru
}
```

---

### **10. UI/UX IMPROVEMENTS**

#### ❌ **KURANG: Loading States**

**Masalah:** Tidak ada loading indicator saat:
- Submit form registrasi
- Load patient data
- Filter materials

**Fix Required:**
```typescript
const [isLoading, setIsLoading] = useState(false);

const handleSubmit = async () => {
  setIsLoading(true);
  // ... submit logic
  setIsLoading(false);
};

{isLoading && <Spinner />}
```

---

#### ❌ **KURANG: Empty States**

**Masalah:** Jika tidak ada data, tampilan kosong tanpa pesan

**Fix Required:**
```tsx
{materials.length === 0 && (
  <EmptyState 
    icon={<BookOpen />}
    title="Belum Ada Materi"
    description="Menunggu dokter menyetujui dan memilih jenis anestesi"
  />
)}
```

---

## ✅ YANG SUDAH BAGUS & TIDAK PERLU DIUBAH

1. ✅ **Landing Page** - Clean, jelas, responsive
2. ✅ **Registrasi 4 Steps** - Sudah 23 fields lengkap
3. ✅ **Doctor Approval Form** - Ada panduan pemilihan anestesi
4. ✅ **Auto-Filter System** - Logic filtering sudah benar
5. ✅ **Dashboard Compact** - Sudah diperbaiki, tidak duplicate
6. ✅ **Real-time Chat UI** - Tampilan sudah bagus (tinggal backend)
7. ✅ **Pre-operative Assessment** - Form lengkap
8. ✅ **Schedule Consent** - Lock system sudah benar (≥80%)
9. ✅ **Responsive Design** - Mobile & desktop friendly
10. ✅ **Material Reader** - Section-based reading sudah ada

---

## 📋 PRIORITAS PENGERJAAN (URUTAN)

### **PRIORITY 1 (CRITICAL - Tanpa ini sistem tidak jalan):**
1. ✅ Fix mapping type anestesi (general vs General Anesthesia)
2. ✅ Buat 10 section materi untuk semua jenis anestesi
3. ✅ Implement AI Quiz Checkpoint setelah setiap section
4. ✅ Fix perhitungan comprehension score 0-100%

### **PRIORITY 2 (HIGH - Fitur inti yang dijanjikan):**
5. ✅ AI proaktif menanyakan pertanyaan
6. ✅ AI rekomendasi konten berdasarkan jawaban salah
7. ✅ List pasien pending di doctor dashboard (real data)
8. ✅ Monitoring progress pasien real-time oleh dokter

### **PRIORITY 3 (MEDIUM - Meningkatkan UX):**
9. ✅ Validasi form registrasi (NIK, phone, email)
10. ✅ Loading states & empty states
11. ✅ Save assessment data persistent
12. ✅ Sync jadwal consent ke dokter

### **PRIORITY 4 (LOW - Nice to have):**
13. ✅ Chat real-time dengan polling/Supabase
14. ✅ PWA service worker untuk offline
15. ✅ Push notifications
16. ✅ AI chatbot untuk tanya jawab

---

## 🎯 ESTIMASI EFFORT

| Item | Estimasi | Complexity |
|------|----------|------------|
| 10 section materi (50 materi total) | 8-10 jam | High |
| AI Quiz System | 4-6 jam | Medium |
| Fix comprehension tracking | 2-3 jam | Low |
| AI Recommendations Engine | 3-4 jam | Medium |
| Doctor dashboard real data | 2-3 jam | Low |
| Validations | 2-3 jam | Low |
| Real-time chat | 4-6 jam | Medium-High |
| PWA + Service Worker | 3-4 jam | Medium |
| Push Notifications | 4-5 jam | High |
| **TOTAL** | **32-44 jam** | - |

---

**Kesimpulan:** Aplikasi sudah punya **foundation yang solid** (46.9% complete), tapi **butuh content & AI features** untuk jadi sistem edukasi yang lengkap sesuai requirement tesis.

**Next Step:** Fokus ke Priority 1 terlebih dahulu!
