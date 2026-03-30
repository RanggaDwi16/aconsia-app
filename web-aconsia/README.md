# 🏥 ACONSIA - Anesthesia Consent Information System with AI

> Sistem Informasi Berbasis AI untuk Edukasi Informed Consent Anestesi

[![React](https://img.shields.io/badge/React-18-blue)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5-blue)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.0-cyan)](https://tailwindcss.com/)
[![PWA](https://img.shields.io/badge/PWA-Enabled-green)](https://web.dev/progressive-web-apps/)

---

## 📋 **Tentang Proyek**

ACONSIA adalah aplikasi web Progressive Web App (PWA) yang dirancang untuk **edukasi informed consent anestesi**. Aplikasi ini fokus pada pembelajaran interaktif berbasis AI, bukan pengumpulan tanda tangan digital.

### **Alur Sistem:**
```
Pasien Daftar → Pilih Dokter → Dokter Review & Pilih Jenis Anestesi 
→ Sistem Filter Konten Otomatis → Pasien Belajar dari Materi 
→ AI Proaktif Menguji Pemahaman → Progress ≥80% 
→ Jadwalkan TTD Fisik di RS
```

---

## ✨ **Fitur Utama**

### **1. 🤖 AI Proaktif**
- AI yang **menanyakan pertanyaan** ke pasien (bukan pasien yang bertanya)
- Menguji pemahaman dengan pertanyaan follow-up
- Rekomendasikan materi jika ada area yang lemah

### **2. 📚 Materi Tanpa Video**
- Pure artikel/teks berbasis scroll
- Auto-detect reading progress (0-100%)
- Time spent tracking
- No video - fokus reading comprehension

### **3. 📊 Tracking Pemahaman (Persentase)**
- Comprehension score 0-100%
- Real-time progress bar
- Multi-factor scoring:
  - Reading progress (40%)
  - AI chat engagement (30%)
  - Quiz performance (20% - optional)
  - Content revisit (10%)

### **4. 🎯 Konten Terpersonalisasi**
- Otomatis filter berdasarkan jenis anestesi
- Hanya tampilkan materi yang relevan
- Dokter yang menentukan jenis anestesi

### **5. 📅 Sistem Penjadwalan**
- Unlock scheduling saat progress ≥80%
- Calendar-based booking
- Konfirmasi otomatis (email, SMS)
- Reminder H-1

### **6. 📱 Progressive Web App (PWA)**
- Installable seperti native app
- Offline mode
- Push notifications
- Responsive design

---

## 🎬 **Demo Prototype**

Kunjungi: **`/demo`** untuk melihat walkthrough lengkap sistem dari awal hingga akhir.

**Demo mencakup:**
- ✅ Registrasi pasien
- ✅ Approval dokter & pilih jenis anestesi
- ✅ Dashboard dengan progress tracking
- ✅ Reading material dengan scroll detection
- ✅ AI proaktif chat
- ✅ Scheduling informed consent

---

## 🚀 **Quick Start**

### **Setup Firebase Desktop Auth (Wajib)**

1. Copy [.env.example](.env.example) menjadi `.env`.
2. Isi semua variable `VITE_FIREBASE_*`.
3. Isi `VITE_FIREBASE_FUNCTIONS_REGION` (default `us-central1`).
4. Pastikan dokumen `users/{uid}` memiliki field `role` bernilai `dokter` atau `admin` untuk akun desktop.

### **Setup Cloud Functions (Wajib untuk audit immutable)**

Dari root project:

1. Install dependency functions di folder [functions/package.json](../functions/package.json).
2. Deploy callable functions:
  - `writeAdminAuditLog`
  - `assignPasienAnesthesia`
  - `approvePasienProfile`
  - `rejectPasienProfile`
3. Pastikan Firestore rules terbaru sudah ter-deploy agar write sensitif tidak bisa langsung dari client.

Catatan migration flag (opsional, default `false`):
- `VITE_ALLOW_LEGACY_AUDIT_FALLBACK`
- `VITE_ALLOW_LEGACY_DOCTOR_MODERATION_FALLBACK`
- `VITE_ALLOW_LOCALSTORAGE_PATIENT_APPROVAL_FALLBACK`

Contoh role dokumen:

```json
{
  "email": "dokter@aconsia.com",
  "role": "dokter",
  "isProfileCompleted": true
}
```

### **Akses URL:**
```
Landing Page:     /
Demo Prototype:   /demo
Register:         /register
Login:            /login

Patient:          /patient
Doctor:           /doctor
Admin:            /admin
```

### **User Roles:**
1. **Pasien** - Belajar materi, chat dengan AI, jadwalkan consent
2. **Dokter** - Approve pasien, pilih jenis anestesi, monitor progress
3. **Admin** - Manage users, content, analytics

---

## 📐 **Arsitektur Sistem**

```
┌─────────────────────────────────────────┐
│           FRONTEND (React)              │
│  - PWA dengan offline support           │
│  - Tailwind CSS v4.0                    │
│  - React Router v7                      │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│      SERVER (Supabase Edge Function)    │
│  - Hono web server                      │
│  - Authentication                       │
│  - API endpoints                        │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│       DATABASE (Supabase Postgres)      │
│  - Patient profiles                     │
│  - Doctor profiles                      │
│  - Learning materials                   │
│  - Progress tracking                    │
│  - Schedule data                        │
└─────────────────────────────────────────┘
```

---

## 📂 **Struktur Folder**

```
/src/app/
├── pages/
│   ├── LandingPage.tsx              # Landing page utama
│   ├── LoginPage.tsx                # Login
│   ├── PrototypeDemo.tsx            # 🎬 Demo walkthrough
│   │
│   ├── patient/
│   │   ├── PatientHome.tsx          # Dashboard pasien
│   │   ├── PatientRegistration.tsx  # Form registrasi lengkap
│   │   ├── MaterialReader.tsx       # Scroll-based reading
│   │   ├── ProactiveChatbot.tsx     # AI proaktif chat
│   │   └── PatientSchedule.tsx      # Jadwal consent
│   │
│   ├── doctor/
│   │   ├── DoctorDashboard.tsx      # Dashboard dokter
│   │   ├── PatientApproval.tsx      # Approve & pilih anestesi
│   │   ├── DoctorPatients.tsx       # List pasien
│   │   └── DoctorContent.tsx        # Manage content
│   │
│   └── admin/
│       └── AdminDashboard.tsx       # Admin panel
│
├── components/
│   ├── ui/                          # shadcn components
│   ├── InstallPrompt.tsx            # PWA install prompt
│   └── OfflineIndicator.tsx         # Offline mode indicator
│
├── hooks/
│   └── usePWA.ts                    # PWA hooks
│
└── routes.tsx                       # React Router config

/supabase/functions/server/
├── index.tsx                        # Hono server entry
└── kv_store.tsx                     # Key-value storage utils

/public/
├── manifest.json                    # PWA manifest
├── service-worker.js                # Service worker
└── icons/                           # App icons

/docs/
├── ALUR-SISTEM-FINAL.md            # Flowchart lengkap
├── IMPLEMENTASI-FINAL.md           # Dokumentasi implementasi
└── PWA-SETUP.md                    # Setup PWA
```

---

## 🎯 **Alur Detail**

### **1. Registrasi Pasien** (`/register`)
```
Form lengkap:
- Data pribadi (nama, DOB, gender, phone, email, alamat)
- Pilih dokter (dropdown)
- Jenis operasi + tanggal
- Riwayat medis, alergi, obat
- Status ASA (I, II, III, IV, V)

→ Submit → Status: PENDING
```

### **2. Status Pending** (`/patient`)
```
Dashboard menampilkan:
⏳ "Data Teknik Anestesi Anda Belum Dipilih Oleh Dokter"

Tunggu approval dokter...
[Hubungi Dokter]
```

### **3. Dokter Approval** (`/doctor/approval`)
```
Dokter melihat:
- Identitas pasien (nama, umur, MRN)
- Data medis lengkap
- Riwayat, alergi, obat

Dokter action:
[Dropdown: Pilih Jenis Anestesi]
- Anestesi Umum
- Anestesi Spinal
- Anestesi Epidural
- Anestesi Regional
- Anestesi Lokal + Sedasi

[✓ ACC & Pilih Anestesi] [✗ Reject]

→ Approved → Konten otomatis di-filter
```

### **4. Dashboard Pasien** (`/patient`)
```
Comprehension Score: 0% → ... → 100%
[Progress Bar]

🤖 Rekomendasi AI:
[Card] Materi yang perlu dibaca

📚 Materi Pembelajaran (Filtered by jenis anestesi)
[Card] Reading progress per materi

💬 Chat dengan AI Assistant
[Button] Mulai Chat

📅 Jadwalkan Informed Consent
🔒 Unlock saat score ≥80%
```

### **5. Reading Material** (`/patient/material/:id`)
```
[Sticky Header]
Progress Membaca: 0% → 100%
[Auto scroll tracking]

[Content]
1️⃣ Section 1
2️⃣ Section 2
...

Time Spent: 00:00

[End]
✅ Selesai!
[Chat dengan AI untuk Konfirmasi]
```

### **6. AI Proaktif Chat** (`/patient/chat`)
```
🤖 AI: "Halo! Saya lihat Anda sudah membaca materi. 
       Coba ceritakan dengan kata-kata sendiri..."

👤 Pasien: [Jawab]

🤖 AI: "Bagus! ✅ Sekarang, mengapa...?"

👤 Pasien: [Jawab]

🤖 AI: [Analisis jawaban]
       → Jika lemah: Rekomendasikan materi
       → Jika baik: Lanjut pertanyaan berikutnya

Comprehension Score: Update real-time
```

### **7. Schedule Consent** (`/patient/schedule`)
```
[Unlocked saat score ≥80%]

📅 Pilih Tanggal & Waktu
📍 Ruang Konsultasi Anestesi
👨‍⚕️ Dokter: Dr. ...
⏱️ Durasi: 30-45 menit

[Konfirmasi]
→ Email & SMS notification
→ Calendar invite
→ Reminder H-1

✅ Jadwal Terkonfirmasi
```

---

## 💡 **Key Innovations**

### **1. AI Proaktif (Bukan Reaktif)**
```
Traditional Chatbot:
❌ Pasien: "Apa itu anestesi?"
❌ Bot: [Jawab]

ACONSIA AI:
✅ AI: "Coba jelaskan dengan kata-kata sendiri: 
      Apa yang Anda pahami tentang anestesi?"
✅ Pasien: [Jawab]
✅ AI: [Analisis & follow-up question]
```

**Keuntungan:**
- Pasien dipancing untuk berpikir aktif
- Menghindari "tidak tanya = tidak paham"
- AI detect weak areas otomatis

### **2. Scroll-Based Progress Tracking**
```javascript
// Auto-detect scroll position
const handleScroll = () => {
  const scrollTop = element.scrollTop;
  const scrollHeight = element.scrollHeight - element.clientHeight;
  const progress = (scrollTop / scrollHeight) * 100;
  
  setReadingProgress(Math.min(Math.round(progress), 100));
};
```

**Keuntungan:**
- Tidak bisa skip/curang
- Akurat tracking actual reading
- Real-time update

### **3. Multi-Factor Comprehension Scoring**
```
Comprehension Score = weighted average:
- Reading Progress (40%): % materi dibaca
- AI Chat Engagement (30%): Kualitas jawaban
- Quiz Performance (20%): Accuracy (optional)
- Content Revisit (10%): Weak area follow-up
```

**Keuntungan:**
- Holistic assessment
- Bukan hanya reading, tapi understanding
- Dokter bisa trust the score

---

## 🔐 **Data Model**

### **Patient Profile**
```typescript
interface PatientProfile {
  // Identitas
  fullName: string;
  patientId: string;
  mrn: string; // Medical Record Number
  dateOfBirth: string;
  age: number;
  gender: "male" | "female";
  
  // Kontak
  phone: string;
  email: string;
  address: string;
  emergencyContact: {
    name: string;
    relationship: string;
    phone: string;
  };
  
  // Medical
  plannedSurgery: string;
  surgeryDate: string;
  medicalHistory: string[];
  allergies: string[];
  currentMedications: Medication[];
  asaStatus: "I" | "II" | "III" | "IV" | "V";
  
  // Anesthesia
  selectedDoctorId: string;
  approvedAnesthesiaType?: string;
  approvalDate?: string;
  
  // Learning
  comprehensionScore: number; // 0-100
  readingProgress: { [materialId: string]: number };
  chatHistory: Message[];
  
  // Consent
  informedConsentStatus: "pending" | "scheduled" | "signed";
  scheduledConsentDate?: string;
}
```

### **Doctor Profile**
```typescript
interface DoctorProfile {
  fullName: string;
  doctorId: string;
  title: string; // "Dr.", "Prof. Dr."
  specialization: string; // "Sp.An", "Sp.An-KIC"
  
  // Credentials
  str: string; // Surat Tanda Registrasi
  sip: string; // Surat Izin Praktik
  strExpiry: string;
  sipExpiry: string;
  
  // Professional
  institution: string;
  experience: number; // years
  expertise: string[];
  
  // Contact
  phone: string;
  email: string;
  
  // Schedule
  availableDays: string[];
  workingHours: { start: string; end: string };
}
```

---

## 📊 **Metrics & Analytics**

### **Patient Metrics:**
- Reading progress per material
- Time spent per section
- Chat engagement rate
- Comprehension score trend
- Weak areas identification
- Schedule compliance rate

### **Doctor Metrics:**
- Average approval time
- Patient readiness rate (≥80%)
- Most recommended materials
- Comprehension score distribution
- Informed consent completion rate

### **System Metrics:**
- Registration conversion rate
- Drop-off points analysis
- Average time to 80% comprehension
- AI recommendation accuracy
- Overall satisfaction score (NPS)

---

## 🛠️ **Tech Stack**

### **Frontend:**
- React 18 + TypeScript
- Tailwind CSS v4.0
- React Router v7 (Data Mode)
- PWA (Service Worker)
- shadcn/ui components

### **Backend:**
- Supabase Edge Functions (Deno)
- Hono web framework
- PostgreSQL database
- Supabase Auth
- Supabase Storage

### **AI Integration:**
- OpenAI GPT-4 (for chat & analysis)
- Custom prompt engineering
- Context-aware recommendations

### **DevOps:**
- Vercel/Netlify (Frontend hosting)
- Supabase (Backend hosting)
- GitHub Actions (CI/CD)

---

## 🎓 **Untuk Tesis**

### **Kontribusi Penelitian:**
1. **Novel AI Approach**: AI proaktif vs reaktif dalam edukasi medis
2. **Comprehensive Assessment**: Multi-factor comprehension scoring
3. **Behavioral Tracking**: Scroll-based reading vs self-reported
4. **Personalization**: Dynamic content filtering by diagnosis
5. **Patient Safety**: Data-driven informed consent readiness

### **Metodologi:**
- User testing (pasien & dokter)
- A/B testing (AI proaktif vs chatbot biasa)
- Survey kepuasan (NPS, SUS)
- Analysis comprehension score vs actual understanding
- Comparison dengan metode konvensional

### **Expected Outcomes:**
- ✅ Increased comprehension score
- ✅ Reduced anxiety pre-surgery
- ✅ Better doctor-patient communication
- ✅ Standardized education process
- ✅ Scalable & cost-effective

---

## 📞 **Support & Contact**

Untuk pertanyaan atau dukungan:
- 📧 Email: [your-email]
- 🌐 Website: [your-website]
- 📱 WhatsApp: [your-number]

---

## 📜 **License**

Developed for Medical Education & Research Purposes.

© 2026 ACONSIA - All Rights Reserved.

---

## 🙏 **Acknowledgments**

- Supervisor tesis
- Departemen Anestesiologi
- Tim medis konsultan
- User testing participants

---

**Status:** ✅ **Ready for User Testing & Deployment**

**Last Updated:** March 7, 2026
