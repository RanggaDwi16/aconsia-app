/// Central export file for all Riverpod providers in the ACONSIA app.
///
/// This file provides a single import point for all providers,
/// making it easy to access any provider throughout the app.
///
/// **Usage:**
/// ```dart
/// import 'package:aconsia_app/core/providers/providers.dart';
///
/// // In a ConsumerWidget or Consumer
/// final authRepo = ref.watch(authRepositoryProvider);
/// final currentUser = ref.watch(currentUserProvider);
/// ```
///
/// **Provider Categories:**
///
/// 1. **Firebase Providers** (firebase_providers.dart)
///    - firebaseAuthProvider
///    - firebaseFirestoreProvider
///    - firebaseStorageProvider
///    - authStateChangesProvider
///    - currentUserProvider
///    - currentUserIdProvider
///    - isSignedInProvider
///
/// 2. **DataSource Providers** (datasource_providers.dart)
///    - authDataSourceProvider
///    - profileDataSourceProvider
///    - kontenDataSourceProvider
///    - assignmentDataSourceProvider
///    - chatDataSourceProvider
///    - notificationDataSourceProvider
///    - aiRecommendationDataSourceProvider
///
/// 3. **Repository Providers** (repository_providers.dart)
///    - authRepositoryProvider
///    - profileRepositoryProvider
///    - kontenRepositoryProvider
///    - assignmentRepositoryProvider
///    - chatRepositoryProvider
///    - notificationRepositoryProvider
///    - aiRecommendationRepositoryProvider
///
/// **Architecture:**
///
/// ```
/// UI Layer (Widgets)
///       ↓
/// Repository Layer (Business Logic) ← YOU SHOULD USE THESE
///       ↓
/// DataSource Layer (Firebase Operations)
///       ↓
/// Firebase Services (Auth, Firestore, Storage)
/// ```
///
/// **Best Practices:**
///
/// 1. **In UI, use Repository Providers** (not datasources directly)
///    ```dart
///    // ✅ Good
///    final authRepo = ref.watch(authRepositoryProvider);
///    await authRepo.signIn(email: email, password: password);
///
///    // ❌ Bad - don't use datasources directly in UI
///    final authDataSource = ref.watch(authDataSourceProvider);
///    ```
///
/// 2. **Use StateNotifier/AsyncNotifier for complex state**
///    ```dart
///    // For complex UI state, create a StateNotifier
///    final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
///      final authRepo = ref.watch(authRepositoryProvider);
///      return AuthNotifier(authRepo);
///    });
///    ```
///
/// 3. **Use FutureProvider/StreamProvider for async data**
///    ```dart
///    // Get user profile
///    final userProfileProvider = FutureProvider.family<ProfileModel, String>((ref, userId) {
///      final profileRepo = ref.watch(profileRepositoryProvider);
///      return profileRepo.getPasienProfile(userId).then(
///        (result) => result.fold(
///          (failure) => throw Exception(failure.message),
///          (profile) => profile,
///        ),
///      );
///    });
///    ```
///
/// 4. **Handle Either<Failure, Success> properly**
///    ```dart
///    final result = await authRepo.signIn(email: email, password: password);
///    result.fold(
///      (failure) {
///        // Handle error
///        ScaffoldMessenger.of(context).showSnackBar(
///          SnackBar(content: Text(failure.message)),
///        );
///      },
///      (user) {
///        // Handle success
///        Navigator.pushReplacementNamed(context, '/home');
///      },
///    );
///    ```
library;

// Export all provider files
export 'datasource_providers.dart';
export 'repository_providers.dart';
export 'cloudinary_providers.dart';
export 'image_upload_notifier.dart';
