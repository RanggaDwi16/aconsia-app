# 📱 ACONSIA - Mobile App (Android & iOS)

**Sistem Edukasi Informed Consent Anestesi Berbasis AI**

**Version:** 1.0.0  
**Last Updated:** 18 Maret 2026

---

## 🎯 OVERVIEW

ACONSIA adalah aplikasi mobile untuk edukasi pasien sebelum operasi dengan fitur:

✅ **Multi-Platform:**
- Web App (Browser)
- Android App (APK)
- iOS App (via Xcode)

✅ **Fitur Utama:**
- Landing page simple & touch-friendly
- Registrasi pasien (23 fields, 4 steps)
- Registrasi dokter (9 fields)
- Chat langsung dengan dokter (BUKAN AI)
- Materi pembelajaran (10 sections)
- Bottom navigation (mobile UX)
- Offline-ready (PWA)

---

## 🚀 QUICK START (5 MENIT)

### **1. Build Web App**
```bash
npm run build
```

### **2. Add Android Platform**
```bash
npx cap add android
```

### **3. Sync & Open Android Studio**
```bash
npm run android
```

### **4. Run App**
- Click **Run ▶️** di Android Studio
- Select device (phone atau emulator)
- App auto-install & run! 🎉

**Full Guide:** [QUICK_START.md](./QUICK_START.md)

---

## 📚 DOCUMENTATION

| File | Description |
|------|-------------|
| **QUICK_START.md** | 5-minute build guide (APK) |
| **BUILD_MOBILE_APP.md** | Complete build documentation |
| **REDESIGN_PROFESIONAL.md** | UI/UX design guidelines |
| **SUMMARY_UPDATE.md** | Changelog & feature overview |

---

## 🎨 DESIGN HIGHLIGHTS

### **Landing Page:**

```
┌─────────────────────────────┐
│      [Icon] ACONSIA         │
│   Edukasi Informed Consent  │
├─────────────────────────────┤
│   Masuk Sebagai             │
│                             │
│  ┌──────────────────────┐   │
│  │ 👤 Pasien            │   │
│  └──────────────────────┘   │
│                             │
│  ┌──────────────────────┐   │
│  │ 🩺 Dokter            │   │
│  └──────────────────────┘   │
│                             │
│  [Daftar Akun Baru]         │
│  [Lupa Password?]           │
└─────────────────────────────┘
```

**Key Features:**
- ✅ Simple (2 buttons + 2 links)
- ✅ Touch-friendly (large buttons)
- ✅ Mobile-first design
- ✅ Professional appearance

---

## 📱 BOTTOM NAVIGATION

```
┌─────────────────────────────┐
│     Page Content            │
│     (Scrollable)            │
└─────────────────────────────┘
┌─────────────────────────────┐
│ [🏠]  [📖]  [💬]  [👤]      │
│ Home  Materi Chat Profil    │
└─────────────────────────────┘
```

**Routes:**
- **Home** → `/patient`
- **Materi** → `/patient/education`
- **Hubungi** → `/patient/contact-doctor`
- **Profil** → `/patient/profile`

---

## 💬 CONTACT DOCTOR (REAL DOCTOR, NOT AI)

**Features:**
- ✅ Chat langsung dengan dokter assigned
- ✅ Phone & Video call buttons
- ✅ Message persistence (localStorage)
- ✅ Read receipts (✓✓)
- ✅ Timestamp
- ✅ Info banner: "BUKAN AI chatbot"

**Screenshot Mental:**
```
┌─────────────────────────────┐
│ ← Dr. Ahmad Suryadi  [Online]│
│   Sp.An                     │
│ [📞 Telepon] [📹 Video]     │
├─────────────────────────────┤
│ ℹ️ Ini komunikasi langsung  │
│    dengan dokter (BUKAN AI) │
├─────────────────────────────┤
│                             │
│  Halo Dokter, saya ingin    │
│  tanya tentang...      10:00│
│                             │
│          ✓✓ Pesan terkirim  │
│          ke dokter    10:01 │
│                             │
└─────────────────────────────┘
```

---

## 🔧 TECH STACK

| Category | Technology |
|----------|------------|
| **Framework** | React 18.3.1 |
| **Build Tool** | Vite 6.3.5 |
| **Mobile** | Capacitor 8.2.0 |
| **Styling** | Tailwind CSS 4.1.12 |
| **Routing** | React Router 7.13.0 |
| **UI Components** | Radix UI + shadcn/ui |
| **Icons** | Lucide React |
| **Storage** | LocalStorage (temp) |

---

## 📦 NPM SCRIPTS

| Command | Description |
|---------|-------------|
| `npm run dev` | Start dev server |
| `npm run build` | Build production web app |
| `npm run build:mobile` | Build + sync to mobile |
| `npm run android` | Build + open Android Studio |
| `npm run cap:sync` | Sync web assets to platforms |
| `npm run cap:add:android` | Add Android platform |
| `npm run cap:add:ios` | Add iOS platform |
| `npm run cap:open:android` | Open Android Studio |
| `npm run cap:open:ios` | Open Xcode |

---

## 🏗️ PROJECT STRUCTURE

```
/
├── capacitor.config.ts          # Mobile app config
├── package.json                 # Dependencies & scripts
│
├── /src
│   ├── /app
│   │   ├── App.tsx              # Main app entry
│   │   ├── routes.tsx           # All routes
│   │   │
│   │   ├── /components
│   │   │   ├── /ui              # shadcn/ui components
│   │   │   └── /mobile
│   │   │       └── BottomNavigation.tsx
│   │   │
│   │   ├── /layouts
│   │   │   ├── RootLayout.tsx
│   │   │   └── MobileLayout.tsx
│   │   │
│   │   └── /pages
│   │       ├── LandingPage.tsx
│   │       ├── /doctor
│   │       │   ├── DoctorRegistration.tsx
│   │       │   ├── DoctorLogin.tsx
│   │       │   └── ...
│   │       └── /patient
│   │           ├── ContactDoctor.tsx
│   │           ├── EnhancedPatientHome.tsx
│   │           └── ...
│   │
│   └── /styles
│       ├── theme.css
│       └── fonts.css
│
├── /android                     # Android project (auto-generated)
├── /ios                         # iOS project (auto-generated)
│
├── /BUILD_MOBILE_APP.md
├── /QUICK_START.md
├── /REDESIGN_PROFESIONAL.md
└── /SUMMARY_UPDATE.md
```

---

## 🔐 USER ROLES

### **1. PASIEN (Patient)**

**Flow:**
```
Landing → Login → Dashboard → Bottom Nav:
  - Home (Progress overview)
  - Materi (10 sections pembelajaran)
  - Hubungi (Chat dengan dokter)
  - Profil (Edit data)
```

**Features:**
- ✅ Registrasi 23 fields (4 steps)
- ✅ Belajar materi anestesi
- ✅ Quiz checkpoint
- ✅ Chat dengan dokter
- ✅ Progress tracking
- ✅ Jadwal TTD consent

### **2. DOKTER (Doctor)**

**Flow:**
```
Landing → Login → Dashboard:
  - Daftar pasien
  - Approve registrasi
  - Pilih jenis anestesi
  - Monitor progress
  - Balas chat pasien
```

**Features:**
- ✅ Registrasi 9 fields (SIP, STR, dll)
- ✅ Approve patient registration
- ✅ Assign anesthesia type
- ✅ Monitor patient progress
- ✅ Real-time chat with patients

---

## 📱 BUILD APK (ANDROID)

### **Quick Command:**
```bash
npm run build && npx cap sync && npx cap open android
```

### **In Android Studio:**
1. Wait for Gradle sync
2. Connect phone via USB (USB Debugging ON)
3. Click **Run ▶️**
4. App installed to phone! 🎉

### **Get APK File:**
```
Menu → Build → Build Bundle(s) / APK(s) → Build APK(s)

Output:
android/app/build/outputs/apk/debug/app-debug.apk
```

**Share via WhatsApp/Email!**

---

## 🍎 BUILD iOS (MAC ONLY)

### **Quick Command:**
```bash
npm run build && npx cap sync && npx cap open ios
```

### **In Xcode:**
1. Wait for dependencies
2. Select device/simulator
3. Click **Run ▶️**
4. App runs on iPhone! 🎉

---

## 🐛 TROUBLESHOOTING

### **1. Blank Screen di Mobile**

**Fix:**
```bash
# Clear cache
npm run build
npx cap sync
```

### **2. Gradle Sync Failed**

**Fix:**
```bash
cd android
./gradlew clean
cd ..
npx cap sync
```

### **3. Device Not Found**

**Fix:**
- Enable USB Debugging di HP
- Cabut & colok ulang USB
- Allow USB Debugging (popup di HP)
- Refresh device list di Android Studio

### **4. App Not Installed**

**Fix:**
```bash
# Uninstall old version
adb uninstall com.aconsia.app

# Run again
npm run android
```

**More:** See [BUILD_MOBILE_APP.md](./BUILD_MOBILE_APP.md) Troubleshooting section

---

## ✅ READY TO SHIP!

### **Checklist:**

- [x] Landing page simple & professional
- [x] Bottom navigation for mobile UX
- [x] Contact doctor (real doctor, NOT AI)
- [x] Doctor registration & login
- [x] Patient registration (23 fields)
- [x] Capacitor setup & config
- [x] Build scripts ready
- [x] Documentation complete

### **Next Steps:**

1. Build APK: `npm run android`
2. Test di HP (USB debugging)
3. Share APK dengan team
4. Deploy web app (optional)
5. Upload to Google Play Store (optional)

---

## 📞 SUPPORT

**Questions?** Check documentation:
- [QUICK_START.md](./QUICK_START.md) - Fast build guide
- [BUILD_MOBILE_APP.md](./BUILD_MOBILE_APP.md) - Complete guide
- [REDESIGN_PROFESIONAL.md](./REDESIGN_PROFESIONAL.md) - Design principles

**Issues?** Troubleshooting section in BUILD_MOBILE_APP.md

---

## 📄 LICENSE

Private project for thesis (Sistem Informasi Edukasi Informed Consent Anestesi)

---

**HAPPY BUILDING!** 🚀📱✨

**Developed with ❤️ for better patient safety**
