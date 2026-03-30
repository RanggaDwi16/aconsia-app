# 🚀 FLUTTER INSTALLATION GUIDE - ACONSIA

## 📋 STRUKTUR PROJECT FLUTTER

```
aconsia_flutter/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── models/
│   │   ├── patient.dart             # Patient model
│   │   ├── doctor.dart              # Doctor model
│   │   └── learning_material.dart   # Material model
│   ├── pages/
│   │   ├── landing_page.dart        # Landing page
│   │   ├── patient_login_page.dart  # Patient login
│   │   ├── doctor_login_page.dart   # Doctor login
│   │   ├── patient_dashboard_page.dart  # Patient dashboard
│   │   └── doctor_dashboard_page.dart   # Doctor dashboard
│   ├── services/
│   │   └── storage_service.dart     # LocalStorage service
│   └── widgets/
│       ├── custom_button.dart       # Reusable button
│       ├── custom_input.dart        # Reusable input
│       └── footer.dart              # Footer widget
├── pubspec.yaml                     # Dependencies
└── README.md                        # Documentation
```

---

## 📦 STEP 1: INSTALL FLUTTER

### **Windows:**
```bash
# 1. Download Flutter SDK
https://docs.flutter.dev/get-started/install/windows

# 2. Extract ke C:\src\flutter

# 3. Tambahkan ke PATH
C:\src\flutter\bin

# 4. Verify
flutter doctor
```

### **macOS:**
```bash
# 1. Install dengan Homebrew
brew install --cask flutter

# 2. Verify
flutter doctor
```

### **Linux:**
```bash
# 1. Download Flutter
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# 2. Extract
tar xf flutter_linux_3.16.0-stable.tar.xz

# 3. Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 4. Verify
flutter doctor
```

---

## 🛠️ STEP 2: CREATE FLUTTER PROJECT

```bash
# 1. Create new Flutter project
flutter create aconsia_flutter

# 2. Masuk ke folder project
cd aconsia_flutter

# 3. Test run
flutter run
```

---

## 📝 STEP 3: COPY CODE FILES

Saya sudah buatkan semua file Flutter di bawah. Tinggal copy-paste!

---

## 🎯 STEP 4: INSTALL DEPENDENCIES

Edit file `pubspec.yaml` dan tambahkan dependencies yang dibutuhkan.

---

## ▶️ STEP 5: RUN APP

```bash
# Run di emulator/device
flutter run

# Build APK untuk Android
flutter build apk --release

# Build untuk iOS (macOS only)
flutter build ios --release
```

---

## 📱 DEVICE REQUIREMENTS

### **Android:**
- Min SDK: 21 (Android 5.0)
- Target SDK: 33 (Android 13)
- Size APK: ~15-20 MB

### **iOS:**
- iOS 12.0+
- Size IPA: ~20-25 MB

---

## 🔧 TROUBLESHOOTING

### **Issue: Flutter doctor shows errors**
```bash
# Fix Android licenses
flutter doctor --android-licenses

# Install missing dependencies
flutter doctor
```

### **Issue: Hot reload not working**
```bash
# Restart app
r (di terminal)

# Full restart
R (capital R)
```

### **Issue: Build failed**
```bash
# Clean project
flutter clean

# Get packages
flutter pub get

# Run again
flutter run
```

---

## ✅ CHECKLIST INSTALASI

- [ ] Flutter SDK installed
- [ ] Android Studio / VS Code installed
- [ ] Flutter doctor passed
- [ ] Project created
- [ ] Dependencies installed
- [ ] Code files copied
- [ ] App running successfully

---

## 📚 USEFUL COMMANDS

```bash
# Create project
flutter create app_name

# Run app
flutter run

# Hot reload
r

# Hot restart
R

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .

# Check Flutter version
flutter --version

# Upgrade Flutter
flutter upgrade
```

---

## 🎨 DESIGN SYSTEM (Sama dengan HTML)

```dart
// Colors
primaryBlue: Color(0xFF2563EB)      // blue-600
primaryEmerald: Color(0xFF059669)   // emerald-600
primaryPurple: Color(0xFF9333EA)    // purple-600

textDark: Color(0xFF0F172A)         // slate-900
textMedium: Color(0xFF334155)       // slate-700
textLight: Color(0xFF64748B)        // slate-500

bgWhite: Color(0xFFFFFFFF)          // white
borderLight: Color(0xFFE2E8F0)      // slate-200
```

---

## 🚀 DEPLOYMENT

### **Android (Google Play):**
```bash
# 1. Build App Bundle
flutter build appbundle --release

# 2. Upload ke Google Play Console
# File: build/app/outputs/bundle/release/app-release.aab
```

### **iOS (App Store):**
```bash
# 1. Build for iOS
flutter build ios --release

# 2. Open Xcode
open ios/Runner.xcworkspace

# 3. Archive & upload via Xcode
```

### **APK Direct Install:**
```bash
# Build APK
flutter build apk --release

# File: build/app/outputs/flutter-apk/app-release.apk
# Share APK file untuk install langsung
```

---

## 💡 TIPS

1. **Development:**
   - Pakai VS Code + Flutter extension
   - Enable hot reload untuk development cepat
   - Test di real device untuk performance

2. **Performance:**
   - Gunakan `const` widget sebanyak mungkin
   - Optimize images
   - Lazy load data

3. **Testing:**
   - Test di berbagai ukuran layar
   - Test di Android & iOS
   - Test offline mode

---

## 📞 NEXT STEPS

Setelah install berhasil:

1. ✅ Test login dokter & pasien
2. ✅ Test approval flow
3. ✅ Customize design sesuai kebutuhan
4. ✅ Tambah fitur registrasi lengkap
5. ✅ Integrate dengan backend (opsional)

---

**READY TO CODE!** 🚀

Scroll ke bawah untuk melihat semua file Flutter code! 👇
