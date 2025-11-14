# 🏗️ STEP 3: DATA SOURCES - COMPLETE

**Date**: October 27, 2025  
**Status**: ✅ All DataSources Created - Ready for Repository Layer

---

## 📋 **OVERVIEW**

Semua **7 DataSources** + **Error Handling** telah dibuat untuk komunikasi langsung dengan Firebase Firestore. DataSources ini menyediakan **type-safe CRUD operations** dengan **Either<Failure, Success>** pattern untuk error handling yang robust.

---

## 📁 **CREATED FILES (8 Files)**

### 1. **Error Handling** - `lib/core/errors/failures.dart`

**Purpose**: Centralized error handling dengan Freezed union types

**Failure Types**:

- `AuthFailure` - Firebase Authentication errors
- `FirestoreFailure` - Firestore database errors
- `NetworkFailure` - Network connectivity issues
- `ImageUploadFailure` - Cloudinary upload errors
- `ValidationFailure` - Input validation errors
- `NotFoundFailure` - Resource not found
- `PermissionDeniedFailure` - Access control errors
- `ServerFailure` - Cloud Functions errors
- `UnknownFailure` - Unexpected errors

**Key Features**:

- ✅ Automatic exception to failure conversion
- ✅ Indonesian error messages for UX
- ✅ Error code extraction for debugging
- ✅ FirebaseAuthException custom extensions

---

### 2. **Auth DataSource** - `lib/data/datasources/auth_datasource.dart`

**Purpose**: Firebase Authentication operations

**Methods** (9 total):

- `getCurrentUser()` - Get current auth user
- `authStateChanges` - Stream of auth state
- `signUpWithEmail()` - Email/password registration
- `signInWithEmail()` - Email/password login
- `signOut()` - Logout
- `sendPasswordResetEmail()` - Password reset
- `getUserData()` - Get user from Firestore
- `updateProfileCompleted()` - Update profile status
- `deleteAccount()` - Delete user (Auth + Firestore)

**Return Types**:

- `Either<Failure, UserModel>` for auth operations
- `Either<Failure, Unit>` for void operations
- `Stream<User?>` for real-time auth state

---

### 3. **Konten DataSource** - `lib/data/datasources/konten_datasource.dart`

**Purpose**: Content management operations (THE BIGGEST)

**Methods** (13 total):

- `createKonten()` - Create konten with sections (Batch write)
- `getKontenById()` - Get single konten
- `getSectionsByKontenId()` - Get all sections (ordered)
- `getKontenByDokterId()` - Get dokter's content
- `getPublishedKonten()` - Get all published content
- `updateKonten()` - Update konten metadata
- `updateSection()` - Update section content
- `deleteKonten()` - Delete konten + sections (Batch)
- `publishKonten()` - Change status to 'published'
- `searchKontenByKeywords()` - AI keyword search
- `getKontenCountByDokter()` - Count dokter's konten
- `streamKontenByDokter()` - Real-time stream

**Key Features**:

- ✅ **Batch operations** untuk atomicity (create & delete)
- ✅ **Sequential section ordering** dengan `urutan` field
- ✅ **AI keyword search** dengan `arrayContainsAny`
- ✅ **Real-time updates** dengan Firestore streams
- ✅ **Status management** (draft/published)

---

### 4. **Profile DataSource** - `lib/data/datasources/profile_datasource.dart`

**Purpose**: Dokter & Pasien profile management

**Dokter Methods** (5):

- `createDokterProfile()`
- `getDokterProfile()`
- `updateDokterProfile()`
- `updateDokterPhotoUrl()` - Cloudinary URL update
- `deleteDokterProfile()`
- `streamDokterProfile()` - Real-time

**Pasien Methods** (8):

- `createPasienProfile()`
- `getPasienProfile()`
- `updatePasienProfile()`
- `updatePasienPhotoUrl()` - Cloudinary URL update
- `addKontenToFavorites()` - Array add
- `removeKontenFromFavorites()` - Array remove
- `updateAIKeywords()` - For recommendations
- `deletePasienProfile()`
- `streamPasienProfile()` - Real-time

**Shared Methods** (1):

- `checkProfileExists()` - Check if profile complete

---

### 5. **Assignment DataSource** - `lib/data/datasources/assignment_datasource.dart`

**Purpose**: Konten assignment management (Dokter → Pasien)

**Methods** (11 total):

- `createAssignment()` - Assign konten to pasien
- `getAssignmentsByPasien()` - Get all assignments
- `getIncompleteAssignments()` - Filter incomplete
- `updateCurrentBagian()` - **Sequential reading tracker**
- `markAsCompleted()` - Complete assignment
- `isKontenAssigned()` - Check duplicate
- `deleteAssignment()` - Remove assignment
- `getAssignmentById()` - Get single assignment
- `streamAssignmentsByPasien()` - Real-time updates
- `getCompletionPercentage()` - Calculate progress

**Key Features**:

- ✅ **Sequential reading support** (`currentBagian` field)
- ✅ **Progress tracking** dengan completion percentage
- ✅ **Duplicate prevention** dengan `isKontenAssigned()`
- ✅ **Real-time progress** dengan streams

---

### 6. **Chat DataSource** - `lib/data/datasources/chat_datasource.dart`

**Purpose**: Real-time chat (Dokter ↔ Pasien)

**Session Methods** (5):

- `createOrGetSession()` - Create/get existing session
- `getUserChatSessions()` - Get all sessions for user
- `updateSession()` - Update last message & unread counts
- `resetUnreadCount()` - Mark session as read
- `streamUserChatSessions()` - Real-time sessions

**Message Methods** (8):

- `sendMessage()` - Send chat message
- `getMessages()` - Get messages (paginated)
- `markMessageAsRead()` - Single message
- `markAllMessagesAsRead()` - All unread in session
- `streamMessages()` - Real-time messages
- `deleteMessage()` - Delete message
- `getUnreadCount()` - Count unread messages

**Key Features**:

- ✅ **Automatic session creation** jika belum ada
- ✅ **Unread count tracking** untuk Dokter & Pasien
- ✅ **Pagination support** untuk message history
- ✅ **Real-time messaging** dengan Firestore streams
- ✅ **Last message preview** di session list

---

### 7. **Notification DataSource** - `lib/data/datasources/notification_datasource.dart`

**Purpose**: Push notification management (FCM integration)

**Core Methods** (9):

- `createNotification()` - Create notification
- `getUserNotifications()` - Get all (with limit)
- `getUnreadNotifications()` - Filter unread
- `markAsRead()` - Single notification
- `markAllAsRead()` - All notifications
- `deleteNotification()` - Single delete
- `deleteAllNotifications()` - Bulk delete
- `getUnreadCount()` - Count badge number
- `streamUserNotifications()` - Real-time
- `streamUnreadCount()` - Real-time badge

**Helper Methods** (2):

- `createChatNotification()` - Auto-create for chat
- `createAssignmentNotification()` - Auto-create for assignment

**Notification Types**:

- `'chat'` - New chat message
- `'assignment'` - Konten assigned
- `'quiz_result'` - Quiz completion (future)
- Custom types extensible

---

### 8. **AI Recommendation DataSource** - `lib/data/datasources/ai_recommendation_datasource.dart`

**Purpose**: AI-powered konten recommendations

**Methods** (13 total):

- `createRecommendation()` - Create single recommendation
- `getRecommendationsForPasien()` - Get top recommendations
- `getUnviewedRecommendations()` - Filter unviewed
- `markAsViewed()` - Track view
- `batchCreateRecommendations()` - Bulk insert (Cloud Function)
- `deleteRecommendation()` - Single delete
- `deleteAllRecommendations()` - Clear all
- `recommendationExists()` - Check duplicate
- `getRecommendationCount()` - Count recommendations
- `getRecommendationsByKeywords()` - Filter by keywords
- `streamRecommendationsForPasien()` - Real-time
- `clearOldRecommendations()` - Housekeeping (30+ days old)

**Key Features**:

- ✅ **Relevance scoring** (0.0 to 1.0) untuk ranking
- ✅ **Keyword matching** untuk explainability
- ✅ **Batch operations** untuk Cloud Functions
- ✅ **Auto-cleanup** untuk old recommendations
- ✅ **Duplicate prevention**

---

## 🎯 **KEY DESIGN PATTERNS**

### 1. **Either<Failure, Success> Pattern**

```dart
Future<Either<Failure, UserModel>> signInWithEmail({...})
```

**Benefits**:

- Type-safe error handling
- No exceptions thrown
- Forced error handling at call site
- Pattern matching dengan `.fold()`

### 2. **Batch Operations untuk Atomicity**

```dart
// Create konten with sections in one transaction
final batch = _firestore.batch();
batch.set(kontenRef, ...);
batch.set(sectionRef1, ...);
batch.set(sectionRef2, ...);
await batch.commit(); // All or nothing!
```

### 3. **Real-time Streams**

```dart
Stream<List<ChatMessageModel>> streamMessages(String sessionId)
```

**Use Cases**:

- Live chat
- Real-time notifications
- Profile updates
- Assignment progress

### 4. **Pagination Support**

```dart
Future<Either<Failure, List<ChatMessageModel>>> getMessages({
  required String sessionId,
  int limit = 50,
  DocumentSnapshot? lastDocument, // For pagination
})
```

### 5. **Field-Level Updates**

```dart
// Only update specific fields, not entire document
await _firestore.collection('users').doc(uid).update({
  'isProfileCompleted': true,
  'updatedAt': FieldValue.serverTimestamp(),
});
```

### 6. **Array Operations**

```dart
// Add to array
'kontenFavoritIds': FieldValue.arrayUnion([kontenId])

// Remove from array
'kontenFavoritIds': FieldValue.arrayRemove([kontenId])
```

---

## 📊 **DATASOURCE DEPENDENCY TREE**

```
Firebase Services
├── FirebaseAuth ────────────► AuthDataSource
├── FirebaseFirestore ───────► All DataSources
└── FirebaseMessaging ───────► (handled in FCM Provider)

DataSources (No dependencies on each other)
├── AuthDataSource
├── ProfileDataSource
├── KontenDataSource
├── AssignmentDataSource
├── ChatDataSource
├── NotificationDataSource
└── AIRecommendationDataSource

Models (used by all DataSources)
├── UserModel
├── DokterProfileModel
├── PasienProfileModel
├── KontenModel
├── KontenSectionModel
├── KontenAssignmentModel
├── ChatSessionModel
├── ChatMessageModel
├── NotificationModel
└── AIRecommendationModel

Errors
└── Failure (union type)
```

---

## 🔍 **ERROR HANDLING FLOW**

```dart
// Example: Sign In Flow
try {
  final credential = await _firebaseAuth.signInWithEmailAndPassword(...);
  return Right(userModel); // Success!
} on FirebaseAuthException catch (e) {
  return Left(e.toFailure()); // Convert to Failure
} catch (e) {
  return Left(Failure.unknown(message: e.toString())); // Fallback
}

// Usage in UI:
final result = await authDataSource.signInWithEmail(...);
result.fold(
  (failure) => showErrorDialog(failure.message), // Left = Error
  (user) => navigateToHome(user), // Right = Success
);
```

---

## 🚀 **PERFORMANCE OPTIMIZATIONS**

### 1. **Firestore Query Optimization**

- ✅ Indexed fields: `createdAt`, `dokterId`, `pasienId`, `status`, `isRead`
- ✅ Composite indexes untuk multi-field queries
- ✅ Limit results dengan `.limit()` untuk pagination

### 2. **Batch Operations**

- ✅ Max 500 operations per batch
- ✅ Atomic transactions (all or nothing)
- ✅ Reduced network calls

### 3. **Stream Listeners**

- ✅ Limit stream results (e.g., `.limit(100)`)
- ✅ Unsubscribe when not needed
- ✅ Use StreamProvider di Riverpod untuk lifecycle management

### 4. **Array Operations**

- ✅ `arrayContainsAny` max 10 items (Firestore limit)
- ✅ `arrayUnion`/`arrayRemove` untuk efficient array updates

---

## 🔒 **SECURITY CONSIDERATIONS**

### 1. **Server Timestamps**

```dart
'updatedAt': FieldValue.serverTimestamp()
```

**Why?**: Client time can be manipulated. Server time is authoritative.

### 2. **Role-Based Access**

- Firestore Security Rules enforce access control
- DataSources just execute operations
- Failures raised if permission denied

### 3. **Input Validation**

- DataSources assume validated input
- Validation done in **Repository layer** (next step)

---

## 📝 **TESTING STRATEGY**

### Unit Tests (Per DataSource):

```dart
// Mock Firestore & Auth
final mockFirestore = MockFirebaseFirestore();
final mockAuth = MockFirebaseAuth();

// Test success cases
test('signInWithEmail returns UserModel on success', () async {
  // Arrange
  when(mockAuth.signInWithEmailAndPassword(...)).thenAnswer(...);

  // Act
  final result = await authDataSource.signInWithEmail(...);

  // Assert
  expect(result.isRight(), true);
  result.fold(
    (failure) => fail('Should succeed'),
    (user) => expect(user.email, 'test@example.com'),
  );
});

// Test failure cases
test('signInWithEmail returns Failure on wrong password', () async {
  // Arrange
  when(mockAuth.signInWithEmailAndPassword(...)).thenThrow(
    FirebaseAuthException(code: 'wrong-password'),
  );

  // Act
  final result = await authDataSource.signInWithEmail(...);

  // Assert
  expect(result.isLeft(), true);
  result.fold(
    (failure) => expect(failure, isA<AuthFailure>()),
    (user) => fail('Should fail'),
  );
});
```

---

## ✅ **VALIDATION CHECKLIST**

- ✅ All 7 DataSources created
- ✅ Error handling with Either pattern
- ✅ Batch operations for atomicity
- ✅ Real-time streams implemented
- ✅ Pagination support added
- ✅ Indonesian error messages
- ✅ Field-level updates for efficiency
- ✅ Array operations (union/remove)
- ✅ Duplicate prevention checks
- ✅ Server timestamps used
- ✅ Extension methods for exceptions
- ⏳ Code generation pending (build_runner)
- ⏳ Repository layer next

---

## 📚 **NEXT STEPS - STEP 3B: REPOSITORIES**

DataSources handle **HOW** to interact with Firebase.  
Repositories will handle **WHAT** business logic to execute.

**Repository Responsibilities**:

1. **Input Validation** - Check before calling DataSource
2. **Business Logic** - Complex operations (e.g., "assign with notification")
3. **Data Transformation** - Convert Models to Domain Entities
4. **Caching Strategy** - Local cache for offline support (future)
5. **Dependency Injection** - Riverpod providers

**Example Repository Method**:

```dart
// Repository orchestrates multiple DataSources
Future<Either<Failure, Unit>> assignKontenWithNotification({
  required String pasienId,
  required String kontenId,
  required String dokterId,
}) async {
  // 1. Validate inputs
  if (pasienId.isEmpty || kontenId.isEmpty) {
    return Left(Failure.validation(message: 'Invalid input'));
  }

  // 2. Check if already assigned
  final exists = await _assignmentDataSource.isKontenAssigned(...);
  if (exists) {
    return Left(Failure.validation(message: 'Already assigned'));
  }

  // 3. Create assignment
  final assignmentResult = await _assignmentDataSource.createAssignment(...);

  // 4. Create notification
  await _notificationDataSource.createAssignmentNotification(...);

  // 5. Send FCM push notification
  await _fcmService.sendNotification(...);

  return const Right(unit);
}
```

---

## 🎓 **LEARNING RESOURCES**

### Dartz Package (Either):

- [Dartz Documentation](https://pub.dev/packages/dartz)
- Pattern: `Either<L, R>` where L = Left (Error), R = Right (Success)

### Firestore Best Practices:

- [Firestore Data Model](https://firebase.google.com/docs/firestore/data-model)
- [Batch Writes](https://firebase.google.com/docs/firestore/manage-data/transactions)
- [Query Limitations](https://firebase.google.com/docs/firestore/query-data/queries#query_limitations)

### Clean Architecture:

- Data Layer ← **YOU ARE HERE**
- Domain Layer ← Next
- Presentation Layer ← Future

---

**Status**: ✅ STEP 3A COMPLETE - DataSources Ready  
**Files Created**: 8 files (1 error handling + 7 datasources)  
**Total Lines**: ~1,800 lines of type-safe Firebase operations  
**Next**: STEP 3B - Repository Interfaces & Implementations  
**Time to Build**: Run `build_runner` to generate Freezed code first!

---
