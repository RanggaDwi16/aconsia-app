# 🔥 Firebase Setup Guide - ACONSIA

## ✅ Setup Completed

Berikut adalah ringkasan setup Firebase yang sudah selesai:

---

## 📋 **1. Firebase Project**

- **Project Name**: ACONSIA
- **Project ID**: `aconsia`
- **Location**: Asia Southeast (Singapore/Jakarta)
- **Status**: ✅ Active

### Firebase Console URL:

```
https://console.firebase.google.com/project/aconsia
```

---

## 🔐 **2. Firebase Authentication**

### Enabled Sign-in Methods:

- ✅ Email/Password

### Configuration:

```yaml
Provider: Email/Password
Status: Enabled
Passwordless: Disabled
```

### Testing Credentials (untuk development):

```
Email: test@dokter.com
Password: (akan dibuat saat testing)
```

---

## 🗄️ **3. Cloud Firestore Database**

### Configuration:

- **Mode**: Production
- **Region**: asia-southeast1 (Singapore)
- **Status**: ✅ Active

### Collections Structure:

```
📁 users
📁 dokter_profiles
📁 pasien_profiles
📁 konten
📁 konten_sections
📁 konten_assignments
📁 chat_sessions
📁 chat_messages
📁 notifications
📁 ai_recommendations
```

### Security Rules:

✅ Rules sudah di-setup dengan permissions yang proper

- Dokter dapat CRUD konten mereka sendiri
- Pasien dapat read konten yang di-assign
- Role-based access control (RBAC)
- Profile completion check

---

## 📱 **4. Flutter Configuration**

### Files Generated:

- ✅ `lib/firebase_options.dart`
- ✅ `android/app/google-services.json`
- ✅ `ios/Runner/GoogleService-Info.plist`

### Firebase Initialization:

```dart
// lib/main.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Packages Installed:

```yaml
dependencies:
  firebase_core: ^3.13.0
  firebase_auth: ^5.5.3
  cloud_firestore: ^5.6.7
  firebase_messaging: ^15.2.5
  firebase_storage: ^12.4.5
  firebase_app_check: ^0.3.2+9
```

---

## 📢 **5. Firebase Cloud Messaging (FCM)**

### Android Setup:

- ✅ Permissions added to AndroidManifest.xml
- ✅ FCM Service configured
- ✅ App label updated to "ACONSIA"

### Notification Types:

```dart
- pasien_mulai_baca    // Dokter notif: pasien mulai baca
- pasien_mulai_kuis    // Dokter notif: pasien mulai kuis
- konten_selesai       // Dokter notif: pasien selesai konten
- reminder_konten      // Pasien reminder: konten belum dibaca
```

---

## 🔒 **6. Firebase Security Rules Summary**

### Access Control:

- **Users**: Read/update own data only
- **Dokter Profiles**: Read/write own, pasien can read their dokter's profile
- **Pasien Profiles**: Read/write own, dokter can read their pasien's profile
- **Konten**: Dokter can CRUD own konten, all users can read published
- **Assignments**: Dokter can create/assign, pasien can update progress
- **Chat**: Pasien can read/write own sessions, dokter can read
- **Notifications**: Users can read/update own notifications

---

## 🚀 **Next Steps**

### Immediate Actions Required:

1. **Run Firebase Configuration Command**:

   ```bash
   cd d:\FASTWORK\aconsia_app
   flutterfire configure --project=aconsia
   ```

   This ensures all platforms are properly configured.

2. **Test Firebase Connection**:

   ```bash
   flutter run
   ```

   Check if Firebase initializes without errors.

3. **Create Test Data in Firestore**:
   - Go to Firebase Console → Firestore Database
   - Create a test user document
   - Verify security rules work correctly

---

## 📊 **Firebase Project Information**

### API Keys (from firebase_options.dart):

```dart
Android:
- API Key: AIzaSyBTS1wKVuwnp_8Fn2kDhUYR0EIiwTiF1eU
- App ID: 1:110712692231:android:ff8611063432b1c17d94a2
- Project ID: aconsia

iOS:
- API Key: AIzaSyB30kuCjKLip6vq6CxGAW8wXaEfrDJp__8
- App ID: 1:110712692231:ios:253f6a81ca5349ad7d94a2
- Project ID: aconsia
```

**⚠️ IMPORTANT**: Keep these API keys secure. Don't commit to public repositories without proper .gitignore.

---

## 🔍 **Testing Checklist**

- [ ] Firebase initializes successfully
- [ ] Can create user with email/password
- [ ] Can login with created user
- [ ] Can write to Firestore (users collection)
- [ ] Can read from Firestore
- [ ] Security rules prevent unauthorized access
- [ ] FCM token can be retrieved
- [ ] Notifications can be received (will test after Cloud Functions setup)

---

## 📚 **Useful Links**

- **Firebase Console**: https://console.firebase.google.com/project/aconsia
- **Firestore Database**: https://console.firebase.google.com/project/aconsia/firestore
- **Authentication**: https://console.firebase.google.com/project/aconsia/authentication
- **Cloud Messaging**: https://console.firebase.google.com/project/aconsia/notification

---

## 🆘 **Troubleshooting**

### Common Issues:

1. **"DefaultFirebaseOptions not found"**

   - Run: `flutterfire configure --project=aconsia`

2. **"Firebase not initialized"**

   - Check main.dart has `await Firebase.initializeApp()`
   - Verify firebase_options.dart exists

3. **"Permission denied" in Firestore**

   - Check security rules in Firebase Console
   - Verify user is authenticated
   - Check user role matches rules

4. **FCM token is null**
   - Check permissions in AndroidManifest.xml
   - Request notification permission on first launch
   - Test on physical device (not emulator)

---

## 📝 **Notes**

- All image uploads will use **Cloudinary** (not Firebase Storage) to save costs
- Firebase Storage package installed for future use if needed
- AI integration will use **Cloud Functions** (setup in next step)
- Real-time notifications via FCM for dokter alerts

---

**✅ Firebase Setup - COMPLETED**

Ready for **Step 2: Data Models & Repositories**! 🚀
