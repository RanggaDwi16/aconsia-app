# 🎯 ALUR SISTEM YANG BENAR - Edukasi Informed Consent Anestesi

## 📋 Overview

Sistem ini dirancang untuk **edukasi pasien SEBELUM menandatangani informed consent**, bukan untuk pengumpulan tanda tangan digital. Fokus utama adalah memastikan pasien memahami prosedur anestesi yang akan dijalani.

---

## 🔄 ALUR LENGKAP SISTEM

```
┌─────────────────────────────────────────────────────────────┐
│                    1. PENDAFTARAN PASIEN                      │
│                                                               │
│  Pasien → Daftar Online → Pilih Dokter → Input Data Medis   │
│  • Nama, Umur, Jenis Kelamin                                 │
│  • Jenis Operasi yang Direncanakan                          │
│  • Riwayat Penyakit, Alergi, Obat                          │
│  • Status ASA (jika diketahui)                              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│              2. REVIEW & APPROVAL DOKTER                      │
│                                                               │
│  Dokter → Lihat Pendaftaran Baru                            │
│  • Review diagnosis medis pasien                            │
│  • Pertimbangan: jenis operasi, ASA, riwayat medis         │
│  • KEPUTUSAN: Pilih jenis anestesi yang sesuai             │
│    ✓ Anestesi Umum                                          │
│    ✓ Anestesi Spinal                                        │
│    ✓ Anestesi Epidural                                      │
│    ✓ Anestesi Regional                                      │
│    ✓ Anestesi Lokal + Sedasi                               │
│  • ACC → Pasien masuk sistem                                │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│         3. SISTEM AUTO-FILTER KONTEN (AI-POWERED)            │
│                                                               │
│  Sistem Otomatis:                                            │
│  • Ambil jenis anestesi yang dipilih dokter                 │
│  • Filter konten edukasi sesuai jenis anestesi              │
│  • HANYA tampilkan konten yang relevan ke pasien            │
│                                                               │
│  Contoh:                                                     │
│  - Pasien Caesar (Spinal) → HANYA lihat konten Spinal      │
│  - Pasien Appendix (Umum) → HANYA lihat konten Umum        │
│  - Pasien Hernia (Regional) → HANYA lihat konten Regional  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│              4. EDUKASI PASIEN (PERSONALIZED)                 │
│                                                               │
│  Pasien Login → Akses Portal Edukasi                        │
│                                                               │
│  ┌───────────────────────────────────────────┐              │
│  │  📚 MATERI EDUKASI                        │              │
│  │  • Video penjelasan anestesi              │              │
│  │  • Artikel: Apa itu anestesi [TYPE]?      │              │
│  │  • Infografis: Prosedur step-by-step      │              │
│  │  • FAQ: Pertanyaan umum                   │              │
│  │  • Risiko & komplikasi                    │              │
│  │  • Persiapan sebelum operasi              │              │
│  └───────────────────────────────────────────┘              │
│                                                               │
│  ┌───────────────────────────────────────────┐              │
│  │  🤖 AI CHATBOT (24/7)                     │              │
│  │  • Tanya jawab real-time                  │              │
│  │  • Mode empatik (menenangkan)             │              │
│  │  • Context-aware (tahu jenis anestesi)    │              │
│  └───────────────────────────────────────────┘              │
│                                                               │
│  ┌───────────────────────────────────────────┐              │
│  │  ✅ KUIS PEMAHAMAN (OPSIONAL)             │              │
│  │  • Evaluasi pemahaman pasien              │              │
│  │  • Bukan mandatory, tapi recommended      │              │
│  │  • Feedback langsung dengan penjelasan    │              │
│  └───────────────────────────────────────────┘              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│           5. MONITORING DOKTER (REAL-TIME TRACKING)           │
│                                                               │
│  Dokter → Dashboard                                          │
│  • Lihat progress edukasi pasien                            │
│  • Tracking engagement (berapa lama baca, nonton)           │
│  • Skor kuis (jika pasien ambil)                           │
│  • Interaksi chatbot (pertanyaan apa yang ditanya)         │
│  • Status kesiapan: 🔴 Perlu Follow-up / 🟢 Siap           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│            6. SIAP UNTUK INFORMED CONSENT (FISIK)             │
│                                                               │
│  Saat H-1 atau Hari H:                                      │
│  • Dokter bertemu pasien secara langsung                    │
│  • Diskusi final, tanya jawab                               │
│  • Pasien SUDAH PAHAM karena sudah edukasi                  │
│  • Tanda tangan informed consent FISIK (kertas)             │
│  • Sistem ini BUKAN pengganti TTD fisik!                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 PERBEDAAN PENTING

### ❌ **YANG SALAH (Sebelumnya):**
- Pasien langsung dapat akses semua konten
- Tidak ada proses approval dokter
- Kuis mandatory untuk bisa lanjut
- Sistem seperti e-learning biasa

### ✅ **YANG BENAR (Sekarang):**
- **Pasien daftar** → pilih dokter → input data medis
- **Dokter review** → lihat diagnosis → **pilih jenis anestesi**
- **Sistem filter** → konten otomatis disesuaikan
- **Pasien edukasi** → baca materi yang **relevan saja**
- **Kuis opsional** → untuk evaluasi, bukan gate-keeping
- **Dokter monitor** → real-time tracking progress
- **TTD fisik** → tetap di rumah sakit (sistem ini hanya edukasi)

---

## 📊 STATUS FLOW PASIEN

### **Status 1: PENDING** 🟠
- Pasien baru daftar
- Menunggu approval dokter
- Belum bisa akses konten

### **Status 2: APPROVED** 🔵
- Dokter sudah ACC
- Jenis anestesi sudah ditentukan
- Konten sudah di-filter
- Pasien bisa mulai belajar

### **Status 3: IN EDUCATION** 🟡
- Pasien sedang belajar
- Progress masih < 80%
- Belum siap informed consent

### **Status 4: READY** 🟢
- Progress edukasi ≥ 80%
- Kuis (jika diambil) ≥ 80%
- Engagement tinggi
- **SIAP untuk TTD informed consent**

### **Status 5: COMPLETED** ✅
- Informed consent sudah ditandatangani
- Operasi selesai
- Data masuk archive

---

## 🤖 SISTEM REKOMENDASI KONTEN (AI)

### **Cara Kerja:**

```javascript
// Pseudo-code
function getContentForPatient(patient) {
  // Ambil jenis anestesi dari approval dokter
  const anesthesiaType = patient.approvedAnesthesiaType;
  
  // Filter konten
  const relevantContent = allContent.filter(content => {
    return content.anesthesiaType === anesthesiaType ||
           content.anesthesiaType === 'general'; // Konten umum untuk semua
  });
  
  return relevantContent;
}

// Contoh:
Patient A (Caesar - Spinal):
  ✅ Video: Apa itu Anestesi Spinal
  ✅ Artikel: Prosedur Anestesi Spinal
  ✅ Infografis: Persiapan Spinal
  ✅ Konten Umum: Puasa Sebelum Operasi
  ❌ Video: Anestesi Umum (tidak relevan)
  ❌ Artikel: Intubasi (tidak relevan)

Patient B (Appendix - Umum):
  ✅ Video: Apa itu Anestesi Umum
  ✅ Artikel: Proses Intubasi
  ✅ Infografis: Recovery dari Anestesi Umum
  ✅ Konten Umum: Puasa Sebelum Operasi
  ❌ Video: Anestesi Spinal (tidak relevan)
  ❌ Artikel: Epidural (tidak relevan)
```

---

## 📱 HALAMAN-HALAMAN PENTING

### **1. Patient Registration Page** ✅
`/patient/register`

**Fitur:**
- Form pendaftaran lengkap
- Pilih dokter dari dropdown
- Input data medis (riwayat, alergi, obat)
- Input jenis operasi
- Submit → status PENDING

---

### **2. Doctor Approval Page** ✅
`/doctor/approval`

**Fitur:**
- List pasien pending
- Detail data medis pasien
- **Dropdown pilih jenis anestesi**
- Tombol ACC / Reject
- Notes untuk pasien
- Setelah ACC → konten auto-filter

---

### **3. Patient Dashboard** (Updated)
`/patient`

**Tampilan berbeda berdasarkan status:**

#### Status PENDING:
```
⏳ Pendaftaran Anda sedang direview oleh dokter
   Mohon tunggu...
```

#### Status APPROVED:
```
✅ Selamat! Dokter sudah menyetujui Anda
   Jenis Anestesi: [TYPE]
   
   📚 Mulai Belajar Sekarang
   🤖 Tanya AI Chatbot
```

#### Status READY:
```
🎉 Anda sudah siap untuk informed consent!
   Progress: 95%
   
   💾 Download Laporan Pemahaman (PDF)
```

---

### **4. Patient Education Page** (Updated)
`/patient/education`

**HANYA tampilkan konten sesuai jenis anestesi:**

```
Jenis Anestesi Anda: Anestesi Spinal

📹 Video Edukasi (3)
  ✅ Apa itu Anestesi Spinal? (10:24)
  ✅ Prosedur Penyuntikan Spinal (8:45)
  ✅ Efek Samping & Cara Mengatasinya (12:10)

📄 Artikel (4)
  ✅ Panduan Lengkap Anestesi Spinal
  ✅ Persiapan Sebelum Anestesi Spinal
  ✅ Yang Boleh & Tidak Boleh Dilakukan
  ✅ Recovery Setelah Anestesi Spinal

❓ FAQ (8 pertanyaan)
  ✅ Apakah suntikan spinal sakit?
  ✅ Berapa lama efeknya bertahan?
  ...
```

---

### **5. Doctor Dashboard** (Updated)
`/doctor`

**Card tambahan:**

```
┌─────────────────────────────┐
│  🟠 PENDING APPROVAL         │
│                              │
│  3 pasien menunggu review   │
│                              │
│  [Lihat & Review]            │
└─────────────────────────────┘

┌─────────────────────────────┐
│  📊 PATIENT STATUS           │
│                              │
│  🟢 Ready: 12 pasien         │
│  🟡 In Education: 8 pasien   │
│  🔴 Need Follow-up: 2 pasien │
└─────────────────────────────┘
```

---

## 🎓 KUIS: MANDATORY vs OPSIONAL

### **Rekomendasi: OPSIONAL (Tapi Encouraged)** ⭐

**Alasan:**
1. ✅ Tujuan utama: **Edukasi**, bukan testing
2. ✅ Pasien mungkin anxious, kuis bisa tambah stress
3. ✅ Kuis sebagai **self-assessment tool**, bukan gate-keeper
4. ✅ Dokter tetap bisa lihat engagement lain (video watched, artikel dibaca)

**Implementasi:**
```
📊 Evaluasi Pemahaman Anda (Opsional)

Anda sudah menyelesaikan materi edukasi!

Ingin menguji pemahaman Anda?
• 10 pertanyaan pilihan ganda
• Feedback langsung dengan penjelasan
• Hasil bisa dilihat dokter

[Mulai Kuis] [Lewati]

*Kuis tidak mandatory, tapi sangat membantu dokter 
 mengevaluasi kesiapan Anda
```

---

## 📄 PDF REPORT (Updated)

### **Patient Comprehension Report:**

**Isi laporan:**
```
LAPORAN PEMAHAMAN PASIEN

Nama: Ibu Sarah Wijaya
Jenis Anestesi: Anestesi Spinal

PROGRESS EDUKASI:
✅ Video ditonton: 3/3 (100%)
✅ Artikel dibaca: 4/4 (100%)
✅ Waktu belajar: 2 jam 15 menit
✅ Interaksi chatbot: 12 pertanyaan

KUIS (Opsional):
✅ Diambil: Ya
✅ Skor: 90% (9/10 benar)

STATUS: SIAP UNTUK INFORMED CONSENT ✅

Rekomendasi:
Pasien menunjukkan pemahaman yang sangat baik 
tentang prosedur anestesi spinal. Tidak ada 
area yang perlu edukasi tambahan.

---
Dokumen ini untuk rekam medis, BUKAN pengganti
tanda tangan informed consent fisik.
```

---

## 🔐 DATA YANG DISIMPAN

### **Tabel: patients**
```sql
- id
- full_name
- date_of_birth
- gender
- phone
- email
- selected_doctor_id
- planned_surgery
- surgery_date
- medical_history
- allergies
- current_medications
- asa_status
- status (pending/approved/rejected)
- approved_anesthesia_type ⭐ PENTING
- approval_date
- approval_notes
- created_at
```

### **Tabel: contents**
```sql
- id
- title
- description
- type (video/article/infographic)
- anesthesia_type ⭐ FILTER KEY
  - general
  - spinal
  - epidural
  - regional
  - local
  - all (untuk konten umum)
- content_url
- thumbnail_url
- duration (untuk video)
- created_by_doctor_id
- created_at
```

### **Tabel: patient_progress**
```sql
- id
- patient_id
- content_id
- viewed (boolean)
- duration_watched (seconds)
- completed (boolean)
- timestamp
```

---

## ✅ KESIMPULAN

### **SISTEM INI ADALAH:**
✅ Platform **EDUKASI** berbasis AI  
✅ **Personalized content** sesuai jenis anestesi  
✅ **Doctor-driven** (dokter yang tentukan jenis anestesi)  
✅ **Patient-centered** (konten relevan, tidak overwhelming)  
✅ **Tracking & monitoring** real-time  
✅ **Supporting tool** untuk informed consent, BUKAN penggantinya  

### **SISTEM INI BUKAN:**
❌ Platform e-signature untuk informed consent  
❌ E-learning biasa dengan semua materi  
❌ Quiz-based system (kuis opsional)  
❌ Pengganti konsultasi dokter-pasien  

---

## 🎯 VALUE PROPOSITION

**Untuk Pasien:**
- ✅ Edukasi yang **relevan** (tidak bingung dengan info yang tidak perlu)
- ✅ Belajar dengan **tempo sendiri** (24/7 access)
- ✅ **Mengurangi kecemasan** (sudah paham sebelum operasi)
- ✅ **AI Chatbot** siap menjawab kapan saja

**Untuk Dokter:**
- ✅ **Hemat waktu** (tidak perlu jelaskan dari awal)
- ✅ **Monitoring real-time** (tahu pasien sudah paham atau belum)
- ✅ **Efisiensi** (satu kali upload konten, dipakai banyak pasien)
- ✅ **Data-driven** (laporan pemahaman terukur)

**Untuk Rumah Sakit:**
- ✅ **Compliance** (dokumentasi edukasi lengkap)
- ✅ **Patient satisfaction** meningkat
- ✅ **Legal protection** (bukti pasien sudah diedukasi)
- ✅ **Quality improvement** (analytics untuk evaluasi)

---

**🚀 Sistem sudah siap untuk deployment & user testing!**

---

*Dokumentasi ini menjelaskan alur sistem yang BENAR dan FINAL untuk tesis.*
