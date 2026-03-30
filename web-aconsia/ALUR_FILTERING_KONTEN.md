# 📋 ALUR FILTERING KONTEN BERDASARKAN JENIS ANESTESI

## 🎯 TUJUAN
Memastikan pasien HANYA menerima konten pembelajaran yang **RELEVAN** dengan kondisi medis mereka berdasarkan jenis anestesi yang dipilih dokter.

---

## 🔄 ALUR SISTEM (End-to-End)

### **STEP 1: PASIEN DAFTAR**
📍 Halaman: `/register` (PatientRegistrationSimplified.tsx)

**Yang diisi PASIEN:**
- ✅ 23 fields identitas (4 steps): Nama, NIK, TTL, Alamat, No. HP, Email, dll
- ✅ Data kesehatan: Tinggi, Berat, Golongan Darah, Alergi, Riwayat Penyakit
- ✅ Pilih dokter anestesi

**Yang TIDAK diisi pasien:**
- ❌ Diagnosis Medis → Diisi dokter
- ❌ Jenis Operasi → Diisi dokter
- ❌ Tanggal Operasi → Diisi dokter
- ❌ **JENIS ANESTESI** → Diisi dokter

**Status:** `pending` (Menunggu approval dokter)

---

### **STEP 2: DOKTER REVIEW & PILIH JENIS ANESTESI**
📍 Halaman: `/doctor/approval` (PatientApprovalNew.tsx)

**Dokter melihat:**
1. **Identitas Pasien** (Card kiri)
   - Nama, MRN, NIK, Tanggal Lahir, Umur, Gender, Telepon, Alamat

2. **Data Kesehatan** (Card kiri)
   - Tinggi, Berat, Golongan Darah
   - Alergi, Riwayat Penyakit, Obat Saat Ini, Riwayat Anestesi

3. **Form Data Medis** (Card kanan)
   - Input: **Diagnosis Medis** (wajib)
   - Input: **Jenis Operasi** (wajib)
   - Input: **Tanggal Operasi** (wajib)
   - **Dropdown: JENIS ANESTESI** (wajib) ⭐

---

### **STEP 3: PANDUAN PEMILIHAN JENIS ANESTESI**
📍 Halaman: `/doctor/approval` (PatientApprovalNew.tsx)

**Dokter melihat GUIDELINE BOX dengan 3 kategori:**

#### 🔴 **ANESTESI UMUM (General)**
**Indikasi:**
- Operasi mayor: bedah kepala, leher, dada, perut besar, jantung, otak
- Operasi lama (>2 jam)
- Pasien tidak kooperatif
- Bayi/anak kecil

**Contoh Kasus:**
- Kraniotomi (operasi otak)
- Operasi jantung (CABG, valve replacement)
- Laparotomi (bedah perut besar)
- Appendektomi (usus buntu)
- Kolesistektomi (kantung empedu)
- Tiroidektomi (kelenjar tiroid)

**Contoh Aplikasi:**
> Pasien A: Sakit di **kepala** (brain tumor)
> → Dokter pilih: **🔴 Anestesi Umum**
> → Sistem filter: Hanya tampilkan materi General Anesthesia

---

#### 🔵 **ANESTESI REGIONAL (Spinal/Epidural)**
**Indikasi:**
- Operasi ekstremitas bawah (kaki, paha)
- Operasi pelvis dan perineum
- Sectio Caesarea (operasi caesar)
- Pasien dengan risiko tinggi untuk GA (penyakit jantung, paru)

**Contoh Kasus:**
- Sectio Caesarea (SC/operasi caesar)
- Operasi hernia (inguinal, femoral)
- ORIF Femur (patah tulang paha)
- TUR-P (prostat)
- Hemorrhoidectomy (wasir)
- Operasi lutut (TKR)

**Contoh Aplikasi:**
> Pasien B: Hamil, akan SC
> → Dokter pilih: **🔵 Anestesi Spinal**
> → Sistem filter: Hanya tampilkan materi Regional Anesthesia (Spinal/Epidural)

---

#### 🟢 **ANESTESI LOKAL + SEDASI**
**Indikasi:**
- Operasi minor/kecil
- Operasi superfisial (permukaan kulit)
- Area terbatas
- Pasien kooperatif
- Rawat jalan (tidak rawat inap)

**Contoh Kasus:**
- Eksisi lipoma (benjolan lemak)
- Biopsi kulit/payudara
- Operasi katarak
- Ekstraksi gigi
- Sirkumsisi (sunat)
- Hernia kecil

**Contoh Aplikasi:**
> Pasien C: Lipoma di lengan
> → Dokter pilih: **🟢 Anestesi Lokal + Sedasi**
> → Sistem filter: Hanya tampilkan materi Local Anesthesia

---

### **STEP 4: DOKTER PILIH & APPROVE**
📍 Halaman: `/doctor/approval`

**Dropdown Options:**
```
[Pilih Jenis Anestesi Berdasarkan Kondisi Pasien]
🔴 Anestesi Umum (General Anesthesia)
🔵 Anestesi Spinal (Regional)
🔵 Anestesi Epidural (Regional)
🔵 Anestesi Regional (Blok Saraf)
🟢 Anestesi Lokal + Sedasi
```

**Sistem Auto-Filter Box:**
> ⚠️ SISTEM AUTO-FILTER: Setelah Anda memilih jenis anestesi, 
> sistem akan OTOMATIS MEMFILTER konten pembelajaran yang relevan. 
> Pasien hanya akan melihat materi yang sesuai dengan jenis anestesi yang Anda pilih.

**Setelah dokter klik "Setujui & Aktifkan Edukasi":**
1. Data tersimpan ke localStorage dengan field:
   - `diagnosis`: "Appendicitis Acute"
   - `surgeryType`: "Appendektomi"
   - `surgeryDate`: "2026-03-20"
   - `anesthesiaType`: "general" ⭐
   - `status`: "approved"

---

### **STEP 5: SISTEM AUTO-FILTER KONTEN**
📍 File: `/src/app/pages/patient/EnhancedPatientHome.tsx` (Line 203-206)

**Kode Filtering:**
```typescript
// Auto-filter materials based on patient's anesthesia type
const filteredMaterials = patientData?.anesthesiaType
  ? allMaterials.filter((material) => material.type === patientData.anesthesiaType)
  : allMaterials;
```

**Cara Kerja:**
1. Sistem baca `patientData.anesthesiaType` dari localStorage
2. Filter array `allMaterials` berdasarkan `material.type`
3. Hanya tampilkan materi yang `type`-nya sama dengan `anesthesiaType` pasien

**Contoh:**
```javascript
// Pasien A: anesthesiaType = "general"
// Materi yang tampil:
✅ "Apa itu Anestesi Umum?" (type: "general")
✅ "Risiko Anestesi Umum" (type: "general")
✅ "Persiapan Sebelum GA" (type: "general")

❌ "Apa itu Spinal Anestesi?" (type: "spinal") → TIDAK TAMPIL
❌ "Prosedur Anestesi Lokal" (type: "local") → TIDAK TAMPIL
```

---

### **STEP 6: PASIEN LIHAT MATERI TERPERSONALISASI**
📍 Halaman: `/patient` (EnhancedPatientHome.tsx)

**Tampilan Dashboard Pasien:**
```
┌─────────────────────────────────────────┐
│ 📚 Materi Pembelajaran                  │
│    Auto-filter: General Anesthesia      │ ← Badge info
├─────────────────────────────────────────┤
│ ✅ Apa itu Anestesi Umum?               │
│ ✅ Risiko & Komplikasi Anestesi Umum    │
│ ✅ Persiapan Sebelum Operasi GA         │
│ ✅ Prosedur Anestesi Umum               │
│ ✅ Pemulihan Setelah GA                 │
└─────────────────────────────────────────┘
```

**Pasien TIDAK akan melihat:**
- ❌ Materi tentang Spinal Anestesi
- ❌ Materi tentang Epidural
- ❌ Materi tentang Anestesi Lokal

---

## 🗂️ DATA STRUCTURE

### **Material Object:**
```typescript
{
  id: "mat-001",
  title: "Apa itu Anestesi Umum?",
  description: "Penjelasan lengkap tentang...",
  type: "general", // ← Key field untuk filtering
  status: "not_started",
  readingProgress: 0,
  estimatedTime: "5 menit"
}
```

### **Patient Data Object:**
```typescript
{
  id: "patient-001",
  fullName: "John Doe",
  mrn: "MRN-2026-001",
  // ... other patient fields
  diagnosis: "Appendicitis Acute", // Diisi dokter
  surgeryType: "Appendektomi",      // Diisi dokter
  surgeryDate: "2026-03-20",        // Diisi dokter
  anesthesiaType: "general",        // Diisi dokter ⭐
  status: "approved",
  comprehensionScore: 0
}
```

---

## 📊 MAPPING JENIS ANESTESI

| Nilai Database | Label Display | Material Type Filter |
|----------------|---------------|---------------------|
| `general` | Anestesi Umum | `type: "general"` |
| `spinal` | Anestesi Spinal | `type: "spinal"` atau `"regional"` |
| `epidural` | Anestesi Epidural | `type: "epidural"` atau `"regional"` |
| `regional` | Anestesi Regional | `type: "regional"` |
| `local` | Anestesi Lokal + Sedasi | `type: "local"` |

---

## ✅ VALIDASI SISTEM

### **Test Case 1: Pasien dengan Operasi Kepala**
1. Dokter lihat: Diagnosis "Brain Tumor", Operasi "Kraniotomi"
2. Dokter pilih: **🔴 Anestesi Umum**
3. Sistem simpan: `anesthesiaType: "general"`
4. Pasien lihat: Hanya materi dengan `type: "general"`
5. ✅ **PASS** - Pasien tidak bingung dengan materi spinal/lokal

### **Test Case 2: Pasien dengan Operasi Caesar**
1. Dokter lihat: Diagnosis "Gravida 2", Operasi "Sectio Caesarea"
2. Dokter pilih: **🔵 Anestesi Spinal**
3. Sistem simpan: `anesthesiaType: "spinal"`
4. Pasien lihat: Hanya materi dengan `type: "spinal"` atau `"regional"`
5. ✅ **PASS** - Pasien hanya belajar tentang regional anestesi

### **Test Case 3: Pasien dengan Lipoma Kecil**
1. Dokter lihat: Diagnosis "Lipoma", Operasi "Eksisi Lipoma"
2. Dokter pilih: **🟢 Anestesi Lokal + Sedasi**
3. Sistem simpan: `anesthesiaType: "local"`
4. Pasien lihat: Hanya materi dengan `type: "local"`
5. ✅ **PASS** - Pasien tidak lihat materi GA yang menakutkan

---

## 🚨 ERROR HANDLING

### **Jika pasien belum di-approve dokter:**
```typescript
const filteredMaterials = patientData?.anesthesiaType
  ? allMaterials.filter((material) => material.type === patientData.anesthesiaType)
  : allMaterials; // Tampilkan semua atau array kosong
```

**Rekomendasi:** Tampilkan pesan "Menunggu dokter menentukan jenis anestesi"

### **Jika anesthesiaType null/undefined:**
```
patientData.anesthesiaType === null
→ Badge: "Belum Ditentukan"
→ Materi: Kosong atau pesan "Menunggu approval"
```

---

## 📈 BENEFIT SISTEM INI

1. ✅ **Tidak membingungkan pasien** - Hanya konten relevan
2. ✅ **Mengurangi kecemasan** - Pasien GA tidak baca risiko spinal yang tidak relevan
3. ✅ **Meningkatkan pemahaman** - Fokus pada satu jenis anestesi
4. ✅ **Efisiensi waktu** - Pasien tidak buang waktu baca materi tidak relevan
5. ✅ **Personalisasi edukasi** - Sesuai kondisi medis masing-masing

---

## 🔗 FILE TERKAIT

1. **Approval Dokter:** `/src/app/pages/doctor/PatientApprovalNew.tsx`
2. **Dashboard Pasien:** `/src/app/pages/patient/EnhancedPatientHome.tsx`
3. **Registrasi Pasien:** `/src/app/pages/patient/PatientRegistrationSimplified.tsx`

---

**Last Updated:** 18 Maret 2026  
**Author:** AI Assistant for ACONSIA Thesis Project
