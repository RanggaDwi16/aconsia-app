# 🧪 TEST SINKRONISASI SISTEM

## Cara Testing Aplikasi Setelah Perbaikan

### 🔧 Persiapan

1. **Bersihkan localStorage** (untuk testing dari awal):
```javascript
// Buka Console Browser (F12)
localStorage.clear();
location.reload();
```

---

## 📋 Test Scenario 1: Sinkronisasi Data Dokter & Pasien

### Langkah Testing:

#### 1. Daftar sebagai Pasien Baru
- Akses: `/patient/register`
- Isi data:
  - Nama: `Test Pasien Sinkronisasi`
  - MRN: `TEST-001`
  - Jenis Operasi: `Appendectomy`
  - Tanggal Operasi: (pilih tanggal)
- Klik **Daftar**

**✅ Expected Result:**
- Status pasien: `pending`
- Anesthesia Type: `null` (belum ada)
- Materi edukasi: **KOSONG** (menunggu dokter)

---

#### 2. Login sebagai Dokter
- Akses: `/doctor/login`
- Email: `doctor@demo.com`
- Password: `doctor123`

---

#### 3. Dokter Approval Pasien
- Akses: `/doctor/approval`
- Cari pasien `Test Pasien Sinkronisasi`
- Pilih jenis anestesi: **General Anesthesia**
- Klik **Approve**

**✅ Expected Result:**
- Status pasien berubah: `approved`
- Anesthesia Type: `General Anesthesia`

---

#### 4. Cek Dashboard Dokter
- Akses: `/doctor/content`
- Lihat daftar materi

**✅ Expected Result:**
- Muncul **50 materi total** (10 per jenis anestesi × 5 jenis)
- Filter General Anesthesia → **10 sections** (gen-1 sampai gen-10)

---

#### 5. Login sebagai Pasien (yang sama)
- Logout dari akun dokter
- Login sebagai pasien `Test Pasien Sinkronisasi`

---

#### 6. Cek Dashboard Pasien
- Akses: `/patient` atau `/patient/education`

**✅ Expected Result:**
- Muncul **TEPAT 10 sections** untuk General Anesthesia
- Section yang muncul **SAMA PERSIS** dengan yang dokter lihat:
  - Section 1: Definisi & Tujuan Anestesi Umum
  - Section 2: Prosedur & Tahapan Anestesi Umum
  - Section 3: Risiko & Komplikasi Anestesi Umum
  - ... (sampai section 10)

**🎯 VALIDASI SINKRONISASI:**
```javascript
// Buka Console Browser
const patient = JSON.parse(localStorage.getItem("currentPatient"));
console.log("Anesthesia Type:", patient.anesthesiaType); // "General Anesthesia"

// Load materials
import { getMaterialsByType } from './src/data/learningMaterials';
const materials = getMaterialsByType(patient.anesthesiaType);
console.log("Total Materials:", materials.length); // HARUS 10
console.log("Materials:", materials.map(m => m.title));
```

**❌ FAILED jika:**
- Pasien lihat lebih dari 10 sections
- Pasien lihat sections dari jenis anestesi lain
- Jumlah sections berbeda dengan dokter

---

## 📋 Test Scenario 2: AI Chat - Hanya di Akhir Materi

### Langkah Testing:

#### 1. Status Awal (Belum Baca Materi)
- Login sebagai pasien (yang sudah approved)
- Akses: `/patient/education`

**✅ Expected Result:**
- Progress: **0%**
- AI Chat Status: **🔒 Terkunci**
- Message: "Please complete all materials first. 0/10 completed"
- **TIDAK ADA** tombol "Mulai AI Chat"

---

#### 2. Baca Section 1-5 (Setengah Materi)
- Klik section 1 → Baca sampai progress 100%
- Tandai selesai
- Ulangi untuk section 2-5

**✅ Expected Result:**
- Progress: **50%** (5/10 completed)
- AI Chat Status: **🔒 Terkunci**
- Message: "Please complete all materials first. 5/10 completed"
- **TIDAK ADA** tombol "Mulai AI Chat"

---

#### 3. Baca Section 6-9 (Hampir Selesai)
- Lanjutkan membaca section 6-9
- Tandai semua selesai 100%

**✅ Expected Result:**
- Progress: **90%** (9/10 completed)
- AI Chat Status: **🔒 Terkunci**
- Message: "Please complete all materials first. 9/10 completed"
- **TIDAK ADA** tombol "Mulai AI Chat"

---

#### 4. Baca Section 10 (Materi Terakhir)
- Baca section 10 sampai 100%
- Tandai selesai

**✅ Expected Result:**
- Progress: **100%** (10/10 completed)
- AI Chat Status: **✅ Tersedia**
- Message: "All materials completed. AI Chat is now available!"
- Muncul **Card Hijau** dengan tombol **"Mulai AI Chat Evaluation"**
- Klik tombol → redirect ke `/patient/chat-hybrid`

**🎯 VALIDASI AI CHAT ACCESS:**
```javascript
// Buka Console Browser
const patient = JSON.parse(localStorage.getItem("currentPatient"));
const progressKey = `reading_progress_${patient.id}`;
const progress = JSON.parse(localStorage.getItem(progressKey));

// Hitung completed materials
Object.values(progress).filter(p => p === 100).length; // HARUS 10

// Test canAccessAIChat
import { canAccessAIChat } from './src/app/utils/dataSync';
const chatAccess = canAccessAIChat(patient.id);
console.log(chatAccess.canAccess); // HARUS true
```

**❌ FAILED jika:**
- AI Chat muncul sebelum semua materi selesai
- AI Chat tidak muncul meski semua materi sudah 100%
- Bisa akses `/patient/chat-hybrid` sebelum materi selesai

---

## 📋 Test Scenario 3: Sequential Reading (Anti-Skip)

### Langkah Testing:

#### 1. Pasien Baru Approved
- Status: `approved`
- Progress: **0%** (belum baca apapun)

---

#### 2. Coba Skip ke Section 5 Langsung
- Akses: `/patient/education`
- Coba klik tombol "Mulai Baca" di section 5

**✅ Expected Result:**
- Tombol **DISABLED** (tidak bisa diklik)
- Muncul pesan: **"🔒 Selesaikan section sebelumnya"**
- Icon: 🔒 (Lock)

---

#### 3. Baca Section 1 (Pertama)
- Klik section 1 → **Tombol ENABLED** (bisa diklik)
- Baca sampai 100% → Tandai selesai

**✅ Expected Result:**
- Section 1: ✅ Completed
- Section 2: 🔓 **UNLOCK** (tombol enabled)
- Section 3-10: 🔒 Masih locked

---

#### 4. Skip Section 2, Coba Buka Section 3
- Coba klik section 3 (padahal section 2 belum dibaca)

**✅ Expected Result:**
- Section 3: **MASIH LOCKED**
- Tombol disabled
- Message: "🔒 Selesaikan section sebelumnya"

---

#### 5. Baca Section 2
- Baca section 2 sampai 100%

**✅ Expected Result:**
- Section 2: ✅ Completed
- Section 3: 🔓 **UNLOCK**
- Section 4-10: 🔒 Masih locked

**🎯 VALIDASI SEQUENTIAL LOGIC:**
```javascript
// Logic untuk cek lock/unlock
const isLocked = (index, readingProgress, materials) => {
  if (index === 0) return false; // Section 1 selalu unlock
  
  const prevMaterial = materials[index - 1];
  const prevProgress = readingProgress[prevMaterial.id] || 0;
  
  return prevProgress < 100; // Lock jika section sebelumnya belum 100%
};

// Test
console.log(isLocked(0, {}, materials)); // false (section 1 unlock)
console.log(isLocked(2, { "gen-1": 100, "gen-2": 0 }, materials)); // true (section 2 belum selesai)
console.log(isLocked(2, { "gen-1": 100, "gen-2": 100 }, materials)); // false (section 2 sudah selesai)
```

**❌ FAILED jika:**
- Bisa skip section
- Section unlock meski section sebelumnya belum 100%
- Bisa akses materi secara random

---

## 📋 Test Scenario 4: Dashboard Admin Berfungsi

### Langkah Testing:

#### 1. Akses Dashboard Admin
- Akses: `/admin`
- Login:
  - Email: `admin@demo.com`
  - Password: `admin123`

**✅ Expected Result:**
- **TIDAK ADA ERROR**
- Dashboard muncul dengan baik
- Muncul statistik:
  - Total Pasien
  - Pending
  - In Progress
  - Ready
  - Completed
  - Avg Comprehension Score

---

#### 2. Real-Time Sync
- Biarkan dashboard terbuka
- Buka tab baru → Login sebagai pasien
- Baca 1 section → Tandai selesai
- Kembali ke tab admin

**✅ Expected Result:**
- Dalam **2 detik**, dashboard admin **AUTO-UPDATE**
- Comprehension score pasien naik
- Status berubah dari `approved` → `in_progress`

---

#### 3. Cek Data Pasien
- Scroll ke bagian "Status Pasien Real-Time"
- Cari pasien yang tadi login

**✅ Expected Result:**
- Muncul data pasien:
  - Nama
  - MRN
  - Jenis Operasi
  - Jenis Anestesi
  - **Pemahaman: X%** (sesuai progress)
  - Status badge (pending/in_progress/ready)

---

#### 4. Cek Distribusi Anestesi
- Lihat chart "Distribusi Jenis Anestesi"

**✅ Expected Result:**
- Muncul bar chart:
  - General Anesthesia: X pasien
  - Spinal Anesthesia: X pasien
  - Epidural Anesthesia: X pasien
  - Regional Anesthesia: X pasien
  - Local + Sedation: X pasien

---

#### 5. Logout Admin
- Klik tombol "Logout"

**✅ Expected Result:**
- Kembali ke halaman login admin
- Session cleared
- Tidak bisa akses `/admin` tanpa login lagi

**❌ FAILED jika:**
- Dashboard error/crash
- Data tidak muncul
- Auto-sync tidak berfungsi
- Logout tidak bekerja

---

## 📋 Test Scenario 5: Validasi Anti-Duplikasi

### Langkah Testing:

#### 1. Cek Console Log
```javascript
// Buka Console Browser (F12)
const patient = JSON.parse(localStorage.getItem("currentPatient"));

import { validateMaterialsSync } from './src/app/utils/dataSync';
const validation = validateMaterialsSync(patient.id, patient.anesthesiaType);

console.log("Is Valid:", validation.isValid); // HARUS true
console.log("Errors:", validation.errors); // HARUS []
console.log("Doctor Materials:", validation.doctorMaterialsCount); // HARUS 10
console.log("Patient Materials:", validation.patientMaterialsCount); // HARUS 10
```

**✅ Expected Result:**
```json
{
  "isValid": true,
  "errors": [],
  "doctorMaterialsCount": 10,
  "patientMaterialsCount": 10
}
```

---

#### 2. Cek Duplicate IDs
```javascript
import { getMaterialsByType } from './src/data/learningMaterials';
const materials = getMaterialsByType("General Anesthesia");

// Ambil semua ID
const ids = materials.map(m => m.id);
console.log("IDs:", ids);

// Cek duplikasi
const uniqueIds = new Set(ids);
console.log("Unique IDs:", uniqueIds.size);
console.log("Total IDs:", ids.length);
console.log("Has Duplicate:", uniqueIds.size !== ids.length); // HARUS false
```

**✅ Expected Result:**
- `uniqueIds.size === ids.length` (10)
- `Has Duplicate: false`

**❌ FAILED jika:**
- Ada ID yang duplikat
- Jumlah materi tidak sesuai (bukan 10)

---

## 🎯 Checklist Keseluruhan

### ✅ Sinkronisasi Data
- [ ] Dokter lihat 10 sections untuk jenis anestesi tertentu
- [ ] Pasien lihat TEPAT 10 sections yang sama
- [ ] Tidak ada duplikasi data
- [ ] Update dari dokter tersinkronisasi ke pasien

### ✅ AI Chat Placement
- [ ] AI Chat locked saat progress 0-99%
- [ ] AI Chat unlock saat progress 100%
- [ ] Tidak bisa akses AI Chat sebelum semua materi selesai
- [ ] CTA "Mulai AI Chat" hanya muncul saat 100%

### ✅ Sequential Reading
- [ ] Section 1 unlock default
- [ ] Section 2-10 locked sampai section sebelumnya 100%
- [ ] Tidak bisa skip section
- [ ] Progress tersimpan di localStorage

### ✅ Dashboard Admin
- [ ] Login berfungsi (admin@demo.com / admin123)
- [ ] Dashboard muncul tanpa error
- [ ] Statistik tampil dengan benar
- [ ] Real-time sync berfungsi (2 detik)
- [ ] Logout berfungsi

### ✅ Validasi Sistem
- [ ] Tidak ada duplicate material IDs
- [ ] Jumlah materi selalu 10 per jenis anestesi
- [ ] validateMaterialsSync() return isValid: true
- [ ] canAccessAIChat() validasi dengan benar

---

## 🐛 Troubleshooting

### Masalah: Materi tidak muncul di pasien
**Solusi:**
```javascript
// Cek apakah anesthesia type sudah diset
const patient = JSON.parse(localStorage.getItem("currentPatient"));
console.log(patient.anesthesiaType); // Harus ada, bukan null

// Jika null, artinya dokter belum approve
// Lakukan approval di /doctor/approval
```

### Masalah: AI Chat tidak unlock meski sudah 100%
**Solusi:**
```javascript
// Cek reading progress
const patient = JSON.parse(localStorage.getItem("currentPatient"));
const progress = JSON.parse(localStorage.getItem(`reading_progress_${patient.id}`));
console.log(progress);

// Pastikan semua 10 sections = 100
// Jika ada yang kurang, baca ulang section tersebut
```

### Masalah: Dashboard Admin error
**Solusi:**
```javascript
// Clear cache dan reload
localStorage.clear();
location.reload();

// Login ulang admin@demo.com / admin123
```

---

**Status**: ✅ **SIAP UNTUK TESTING**

Gunakan checklist ini untuk memvalidasi bahwa sistem sudah berfungsi sesuai spesifikasi!
