# 📱 BUILD MOBILE APP (Android & iOS) - ACONSIA

**Last Updated:** 18 Maret 2026

---

## 🎯 OVERVIEW

Aplikasi ACONSIA sekarang sudah support:
- ✅ **Web App** (browser)
- ✅ **Mobile App** (Android & iOS via Capacitor)
- ✅ **Desktop App** (optional via Electron)

---

## 📦 PREREQUISITES

### **1. Install Node.js & npm**
```bash
# Cek version (minimal Node 16+)
node --version
npm --version
```

### **2. Install Android Studio** (untuk Android)
- Download: https://developer.android.com/studio
- Install Android SDK
- Install Android Platform 34 (atau terbaru)
- Setup environment variable ANDROID_HOME

### **3. Install Xcode** (untuk iOS - Mac only)
- Download dari Mac App Store
- Install Command Line Tools
- Setup iOS Simulator

### **4. Install Capacitor CLI**
```bash
npm install -g @capacitor/cli
```

---

## 🚀 LANGKAH BUILD APLIKASI

### **STEP 1: Build Web App**

```bash
# Build production
npm run build
```

**Output:** Folder `dist/` berisi web app production-ready

---

### **STEP 2: Initialize Capacitor** (Hanya sekali)

```bash
# Init Capacitor dengan config otomatis
npx cap init

# Atau manual (jika belum ada capacitor.config.ts)
npx cap init "ACONSIA" "com.aconsia.app" --web-dir=dist
```

**Config sudah dibuat:** `capacitor.config.ts`

---

### **STEP 3: Add Platform**

#### **Add Android:**
```bash
npm run cap:add:android
# Atau
npx cap add android
```

#### **Add iOS:** (Mac only)
```bash
npm run cap:add:ios
# Atau
npx cap add ios
```

**Output:** 
- Folder `android/` untuk Android project
- Folder `ios/` untuk iOS project

---

### **STEP 4: Sync Web Assets**

Setiap kali ada perubahan code React:

```bash
npm run build:mobile
# Atau
npm run build && npx cap sync
```

**Apa yang dilakukan:**
1. Build React app → `dist/`
2. Copy `dist/` ke `android/app/src/main/assets/public`
3. Copy `dist/` ke `ios/App/public`

---

### **STEP 5: Open di Android Studio**

```bash
npm run cap:open:android
# Atau
npx cap open android
```

**Android Studio akan terbuka** dengan project Android.

---

### **STEP 6: Build APK di Android Studio**

1. **Tunggu Gradle Sync** selesai (pertama kali lama ~5-10 menit)
2. **Select Device:**
   - Physical device (HP langsung via USB)
   - Emulator (virtual device)
3. **Run App:**
   - Klik tombol hijau "Run" ▶️
   - Pilih device
   - Tunggu build & install
4. **Build APK:**
   - Menu: `Build` → `Build Bundle(s) / APK(s)` → `Build APK(s)`
   - Tunggu build selesai
   - APK ada di: `android/app/build/outputs/apk/debug/app-debug.apk`

---

### **STEP 7: Install APK ke HP**

#### **Via USB Debugging:**

1. **Enable Developer Mode di HP:**
   - Settings → About Phone
   - Tap "Build Number" 7x
   - Kembali → Developer Options
   - Enable "USB Debugging"

2. **Connect HP ke Laptop:**
   - Colok USB
   - Allow USB Debugging (popup di HP)

3. **Install via Android Studio:**
   - Klik Run ▶️
   - Pilih HP Anda dari device list
   - App akan auto-install

#### **Via APK File:**

```bash
# Copy APK ke HP
# Lalu install manual dari File Manager
```

---

## 🛠️ NPM SCRIPTS CHEATSHEET

| Command | Fungsi |
|---------|--------|
| `npm run dev` | Run development server (web) |
| `npm run build` | Build production web app |
| `npm run cap:init` | Initialize Capacitor |
| `npm run cap:add:android` | Add Android platform |
| `npm run cap:add:ios` | Add iOS platform |
| `npm run cap:sync` | Sync web assets ke platform |
| `npm run build:mobile` | Build + Sync |
| `npm run android` | Build + Sync + Open Android Studio |
| `npm run cap:open:android` | Open Android Studio |
| `npm run cap:open:ios` | Open Xcode |

---

## 🎨 UI MOBILE-FIRST DESIGN

### **Landing Page Baru:**

```
┌─────────────────────────────┐
│         [Icon]              │
│        ACONSIA              │
│  Edukasi Informed Consent   │
├─────────────────────────────┤
│                             │
│    Masuk Sebagai            │
│    Pilih peran Anda         │
│                             │
│  ┌───────────────────────┐  │
│  │  👤  Pasien           │  │
│  │  Belajar sebelum      │  │
│  │  operasi              │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🩺  Dokter           │  │
│  │  Kelola pasien Anda   │  │
│  └───────────────────────┘  │
│                             │
│    [Daftar Akun Baru]       │
│    [Lupa Password?]         │
│                             │
└─────────────────────────────┘
```

**Fitur:**
- ✅ 2 tombol besar (Pasien & Dokter)
- ✅ 2 link kecil (Daftar & Lupa Password)
- ✅ Touch-friendly (tombol besar)
- ✅ Simple & clean

---

## 📱 BOTTOM NAVIGATION

Untuk halaman patient dashboard:

```
┌─────────────────────────────┐
│      Content Area           │
│      (Scrollable)           │
│                             │
└─────────────────────────────┘
┌─────────────────────────────┐
│ [🏠]  [📖]  [💬]  [👤]      │
│ Home  Materi  Chat  Profil  │
└─────────────────────────────┘
```

**Component:** `/src/app/components/mobile/BottomNavigation.tsx`

**Usage:**
```tsx
import { MobileLayout } from "@/layouts/MobileLayout";

export function MyPage() {
  return (
    <MobileLayout showBottomNav={true}>
      {/* Your page content */}
    </MobileLayout>
  );
}
```

---

## 🔧 CAPACITOR CONFIG

**File:** `/capacitor.config.ts`

```typescript
import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.aconsia.app',
  appName: 'ACONSIA',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#3b82f6",
      showSpinner: false
    }
  }
};

export default config;
```

**Key Points:**
- `appId`: Package name (com.yourcompany.appname)
- `appName`: Nama app yang muncul di HP
- `webDir`: Folder build output (`dist`)
- `androidScheme`: Use https (lebih aman)

---

## 📱 CONTACT DOCTOR - LANGSUNG KE DOKTER (BUKAN AI)

### **Sebelum:**
- ❌ Chatbot AI yang merespons otomatis
- ❌ Fake conversation dengan AI

### **Sesudah:**
- ✅ Chat langsung dengan dokter yang assigned
- ✅ Pesan real-time (tersimpan di localStorage)
- ✅ Notifikasi "Pesan terkirim ke dokter"
- ✅ Tombol telepon & video call
- ✅ Status online/offline dokter

**Info Banner:**
```
ℹ️ Catatan: Ini adalah komunikasi langsung dengan dokter Anda, 
BUKAN chatbot AI. Dokter akan merespons pertanyaan Anda secepatnya.
```

**Flow:**
1. Pasien kirim pesan
2. Pesan tersimpan di `localStorage` dengan key `doctorChat_{MRN}`
3. Notifikasi: "✓ Pesan Anda telah terkirim ke dokter"
4. Dokter login → Lihat pesan pasien
5. Dokter balas → Pasien terima notifikasi

---

## 🐛 TROUBLESHOOTING

### **1. Blank Screen di Mobile**

**Penyebab:**
- Routing tidak support di mobile
- Asset path salah

**Solusi:**
```typescript
// vite.config.ts - Tambahkan base path
export default defineConfig({
  base: './', // Relative path untuk mobile
  // ...
});
```

### **2. Error: "Module not found"**

**Penyebab:**
- Import path absolute tidak support di mobile

**Solusi:**
```tsx
// ❌ JANGAN
import { Button } from "@/components/ui/button";

// ✅ GUNAKAN
import { Button } from "../../components/ui/button";
```

### **3. localStorage Tidak Work di iOS**

**Penyebab:**
- iOS Safari Private Mode block localStorage

**Solusi:**
```typescript
// Check availability
function isLocalStorageAvailable() {
  try {
    const test = '__test__';
    localStorage.setItem(test, test);
    localStorage.removeItem(test);
    return true;
  } catch(e) {
    return false;
  }
}
```

### **4. Gradle Sync Error**

**Solusi:**
```bash
# Clear Gradle cache
cd android
./gradlew clean

# Re-sync
cd ..
npx cap sync
```

### **5. App Crash on Launch**

**Check:**
1. Build berhasil? `npm run build`
2. Sync berhasil? `npx cap sync`
3. Check logs di Android Studio: Logcat

---

## ✅ CHECKLIST SEBELUM BUILD

- [ ] Build production: `npm run build`
- [ ] Sync assets: `npx cap sync`
- [ ] Test di browser dulu (pastikan no error)
- [ ] Check capacitor.config.ts (appId & appName benar)
- [ ] Enable USB Debugging di HP
- [ ] Android Studio sudah install SDK 34+
- [ ] HP connect via USB (allow debugging)

---

## 📊 BUILD OUTPUT

### **Debug APK:**
```
android/app/build/outputs/apk/debug/app-debug.apk
```

**Size:** ~50-80 MB

### **Release APK (Production):**

```bash
# Build release
cd android
./gradlew assembleRelease

# Output:
# android/app/build/outputs/apk/release/app-release-unsigned.apk
```

**Sign APK:** (untuk upload ke Google Play Store)
```bash
# Generate keystore (sekali)
keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000

# Sign APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore app-release-unsigned.apk my-key-alias

# Zipalign
zipalign -v 4 app-release-unsigned.apk app-release.apk
```

---

## 🚀 DEPLOYMENT OPTIONS

### **1. Internal Testing (Beta):**
- Share APK file langsung via WhatsApp/Email
- Install manual di HP

### **2. Google Play Store:**
- Build release APK
- Sign dengan keystore
- Upload ke Google Play Console
- Submit for review

### **3. PWA (Alternative):**
- Deploy web app ke hosting
- User install via "Add to Home Screen"
- Tidak perlu Google Play Store

---

## 🎯 NEXT STEPS

1. ✅ Landing page simple (DONE)
2. ✅ Capacitor setup (DONE)
3. ✅ Bottom navigation (DONE)
4. ✅ Contact Doctor langsung ke dokter (DONE)
5. ⏳ AI Proaktif bertanya ke pasien (TODO)
6. ⏳ Progress tracking 0-100% (TODO)
7. ⏳ Rekomendasi content AI (TODO)
8. ⏳ Build & test APK di HP
9. ⏳ Upload to Google Play Store (optional)

---

## 📞 CONTACT DOCTOR FLOW

### **User Story:**

**As a Patient:**
> "Saya ingin bertanya langsung ke dokter saya tentang prosedur anestesi, 
> BUKAN ke chatbot AI yang tidak akurat."

**Solution:**
```
1. Patient tap "Hubungi Dokter" (bottom nav)
2. Muncul chat screen dengan info dokter
3. Patient ketik pertanyaan
4. Sistem simpan pesan + notifikasi "Terkirim ke dokter"
5. Doctor login → lihat inbox pesan
6. Doctor balas pesan
7. Patient terima notifikasi + lihat balasan
```

**Tech Stack:**
- LocalStorage untuk menyimpan chat history
- Key: `doctorChat_{patientMRN}`
- Real-time sync (future: WebSocket atau Supabase Realtime)

---

**SELESAI!** 🎉

Aplikasi sekarang sudah:
1. ✅ Landing page simple & mobile-friendly
2. ✅ Support multi-platform (Web + Mobile)
3. ✅ Bottom navigation untuk mobile UX
4. ✅ Contact Doctor langsung (BUKAN AI)
5. ✅ Ready untuk build APK

**Jalankan:**
```bash
npm run build:mobile
npm run android
```

**Build APK di Android Studio:**
- Build → Build Bundle / APK → Build APK
- Install ke HP via USB debugging

**Enjoy!** 🚀📱
