# ⚡ QUICK START - Build APK Android

**ACONSIA Mobile App - 5 Menit Build APK!**

---

## 🎯 GOAL

Build aplikasi ACONSIA jadi **APK Android** yang bisa diinstall di HP.

---

## 📋 PREREQUISITES

1. ✅ **Node.js** installed (v16+)
2. ✅ **Android Studio** installed
3. ✅ **USB Cable** untuk connect HP
4. ✅ **HP Android** dengan USB Debugging ON

---

## 🚀 LANGKAH CEPAT (5 MENIT)

### **1. Build Web App**

```bash
npm run build
```

⏱️ **Waktu:** ~30 detik

---

### **2. Add Android Platform** (Hanya sekali)

```bash
npx cap add android
```

⏱️ **Waktu:** ~1 menit (pertama kali)

**Output:** Folder `android/` dibuat

---

### **3. Sync Assets**

```bash
npx cap sync
```

⏱️ **Waktu:** ~10 detik

**Apa yang dilakukan:**
- Copy `dist/` → `android/app/src/main/assets/public/`

---

### **4. Open Android Studio**

```bash
npx cap open android
```

⏱️ **Waktu:** ~10 detik

**Android Studio akan terbuka otomatis**

---

### **5. Build & Run di Android Studio**

1. **Tunggu Gradle Sync selesai** (pertama kali ~5 menit)
2. **Connect HP via USB** (enable USB Debugging)
3. **Klik Run ▶️** (tombol hijau di toolbar)
4. **Pilih HP Anda** dari device list
5. **App otomatis install & run di HP!** 🎉

⏱️ **Waktu:** ~2-3 menit

---

## 📱 ENABLE USB DEBUGGING DI HP

### **Xiaomi / Redmi:**
```
Settings → About Phone → Tap "MIUI Version" 7x
Settings → Additional Settings → Developer Options
Enable "USB Debugging"
```

### **Samsung:**
```
Settings → About Phone → Software Information
Tap "Build Number" 7x
Settings → Developer Options → Enable "USB Debugging"
```

### **Oppo / Realme:**
```
Settings → About Phone → Version
Tap "Build Number" 7x
Settings → System → Developer Options
Enable "USB Debugging"
```

### **Vivo:**
```
Settings → About Phone
Tap "Software Version" 7x
Settings → More Settings → Developer Options
Enable "USB Debugging"
```

---

## 🎯 ONE-LINE BUILD (Shortcut)

```bash
npm run build && npx cap sync && npx cap open android
```

**Selesai!** Langsung buka Android Studio.

---

## 📦 GET APK FILE

### **Option 1: Debug APK (Quick)**

Di Android Studio:
```
Menu → Build → Build Bundle(s) / APK(s) → Build APK(s)
```

**Output:**
```
android/app/build/outputs/apk/debug/app-debug.apk
```

**Share via WhatsApp:** Kirim APK ini ke teman untuk install!

---

### **Option 2: Via Terminal**

```bash
cd android
./gradlew assembleDebug

# APK ada di:
# app/build/outputs/apk/debug/app-debug.apk
```

---

## 🐛 ERROR? FIX CEPAT!

### **Error: "Gradle sync failed"**

**Fix:**
```bash
cd android
./gradlew clean
cd ..
npx cap sync
```

---

### **Error: "Device not found"**

**Fix:**
1. Cabut & colok ulang USB
2. HP: Allow USB Debugging (popup)
3. Android Studio: Refresh device list

---

### **Error: "App not installed"**

**Fix:**
```bash
# Uninstall dulu di HP
adb uninstall com.aconsia.app

# Lalu run lagi di Android Studio
```

---

## ✅ CHECKLIST

- [ ] Node.js installed
- [ ] Android Studio installed
- [ ] HP connect via USB
- [ ] USB Debugging ON
- [ ] `npm run build` success
- [ ] `npx cap sync` success
- [ ] Android Studio open success
- [ ] Gradle sync selesai (no error)
- [ ] Run app success di HP

---

## 🎉 SUKSES!

Jika app muncul di HP Anda, **SELAMAT!** 🎊

**Next Steps:**
1. Test semua fitur di HP
2. Share APK ke teman
3. Upload ke Google Play Store (optional)

---

## 📱 INSTALL APK KE HP LAIN

### **Via File Transfer:**

1. Copy `app-debug.apk` ke HP
2. Buka File Manager
3. Tap APK file
4. Install (allow "Unknown Sources" jika diminta)
5. Done! 🎉

### **Via QR Code:**

1. Upload APK ke Google Drive / Dropbox
2. Get share link
3. Generate QR code (via qrcode.io)
4. Scan QR → Download → Install

---

## 🚀 DEPLOYMENT OPTIONS

| Method | Audience | Effort | Notes |
|--------|----------|--------|-------|
| **APK File** | Internal testing | Low | Share via WhatsApp/Email |
| **Google Drive** | Beta testers | Low | Upload APK, share link |
| **Firebase App Distribution** | Team | Medium | Auto-update, analytics |
| **Google Play Store** | Public | High | Need developer account ($25) |

---

**HAPPY BUILDING!** 🛠️📱✨

---

## 📞 HELP

**Stuck?** Check:
- `/BUILD_MOBILE_APP.md` - Full documentation
- `/REDESIGN_PROFESIONAL.md` - Design guidelines
- Capacitor Docs: https://capacitorjs.com/docs

**Questions?** 
- GitHub Issues (if public repo)
- Team chat / Slack
