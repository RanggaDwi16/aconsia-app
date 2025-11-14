# 🚀 ACONSIA App - Quick Provider Reference

## 📦 Single Import for Everything

```dart
import 'package:aconsia_app/core/providers/providers.dart';
```

---

## 🎯 Most Common Use Cases

### 1. Get Current User

```dart
// In any ConsumerWidget
final user = ref.watch(currentUserProvider);  // User?
final userId = ref.watch(currentUserIdProvider);  // String?
final isSignedIn = ref.watch(isSignedInProvider);  // bool
```

### 2. Auth Operations

```dart
final authRepo = ref.watch(authRepositoryProvider);

// Sign up
await authRepo.signUp(
  email: 'user@example.com',
  password: 'password123',
  role: 'pasien',
);

// Sign in
final result = await authRepo.signIn(
  email: 'user@example.com',
  password: 'password123',
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (user) => print('Success!'),
);

// Sign out
await authRepo.signOut();
```

### 3. Profile Management

```dart
final profileRepo = ref.watch(profileRepositoryProvider);

// Create pasien profile
await profileRepo.createPasienProfile(pasienModel);

// Update pasien profile
await profileRepo.updatePasienProfile(
  pasienId: userId,
  namaLengkap: 'John Doe',
  nomorTelepon: '081234567890',
);

// Get profile
final result = await profileRepo.getPasienProfile(userId);
```

### 4. Konten Management

```dart
final kontenRepo = ref.watch(kontenRepositoryProvider);

// Create konten with sections
await kontenRepo.createKonten(
  konten: kontenModel,
  sections: [section1, section2, section3],
);

// Search konten
final result = await kontenRepo.searchKontenByKeywords(['anestesi', 'umum']);
```

### 5. Assignment Workflow

```dart
final assignmentRepo = ref.watch(assignmentRepositoryProvider);

// Create assignment (auto-creates notification!)
await assignmentRepo.createAssignment(assignmentModel);

// Update progress (sequential enforcement)
await assignmentRepo.updateCurrentBagian(
  assignmentId: id,
  newBagian: 2,  // Cannot skip sections!
);

// Mark completed (auto-updates AI keywords!)
await assignmentRepo.markAsCompleted(assignmentId);
```

### 6. Chat

```dart
final chatRepo = ref.watch(chatRepositoryProvider);

// Create/get session
final session = await chatRepo.createOrGetSession(
  pasienId: pasienId,
  dokterId: dokterId,
);

// Send message (auto-creates notification!)
await chatRepo.sendMessage(
  sessionId: sessionId,
  message: messageModel,
);

// Real-time messages
StreamBuilder(
  stream: chatRepo.streamMessages(sessionId),
  builder: (context, snapshot) { ... },
);
```

### 7. Notifications

```dart
final notifRepo = ref.watch(notificationRepositoryProvider);

// Get notifications
final result = await notifRepo.getUserNotifications(userId: userId);

// Mark as read
await notifRepo.markAsRead(notificationId);

// Real-time unread count
StreamBuilder(
  stream: notifRepo.streamUnreadCount(userId),
  builder: (context, snapshot) {
    final count = snapshot.data ?? 0;
    return Badge(label: Text('$count'));
  },
);
```

### 8. AI Recommendations

```dart
final aiRepo = ref.watch(aiRecommendationRepositoryProvider);

// Generate recommendations (full AI workflow!)
await aiRepo.generateRecommendationsForPasien(pasienId: userId);

// Get recommendations
final result = await aiRepo.getRecommendationsForPasien(
  pasienId: userId,
  limit: 10,
);

// Real-time recommendations
StreamBuilder(
  stream: aiRepo.streamRecommendationsForPasien(userId),
  builder: (context, snapshot) { ... },
);
```

---

## 🎨 UI Patterns

### Pattern 1: ConsumerWidget (Recommended)

```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final isSignedIn = ref.watch(isSignedInProvider);

    return isSignedIn ? HomePage() : LoginPage();
  }
}
```

### Pattern 2: Consumer (Partial Rebuild)

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(currentUserProvider);
          return Text('User: ${user?.email}');
        },
      ),
    );
  }
}
```

### Pattern 3: FutureProvider

```dart
final userProfileProvider = FutureProvider.family<PasienProfileModel, String>(
  (ref, userId) async {
    final profileRepo = ref.watch(profileRepositoryProvider);
    final result = await profileRepo.getPasienProfile(userId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (profile) => profile,
    );
  },
);

// In UI
class ProfilePage extends ConsumerWidget {
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider(userId));

    return profileAsync.when(
      data: (profile) => Text(profile.namaLengkap),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
```

### Pattern 4: StreamProvider

```dart
final notificationsProvider = StreamProvider.family<List<NotificationModel>, String>(
  (ref, userId) {
    final dataSource = ref.watch(notificationDataSourceProvider);
    return dataSource.streamUserNotifications(userId);
  },
);

// In UI
class NotificationsPage extends ConsumerWidget {
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider(userId));

    return notifsAsync.when(
      data: (notifs) => ListView.builder(
        itemCount: notifs.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(notifs[i].title),
          subtitle: Text(notifs[i].body),
        ),
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
```

### Pattern 5: StateNotifier (Complex State)

```dart
class AuthState {
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.isLoading = false, this.errorMessage});

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepo;

  AuthNotifier(this._authRepo) : super(AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepo.signIn(email: email, password: password);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(isLoading: false),
    );
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepo);
});

// In UI
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.isLoading) {
      return CircularProgressIndicator();
    }

    return ElevatedButton(
      onPressed: () {
        ref.read(authStateProvider.notifier).signIn(email, password);
      },
      child: Text('Login'),
    );
  }
}
```

---

## ⚡ Auto-Orchestration Features

### ✅ Auto-Created Notifications

**Assignment Creation:**

```dart
// When you create assignment:
await assignmentRepo.createAssignment(assignment);

// Automatically:
// 1. Validates assignment
// 2. Checks duplicate
// 3. Verifies konten published
// 4. Verifies pasien exists
// 5. Creates assignment
// 6. ⭐ CREATES NOTIFICATION for pasien (with dokter name)
```

**Chat Message:**

```dart
// When you send message:
await chatRepo.sendMessage(sessionId: id, message: msg);

// Automatically:
// 1. Validates message
// 2. Checks spam
// 3. Sends message
// 4. ⭐ CREATES NOTIFICATION for recipient (with sender name)
```

### ✅ Auto-Updated AI Keywords

```dart
// When you mark assignment complete:
await assignmentRepo.markAsCompleted(assignmentId);

// Automatically:
// 1. Gets konten AI keywords
// 2. Gets current pasien AI keywords
// 3. ⭐ MERGES KEYWORDS (union)
// 4. UPDATES PASIEN PROFILE
```

### ✅ Sequential Reading Enforcement

```dart
// Cannot skip sections:
await assignmentRepo.updateCurrentBagian(
  assignmentId: id,
  newBagian: 5,  // ❌ Will fail if currently on section 3
);

// Must read sequentially:
await assignmentRepo.updateCurrentBagian(
  assignmentId: id,
  newBagian: 4,  // ✅ OK if currently on section 3
);
```

### ✅ AI Recommendation Auto-Cleanup

```dart
// When you generate recommendations:
await aiRepo.generateRecommendationsForPasien(pasienId: id);

// Automatically:
// 1. Gets pasien keywords
// 2. Searches konten
// 3. Calculates relevance
// 4. Creates recommendations
// 5. ⭐ DELETES RECOMMENDATIONS older than 30 days
```

---

## 🎯 All Available Repositories

```dart
// Auth
ref.watch(authRepositoryProvider)

// Profile (dokter & pasien)
ref.watch(profileRepositoryProvider)

// Konten (educational content)
ref.watch(kontenRepositoryProvider)

// Assignment (konten assignments)
ref.watch(assignmentRepositoryProvider)

// Chat (sessions & messages)
ref.watch(chatRepositoryProvider)

// Notifications
ref.watch(notificationRepositoryProvider)

// AI Recommendations
ref.watch(aiRecommendationRepositoryProvider)
```

---

## 📚 Full Documentation

For complete documentation, see:

- `STEP_3C_RIVERPOD_PROVIDERS_COMPLETE.md` - Full guide
- `STEP_3C_SUMMARY.md` - Quick summary
- `DEPENDENCY_MAP.md` - Visual dependency graph
- `lib/core/providers/providers.dart` - Code documentation

---

## ✅ Quick Checklist

Before using providers, make sure:

1. ✅ Import providers: `import 'package:aconsia_app/core/providers/providers.dart';`
2. ✅ Use ConsumerWidget or Consumer
3. ✅ Access via `ref.watch()`
4. ✅ Handle Either<Failure, Success> with `.fold()`
5. ✅ Never use datasources directly in UI
6. ✅ Always use repositories

---

**Happy Coding!** 🚀
