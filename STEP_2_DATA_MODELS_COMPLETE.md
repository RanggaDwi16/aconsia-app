# 🏗️ STEP 2: DATA MODELS & ENTITIES - COMPLETE

**Date**: October 27, 2025  
**Status**: ✅ Models Created - Ready for Code Generation

---

## 📋 **OVERVIEW**

Semua **10 Data Models** telah dibuat menggunakan **Freezed** untuk immutable classes dengan **JSON serialization** yang lengkap. Models ini merepresentasikan struktur database Firebase Firestore yang sudah di-design sebelumnya.

---

## 📁 **CREATED FILES (10 Models)**

### 1. **User Model** - `lib/data/models/user_model.dart`

**Collection**: `users`  
**Fields**:

- `uid` (String) - User ID
- `email` (String) - Email address
- `role` (String) - 'dokter' or 'pasien'
- `isProfileCompleted` (bool) - Profile completion status
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

---

### 2. **Dokter Profile Model** - `lib/data/models/dokter_profile_model.dart`

**Collection**: `dokter_profiles`  
**Fields**:

- `uid` (String) - Reference to users collection
- `namaLengkap` (String)
- `nomorSTR` (String) - Medical license number
- `institusi` (String) - Institution name
- `nomorTelepon` (String?)
- `fotoProfilUrl` (String?) - Cloudinary URL
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

---

### 3. **Pasien Profile Model** - `lib/data/models/pasien_profile_model.dart`

**Collection**: `pasien_profiles`  
**Fields**:

- `uid` (String) - Reference to users collection
- `namaLengkap` (String)
- `nomorTelepon` (String)
- `fotoProfilUrl` (String?) - Cloudinary URL
- `kontenFavoritIds` (List<String>) - Favorite content IDs
- `aiKeywords` (List<String>) - Keywords for AI recommendations
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

---

### 4. **Konten Model** - `lib/data/models/konten_model.dart`

**Collection**: `konten`  
**Fields** (Sesuai dengan add_konten_page.dart):

- `id` (String)
- `dokterId` (String) - Reference to dokter_profiles
- `judul` (String) - Content title
- `jenisAnestesi` (String) - 7 options (Anestesi Umum, Regional, etc.)
- `tataCara` (String) - 4 options (Pre-Operatif, Intra-Operatif, etc.)
- `resikoTindakan` (List<String>) - 16 options (multiple selection)
- `komplikasi` (List<String>) - 24 options (multiple selection)
- `indikasiTindakan` (String) - 'Elektif' or 'Emergency'
- `prognosis` (String)
- `alternatifLain` (String)
- `gambarUrl` (String?) - Cloudinary URL
- `aiKeywords` (List<String>) - For AI search & recommendations
- `jumlahBagian` (int) - Total sections count
- `status` (String) - 'draft' or 'published'
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

---

### 5. **Konten Section Model** - `lib/data/models/konten_section_model.dart`

**Collection**: `konten_sections`  
**Fields**:

- `id` (String)
- `kontenId` (String) - Reference to konten collection
- `judulBagian` (String) - Section title
- `isiKonten` (String) - Rich text content
- `urutan` (int) - Section order (1, 2, 3...)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

---

### 6. **Konten Assignment Model** - `lib/data/models/konten_assignment_model.dart`

**Collection**: `konten_assignments`  
**Fields**:

- `id` (String)
- `pasienId` (String) - Reference to pasien_profiles
- `kontenId` (String) - Reference to konten
- `assignedBy` (String) - Dokter ID who assigned
- `assignedAt` (DateTime)
- `currentBagian` (int) - Current section being read (default: 1)
- `isCompleted` (bool) - All sections read? (default: false)
- `completedAt` (DateTime?)
- `updatedAt` (DateTime)

---

### 7. **Chat Session Model** - `lib/data/models/chat_session_model.dart`

**Collection**: `chat_sessions`  
**Fields**:

- `id` (String)
- `pasienId` (String) - Reference to pasien_profiles
- `dokterId` (String) - Reference to dokter_profiles
- `lastMessage` (String?)
- `lastMessageAt` (DateTime?)
- `unreadCountPasien` (int) - Default: 0
- `unreadCountDokter` (int) - Default: 0
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

---

### 8. **Chat Message Model** - `lib/data/models/chat_message_model.dart`

**Collection**: `chat_messages`  
**Fields**:

- `id` (String)
- `sessionId` (String) - Reference to chat_sessions
- `senderId` (String) - User ID (dokter or pasien)
- `senderRole` (String) - 'dokter' or 'pasien'
- `message` (String)
- `isRead` (bool) - Default: false
- `readAt` (DateTime?)
- `createdAt` (DateTime)

---

### 9. **Notification Model** - `lib/data/models/notification_model.dart`

**Collection**: `notifications`  
**Fields**:

- `id` (String)
- `userId` (String) - Recipient user ID
- `type` (String) - 'chat', 'assignment', 'quiz_result', etc.
- `title` (String)
- `body` (String)
- `relatedId` (String?) - Related document ID (kontenId, sessionId, etc.)
- `isRead` (bool) - Default: false
- `readAt` (DateTime?)
- `createdAt` (DateTime)

---

### 10. **AI Recommendation Model** - `lib/data/models/ai_recommendation_model.dart`

**Collection**: `ai_recommendations`  
**Fields**:

- `id` (String)
- `pasienId` (String) - Reference to pasien_profiles
- `kontenId` (String) - Recommended konten ID
- `matchedKeywords` (List<String>) - Keywords that matched
- `relevanceScore` (double) - 0.0 to 1.0 (AI confidence score)
- `isViewed` (bool) - Default: false
- `viewedAt` (DateTime?)
- `createdAt` (DateTime)

---

## 🎯 **KEY FEATURES**

### ✅ **Freezed Integration**

- Immutable classes dengan `@freezed` annotation
- Automatic equality (`==`) dan `hashCode`
- `copyWith()` method untuk membuat modified copies
- Union types support (bisa dipakai nanti untuk state management)

### ✅ **JSON Serialization**

- `fromJson()` factory constructor
- `toJson()` method (auto-generated)
- Support untuk nested objects dan collections

### ✅ **Firestore Integration**

- `fromFirestore()` - Convert Firestore DocumentSnapshot to Model
- `toFirestore()` - Convert Model to Firestore-compatible Map
- Proper handling of Timestamp conversion (DateTime ↔ Firestore Timestamp)
- Null safety untuk optional fields

### ✅ **Type Safety**

- Strong typing untuk semua fields
- Non-nullable by default (kecuali yang explicitly nullable dengan `?`)
- Default values menggunakan `@Default()` annotation

---

## 🔧 **NEXT STEPS - CODE GENERATION**

⚠️ **IMPORTANT**: File-file ini akan memiliki compile errors sampai code generation dijalankan!

### **Run Build Runner:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Perintah ini akan generate:**

1. `*.freezed.dart` files - Freezed boilerplate code
2. `*.g.dart` files - JSON serialization code

**Estimated time**: 2-5 menit tergantung performa komputer

---

## 📊 **ARCHITECTURE ALIGNMENT**

Models ini mengikuti **Clean Architecture** pattern:

```
📁 lib/
├── 📁 data/
│   ├── 📁 models/          ← ✅ STEP 2 (COMPLETE)
│   │   ├── user_model.dart
│   │   ├── dokter_profile_model.dart
│   │   ├── pasien_profile_model.dart
│   │   ├── konten_model.dart
│   │   ├── konten_section_model.dart
│   │   ├── konten_assignment_model.dart
│   │   ├── chat_session_model.dart
│   │   ├── chat_message_model.dart
│   │   ├── notification_model.dart
│   │   └── ai_recommendation_model.dart
│   ├── 📁 datasources/     ← STEP 3 (NEXT)
│   └── 📁 repositories/    ← STEP 3 (NEXT)
└── 📁 domain/
    ├── 📁 entities/        ← STEP 4 (FUTURE)
    └── 📁 repositories/    ← STEP 4 (FUTURE)
```

---

## 🎨 **DESIGN DECISIONS**

### 1. **Freezed over Manual Immutability**

- **Why?**: Mengurangi boilerplate code sampai 70%
- **Benefit**: Auto `copyWith()`, `==`, `hashCode`, `toString()`

### 2. **Separate `fromFirestore()` and `toFirestore()`**

- **Why?**: Firestore menggunakan `Timestamp`, bukan `DateTime`
- **Benefit**: Type-safe conversion tanpa runtime errors

### 3. **Default Values untuk Collections**

- **Why?**: `@Default([])` untuk `List` fields mencegah null errors
- **Benefit**: Tidak perlu null-checking saat iterating

### 4. **AI Keywords di Multiple Collections**

- **Konten**: `aiKeywords` - untuk indexing content
- **Pasien**: `aiKeywords` - untuk tracking user interests
- **AI Recommendations**: `matchedKeywords` - untuk debugging recommendations

### 5. **Sequential Reading Support**

- `KontenAssignmentModel.currentBagian` - tracks current section
- `KontenSectionModel.urutan` - defines section order
- Support untuk "bacaan berurutan wajib" requirement

---

## 🔍 **VALIDATION CHECKLIST**

- ✅ All 10 models created
- ✅ All fields match database schema
- ✅ Firestore converters implemented
- ✅ JSON serialization configured
- ✅ Nullable fields properly marked with `?`
- ✅ Default values set for collections
- ✅ DateTime ↔ Timestamp conversion handled
- ✅ Clean Architecture structure followed
- ⏳ Code generation pending (run build_runner)

---

## 📝 **NOTES FOR DEVELOPER**

1. **Compile Errors Normal**: Errors akan hilang setelah `build_runner` dijalankan
2. **Don't Edit Generated Files**: File `.freezed.dart` dan `.g.dart` akan auto-regenerate
3. **Re-run on Changes**: Jika ubah model, jalankan build_runner lagi
4. **Watch Mode Available**: Gunakan `build_runner watch` untuk auto-regeneration

---

## 🚀 **READY FOR STEP 3**

Setelah code generation selesai, kita siap untuk:

- **STEP 3A**: DataSources (Firebase CRUD operations)
- **STEP 3B**: Repositories (Business logic layer)
- **STEP 3C**: Error Handling (Either<Failure, Success>)
- **STEP 3D**: Riverpod Providers untuk Dependency Injection

---

**Status**: ✅ STEP 2 COMPLETE - Waiting for Code Generation  
**Next**: Run `flutter pub run build_runner build --delete-conflicting-outputs`  
**Time to Complete**: 2-5 minutes

---
