# 🎯 VISUAL STUDIO .NET MAUI - ACONSIA

## ✨ KENAPA .NET MAUI?

**1 CODE → 4 PLATFORM!**

```
┌──────────────────────────────────────┐
│   ACONSIA.sln (1 Solution)           │
│   C# + XAML Code                     │
└──────────────────────────────────────┘
              ↓
    ┌─────────┴─────────┐
    ↓         ↓         ↓         ↓
┌────────┐┌────────┐┌────────┐┌────────┐
│Android ││  iOS   ││Windows ││ macOS  │
│  APK   ││  IPA   ││  EXE   ││  APP   │
└────────┘└────────┘└────────┘└────────┘
```

**Benefits:**
- ✅ 1 IDE (Visual Studio 2022)
- ✅ 1 Language (C#)
- ✅ 1 Codebase untuk semua platform
- ✅ Drag & drop designer
- ✅ IntelliSense & debugging powerful
- ✅ Native performance
- ✅ GRATIS!

---

## 📦 STEP 1: INSTALL VISUAL STUDIO 2022

### **Download Visual Studio 2022 Community (FREE)**

Link: https://visualstudio.microsoft.com/downloads/

**Pilih edisi:**
- ✅ **Community** (GRATIS untuk personal/small team)
- Professional (Berbayar)
- Enterprise (Berbayar)

---

### **Workloads yang Harus Diinstall:**

Saat install Visual Studio 2022, **CENTANG INI:**

```
☑️ .NET Multi-platform App UI development
☑️ Mobile development with .NET
☑️ ASP.NET and web development (optional)
```

**Screenshot pilihan:**
```
┌────────────────────────────────────────┐
│ Workloads                              │
├────────────────────────────────────────┤
│ ☑️ .NET Multi-platform App UI          │
│   development                          │
│                                        │
│ ☑️ Mobile development with .NET        │
│                                        │
│ ☐ Desktop development with C++         │
│ ☐ ASP.NET and web development          │
└────────────────────────────────────────┘
```

**Individual Components (otomatis terinstall):**
- .NET MAUI SDK
- Android SDK & Emulator
- iOS SDK (macOS only)
- Windows SDK

**Download size:** ~15-20 GB  
**Install time:** ~30-60 menit (tergantung internet)

---

### **Requirements:**

**Windows:**
- Windows 10 version 1809 or higher
- Windows 11 (recommended)
- 16 GB RAM (minimum 8 GB)
- SSD recommended
- 30 GB free space

**macOS (untuk build iOS/macOS):**
- macOS 12 (Monterey) or higher
- 8 GB RAM
- Xcode installed
- Apple Developer Account ($99/tahun untuk publish)

---

## 🛠️ STEP 2: CREATE PROJECT

### **Cara 1: Via Visual Studio (Recommended)**

```
1. Buka Visual Studio 2022
2. Klik "Create a new project"
3. Search: "MAUI"
4. Pilih: ".NET MAUI App"
5. Klik "Next"

Project Name: ACONSIA
Location: C:\Projects\ACONSIA
Solution Name: ACONSIA

6. Klik "Create"
```

**Project Structure:**
```
ACONSIA/
├── ACONSIA.sln                  # Solution file
├── ACONSIA.csproj               # Project file
├── MauiProgram.cs               # App initialization
├── App.xaml                     # App resources
├── App.xaml.cs                  # App logic
├── AppShell.xaml                # Navigation shell
├── AppShell.xaml.cs             # Shell logic
├── Models/                      # Data models
│   ├── Patient.cs
│   └── Doctor.cs
├── Views/                       # UI Pages (XAML)
│   ├── LandingPage.xaml
│   ├── PatientLoginPage.xaml
│   ├── DoctorLoginPage.xaml
│   ├── PatientDashboardPage.xaml
│   └── DoctorDashboardPage.xaml
├── ViewModels/                  # Logic (MVVM)
│   ├── LandingViewModel.cs
│   ├── PatientLoginViewModel.cs
│   └── DoctorLoginViewModel.cs
├── Services/                    # Business logic
│   └── StorageService.cs
├── Resources/                   # Assets
│   ├── Images/
│   ├── Fonts/
│   └── Styles/
└── Platforms/                   # Platform-specific code
    ├── Android/
    ├── iOS/
    ├── Windows/
    └── MacCatalyst/
```

---

### **Cara 2: Via Command Line (dotnet CLI)**

```bash
# Install MAUI workload (jika belum)
dotnet workload install maui

# Create project
dotnet new maui -n ACONSIA

# Open in Visual Studio
cd ACONSIA
start ACONSIA.sln
```

---

## 🎨 STEP 3: PROJECT CONFIGURATION

### **Edit ACONSIA.csproj**

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFrameworks>net8.0-android;net8.0-ios;net8.0-maccatalyst</TargetFrameworks>
    <TargetFrameworks Condition="$([MSBuild]::IsOSPlatform('windows'))">$(TargetFrameworks);net8.0-windows10.0.19041.0</TargetFrameworks>
    
    <!-- App Info -->
    <OutputType>Exe</OutputType>
    <RootNamespace>ACONSIA</RootNamespace>
    <UseMaui>true</UseMaui>
    <SingleProject>true</SingleProject>
    <ImplicitUsings>enable</ImplicitUsings>

    <!-- Display name -->
    <ApplicationTitle>ACONSIA</ApplicationTitle>

    <!-- App Identifier -->
    <ApplicationId>com.hospital.aconsia</ApplicationId>
    <ApplicationIdGuid>12345678-1234-1234-1234-123456789012</ApplicationIdGuid>

    <!-- Versions -->
    <ApplicationDisplayVersion>1.0</ApplicationDisplayVersion>
    <ApplicationVersion>1</ApplicationVersion>

    <!-- Platform Versions -->
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'ios'">14.2</SupportedOSPlatformVersion>
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'maccatalyst'">14.0</SupportedOSPlatformVersion>
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'android'">21.0</SupportedOSPlatformVersion>
    <SupportedOSPlatformVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'windows'">10.0.17763.0</SupportedOSPlatformVersion>
    <TargetPlatformMinVersion Condition="$([MSBuild]::GetTargetPlatformIdentifier('$(TargetFramework)')) == 'windows'">10.0.17763.0</TargetPlatformMinVersion>
  </PropertyGroup>

  <ItemGroup>
    <!-- App Icon -->
    <MauiIcon Include="Resources\AppIcon\appicon.svg" ForegroundFile="Resources\AppIcon\appiconfg.svg" Color="#2563EB" />

    <!-- Splash Screen -->
    <MauiSplashScreen Include="Resources\Splash\splash.svg" Color="#2563EB" BaseSize="128,128" />

    <!-- Images -->
    <MauiImage Include="Resources\Images\*" />

    <!-- Custom Fonts -->
    <MauiFont Include="Resources\Fonts\*" />

    <!-- Raw Assets -->
    <MauiAsset Include="Resources\Raw\**" LogicalName="%(RecursiveDir)%(Filename)%(Extension)" />
  </ItemGroup>

  <ItemGroup>
    <!-- NuGet Packages -->
    <PackageReference Include="Microsoft.Extensions.Logging.Debug" Version="8.0.0" />
    <PackageReference Include="CommunityToolkit.Mvvm" Version="8.2.2" />
    <PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
  </ItemGroup>

</Project>
```

---

## ▶️ STEP 4: RUN & BUILD

### **Run untuk Testing (Development)**

**Android:**
```
1. Klik dropdown platform → pilih "Android Emulator"
2. Pilih device (atau create new AVD)
3. Klik "▶ Android Emulator" atau F5
```

**Windows:**
```
1. Klik dropdown platform → pilih "Windows Machine"
2. Klik "▶ Windows Machine" atau F5
```

**iOS (macOS only):**
```
1. Klik dropdown platform → pilih "iOS Simulator"
2. Pilih device (iPhone 15, iPad, dll)
3. Klik "▶ iOS Simulator" atau F5
```

---

### **Build untuk Production**

**Android APK:**
```
1. Right-click project → Publish
2. Pilih "Ad Hoc"
3. Select platform: Android
4. Configure signing:
   - Create new keystore
   - Password: ********
5. Klik "Publish"

Output: bin\Release\net8.0-android\publish\*.apk
```

**Windows EXE:**
```
1. Right-click project → Publish
2. Pilih "Folder"
3. Select platform: Windows
4. Klik "Publish"

Output: bin\Release\net8.0-windows\publish\*.exe
```

**iOS IPA (macOS + Apple Developer Account):**
```
1. Pair Mac via Visual Studio
2. Right-click project → Archive
3. Sign with Apple Developer Certificate
4. Export IPA

Output: bin\Release\net8.0-ios\*.ipa
```

---

## 🎯 PLATFORM TARGET MATRIX

| Platform | Development | Build | Deploy |
|----------|-------------|-------|--------|
| **Android** | ✅ Windows/Mac | ✅ Windows/Mac | ✅ APK / Play Store |
| **iOS** | ⚠️ Mac only | ⚠️ Mac only | ⚠️ IPA / App Store |
| **Windows** | ✅ Windows | ✅ Windows | ✅ EXE / MS Store |
| **macOS** | ✅ Mac | ✅ Mac | ✅ APP / Mac App Store |

**Catatan:**
- Android development bisa di Windows atau Mac
- iOS development **HARUS** di Mac (atau paired Mac)
- Windows development hanya di Windows
- macOS development hanya di Mac

---

## 🔧 TROUBLESHOOTING

### **Android Emulator tidak muncul**

```
Tools → Android → Android Device Manager
→ Create new device (Pixel 5, Android 13)
```

### **iOS Simulator tidak bisa (Windows)**

```
Solusi: Pair with Mac
Tools → iOS → Pair to Mac
→ Connect ke Mac di network yang sama
→ Install Xcode & MAUI di Mac
```

### **Build error: SDK not found**

```
Tools → Options → MAUI
→ Check SDK paths
→ Repair/Reinstall workload
```

### **Hot Reload tidak jalan**

```
Tools → Options → XAML Hot Reload
→ Enable XAML Hot Reload
→ Restart Visual Studio
```

---

## 📱 DEVICE REQUIREMENTS

### **Android:**
- Min SDK: 21 (Android 5.0 Lollipop)
- Target SDK: 34 (Android 14)
- APK Size: ~15-25 MB

### **iOS:**
- Min iOS: 14.2
- Target iOS: 17.0
- IPA Size: ~20-30 MB

### **Windows:**
- Min Windows: 10 (1809)
- Target Windows: 11
- EXE Size: ~50-80 MB (self-contained)

### **macOS:**
- Min macOS: 12 (Monterey)
- Target macOS: 14 (Sonoma)
- APP Size: ~50-80 MB

---

## ✅ ADVANTAGES .NET MAUI vs FLUTTER

| Feature | .NET MAUI | Flutter |
|---------|-----------|---------|
| **IDE** | Visual Studio (1 IDE) | VS Code/Android Studio |
| **Language** | C# (familiar) | Dart (baru) |
| **UI** | XAML (like HTML) | Widget tree (beda) |
| **Hot Reload** | ✅ Yes | ✅ Yes |
| **Desktop** | ✅ Native Windows/Mac | ⚠️ Experimental |
| **Performance** | ✅ Native | ✅ Native |
| **Learning Curve** | ⭐⭐⭐ Easy (jika tau C#) | ⭐⭐⭐⭐ Medium |
| **Debugging** | ✅✅ Excellent | ✅ Good |
| **Enterprise** | ✅ Microsoft support | ⚠️ Google (less stable) |

---

## 🎨 DESIGN TOOLS

**Visual Studio Built-in:**
- ✅ XAML Designer (drag & drop)
- ✅ XAML IntelliSense
- ✅ Live Preview
- ✅ Hot Reload

**External Tools (optional):**
- Figma to XAML converter
- Material Design icons
- Color picker

---

## 📚 USEFUL COMMANDS

**dotnet CLI:**
```bash
# Create project
dotnet new maui -n AppName

# Run project
dotnet build
dotnet run

# Clean
dotnet clean

# Restore packages
dotnet restore

# Publish Android
dotnet publish -f net8.0-android -c Release

# Publish Windows
dotnet publish -f net8.0-windows -c Release
```

**Visual Studio:**
```
Build → Clean Solution (Ctrl+Shift+B)
Build → Rebuild Solution (Ctrl+Shift+B)
Debug → Start Debugging (F5)
Debug → Start Without Debugging (Ctrl+F5)
```

---

## 🚀 NEXT STEPS

Sekarang saya akan buatkan **SEMUA FILE .NET MAUI** untuk ACONSIA:

1. ✅ MauiProgram.cs (app initialization)
2. ✅ Models (Patient.cs, Doctor.cs)
3. ✅ Services (StorageService.cs)
4. ✅ Views (XAML pages)
5. ✅ ViewModels (logic)
6. ✅ Resources (styles, colors)

**Total: ~15 files** untuk complete ACONSIA app!

---

## 💡 COMPARISON

### **Flutter (yang sudah dibuat):**
```
Pros:
+ 1 codebase untuk mobile (Android/iOS)
+ Hot reload super cepat
+ Community besar

Cons:
- Desktop masih experimental
- Dart language (kurang familiar)
- 2-3 IDE berbeda
- Setup lebih ribet
```

### **.NET MAUI (akan dibuat):**
```
Pros:
+ 1 IDE (Visual Studio)
+ C# (familiar untuk .NET devs)
+ Desktop native (Windows/Mac)
+ Enterprise support Microsoft
+ Drag & drop designer

Cons:
- File size lebih besar
- Community lebih kecil dari Flutter
- iOS development butuh Mac
```

---

## ✅ READY?

**Saya akan buatkan COMPLETE .NET MAUI CODE sekarang!**

File yang akan dibuat:
- ✅ Project structure
- ✅ All C# models
- ✅ All XAML pages (UI)
- ✅ All ViewModels (logic)
- ✅ Storage service
- ✅ Navigation setup
- ✅ Styles & resources

**Lanjut buatkan semua file nya?** 🚀

**Atau mau tanya dulu tentang Visual Studio/MAUI?** 🤔
