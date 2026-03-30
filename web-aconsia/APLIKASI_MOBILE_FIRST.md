# 📱 ACONSIA - APLIKASI MOBILE-FIRST (BUKAN WEBSITE)

**Last Updated:** 18 Maret 2026

---

## 🎯 FILOSOFI DESIGN

Aplikasi ini BUKAN website biasa. Ini adalah **APLIKASI MOBILE-FIRST** dengan:
- ✅ Design seperti aplikasi iOS/Android
- ✅ Navigation yang clear & simple
- ✅ Cards dengan shadow & depth
- ✅ Gradient backgrounds yang modern
- ✅ Button besar & mudah diklik (touch-friendly)
- ✅ Responsive untuk semua device

---

## 🏠 LANDING PAGE - 4 CARD SYSTEM

### **TAMPILAN BARU:**

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│              🩺 (Logo animate pulse)                    │
│                   ACONSIA                               │
│     Sistem Edukasi Informed Consent Anestesi           │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                      PASIEN                             │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────┐  ┌─────────────────────┐      │
│  │  👤 Pasien Baru     │  │  🔑 Sudah Punya     │      │
│  │                     │  │     Akun            │      │
│  │  Belum punya akun?  │  │                     │      │
│  │  Daftar sekarang    │  │  Sudah terdaftar?   │      │
│  │                     │  │  Masuk untuk        │      │
│  │  [Daftar Sekarang]  │  │  melanjutkan        │      │
│  │  (Gradient Blue)    │  │                     │      │
│  │                     │  │  [Masuk ke Akun]    │      │
│  │  ✓Gratis ✓Mudah     │  │  (Gradient Green)   │      │
│  └─────────────────────┘  └─────────────────────┘      │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                 DOKTER ANESTESI                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────┐  ┌─────────────────────┐      │
│  │  ⚕️ Dokter Baru     │  │  🩺 Dokter Login    │      │
│  │                     │  │                     │      │
│  │  Dokter anestesi    │  │  Sudah terdaftar?   │      │
│  │  baru? Daftar       │  │  Masuk untuk        │      │
│  │  untuk mulai        │  │  mengelola pasien   │      │
│  │                     │  │                     │      │
│  │  [Daftar Dokter]    │  │  [Masuk Dokter]     │      │
│  │  (Gradient Purple)  │  │  (Gradient Orange)  │      │
│  └─────────────────────┘  └─────────────────────┘      │
│                                                         │
│             [Lihat Demo Aplikasi]                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🆕 FITUR BARU: REGISTRASI DOKTER

### **Route:**
`/doctor/register`

### **Form Fields:**
```
1. Nama Lengkap (Dr. Ahmad Suryadi, Sp.An) *
2. Email (ahmad.suryadi@hospital.com) *
3. No. Telepon (08123456789) *
4. No. SIP - Surat Izin Praktik (SIP/12345/2024) *
5. No. STR - Surat Tanda Registrasi (STR/67890/2024) *
6. Spesialisasi: Sp.An - Anestesiologi (Auto-filled)
7. Rumah Sakit (RS Dr. Sardjito Yogyakarta) *
8. Password (Minimal 6 karakter) *
9. Konfirmasi Password *
```

### **Validasi:**
- ✅ Nama minimal 3 karakter
- ✅ Email format valid
- ✅ Phone format Indonesia (08xx atau 62xxx)
- ✅ SIP minimal 10 karakter
- ✅ STR minimal 10 karakter
- ✅ Password minimal 6 karakter
- ✅ Password harus match dengan konfirmasi
- ✅ Email tidak boleh duplicate

### **Setelah Submit:**
```javascript
localStorage.setItem(`doctor_${email}`, JSON.stringify(doctorData));
localStorage.setItem('currentDoctor', JSON.stringify(doctorData));
navigate('/doctor/dashboard');
```

---

## 🔐 LOGIN DOKTER

### **Route:**
`/doctor/login`

### **Form Fields:**
```
1. Email
2. Password
```

### **Demo Account (Auto-seeded):**
```
Email: demo@doctor.com
Password: demo123
```

### **Button "Isi Otomatis":**
Satu klik langsung isi form dengan demo credentials!

---

## 🎨 DESIGN PRINCIPLES - MOBILE APP

### **1. GRADIENT BACKGROUNDS**
```css
Pasien Daftar: from-blue-600 to-blue-700
Pasien Login: from-green-600 to-green-700
Dokter Daftar: from-purple-600 to-purple-700
Dokter Login: from-orange-600 to-orange-700
```

### **2. CARD DESIGN**
```css
- Shadow: shadow-2xl
- Border: border-0 (no border, clean)
- Hover: hover:scale-105 (subtle zoom effect)
- Transition: transition-all duration-300
- Hover shadow: hover:shadow-blue-500/50 (glow effect)
```

### **3. BUTTON DESIGN**
```css
- Height: h-14 (56px - easy to tap)
- Gradient: bg-gradient-to-r from-blue-600 to-blue-700
- Font: font-bold text-lg
- Shadow: shadow-lg
- Icon: Always with icon (visual clarity)
```

### **4. ICON CIRCLES**
```css
- Size: w-20 h-20
- Gradient: bg-gradient-to-br from-blue-600 to-blue-700
- Rounded: rounded-3xl
- Shadow: shadow-lg
- Icon inside: w-10 h-10 text-white
```

### **5. SECTION DIVIDERS**
```css
<div className="flex items-center gap-2 mb-4">
  <div className="h-1 flex-1 bg-white/30 rounded"></div>
  <h3 className="text-white font-bold text-lg px-4">PASIEN</h3>
  <div className="h-1 flex-1 bg-white/30 rounded"></div>
</div>
```

---

## 📱 RESPONSIVE BREAKPOINTS

### **Mobile (Default):**
```
- Stack cards vertically (1 column)
- Full width buttons
- Padding: p-4
- Text: text-4xl
```

### **Desktop (md:):**
```
- 2 columns grid: grid md:grid-cols-2
- Side by side cards
- Padding: p-8
- Text: md:text-5xl
```

---

## 🔄 USER FLOW - DOKTER

### **1. PERTAMA KALI BUKA APP:**
```
Landing Page
  ↓
Pilih: "Dokter Baru"
  ↓
/doctor/register
  ↓
Isi form 9 fields
  ↓
Submit
  ↓
Data tersimpan di localStorage
  ↓
Auto-redirect ke /doctor/dashboard
```

### **2. SUDAH PUNYA AKUN:**
```
Landing Page
  ↓
Pilih: "Dokter Login"
  ↓
/doctor/login
  ↓
Isi email & password
  ↓
Submit
  ↓
Validasi credentials
  ↓
Auto-redirect ke /doctor/dashboard
```

---

## 🔄 USER FLOW - PASIEN

### **1. PERTAMA KALI BUKA APP:**
```
Landing Page
  ↓
Pilih: "Pasien Baru"
  ↓
/register (PatientRegistrationSimplified)
  ↓
Isi 4 steps (23 fields)
  ↓
Submit
  ↓
Status: pending
  ↓
Dashboard pasien (waiting approval)
```

### **2. SUDAH PUNYA AKUN:**
```
Landing Page
  ↓
Pilih: "Sudah Punya Akun"
  ↓
/login
  ↓
Isi MRN
  ↓
Submit
  ↓
Dashboard pasien (continue learning)
```

---

## 💾 DATA STORAGE

### **Doctor Data Structure:**
```javascript
{
  id: "DOC-1737043200000",
  fullName: "Dr. Ahmad Suryadi, Sp.An",
  email: "ahmad.suryadi@hospital.com",
  phone: "081234567890",
  sipNumber: "SIP/12345/2024",
  strNumber: "STR/67890/2024",
  specialization: "Anestesiologi",
  hospital: "RS Dr. Sardjito Yogyakarta",
  password: "hashed_password", // In production: hash this!
  createdAt: "2026-03-18T10:00:00.000Z",
  status: "active"
}
```

### **LocalStorage Keys:**
```
doctor_${email}        → Individual doctor data
currentDoctor          → Currently logged in doctor
patient_${mrn}         → Individual patient data
currentPatient         → Currently logged in patient
```

---

## 🎯 PERBEDAAN WEBSITE vs APLIKASI

| Aspek | Website | Aplikasi ACONSIA |
|-------|---------|------------------|
| **Navigation** | Menu bar, dropdown | Bottom tabs, cards |
| **Buttons** | Small, subtle | Large, prominent |
| **Colors** | Muted, professional | Vibrant gradients |
| **Layout** | Grid-based | Card-based |
| **Typography** | Serif, formal | Sans-serif, friendly |
| **Spacing** | Compact | Generous padding |
| **Interactions** | Hover effects | Tap animations |
| **Visual Depth** | Flat | Shadows & layers |

---

## ✅ CHECKLIST DESIGN APLIKASI

Setiap halaman harus memiliki:

- [x] **Gradient background** (bukan solid color)
- [x] **Large touch-friendly buttons** (min h-14)
- [x] **Icons di setiap button** (visual clarity)
- [x] **Shadow & depth** (shadow-lg, shadow-2xl)
- [x] **Rounded corners** (rounded-lg, rounded-3xl)
- [x] **Spacing yang generous** (p-6, p-8, gap-6)
- [x] **Mobile-first responsive** (stack on mobile, grid on desktop)
- [x] **Clear section headers** (dengan divider lines)
- [x] **Animations** (hover:scale-105, animate-pulse)

---

## 🚀 NEXT STEPS

1. ✅ Landing page dengan 4 cards (DONE)
2. ✅ Registrasi dokter lengkap (DONE)
3. ✅ Login dokter dengan demo account (DONE)
4. ⏳ Semua halaman lain pakai design principles yang sama
5. ⏳ Tambah animasi loading states
6. ⏳ Tambah success/error toasts (bukan alert)
7. ⏳ Tambah skeleton loaders
8. ⏳ Optimize untuk PWA (install ke home screen)

---

## 📸 SCREENSHOTS EXPECTATIONS

### **Landing Page:**
- Clean, modern, app-like
- 4 large cards dengan gradients
- Clear separation: Pasien vs Dokter
- Touch-friendly (thumb zone)

### **Registration Pages:**
- Form yang clean dengan icons
- Validasi real-time
- Error messages yang helpful
- Progress indicator (untuk multi-step)

### **Dashboard:**
- Card-based layout
- Quick actions prominent
- Statistics dengan charts
- Bottom navigation (mobile)

---

**KESIMPULAN:** Aplikasi sekarang sudah terlihat seperti **APLIKASI MOBILE MODERN**, bukan website tradisional! 🎉

**Key Features:**
1. ✅ 4 Card Landing Page (Pasien Daftar/Login, Dokter Daftar/Login)
2. ✅ Registrasi Dokter Lengkap (9 fields dengan validasi)
3. ✅ Login Dokter dengan Demo Account
4. ✅ Gradient backgrounds & modern design
5. ✅ Touch-friendly buttons & interactions
6. ✅ Mobile-first responsive design
