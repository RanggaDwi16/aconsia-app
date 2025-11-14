// import 'package:aconsia_app/data/datasources/auth_datasource.dart';
// import 'package:aconsia_app/data/datasources/profile_datasource.dart';
// import 'package:aconsia_app/data/datasources/konten_datasource.dart';
// import 'package:aconsia_app/data/datasources/assignment_datasource.dart';
// import 'package:aconsia_app/data/datasources/chat_datasource.dart';
// import 'package:aconsia_app/data/datasources/notification_datasource.dart';
// import 'package:aconsia_app/data/datasources/ai_recommendation_datasource.dart';
// import 'package:aconsia_app/core/providers/firebase_providers.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ==================== DATASOURCE PROVIDERS ====================
// // These providers create singleton instances of all datasources
// // with proper Firebase instance injection.

// /// Provider for AuthDataSource
// ///
// /// Provides the datasource for authentication operations.
// /// Dependencies: FirebaseAuth, FirebaseFirestore
// final authDataSourceProvider = Provider<AuthDataSource>((ref) {
//   final auth = ref.watch(firebaseAuthProvider);
//   final firestore = ref.watch(firebaseFirestoreProvider);

//   return AuthDataSource(
//     firebaseAuth: auth,
//     firestore: firestore,
//   );
// });

// /// Provider for ProfileDataSource
// ///
// /// Provides the datasource for profile (dokter & pasien) operations.
// /// Dependencies: FirebaseFirestore
// final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
//   final firestore = ref.watch(firebaseFirestoreProvider);

//   return ProfileDataSource(firestore: firestore);
// });

// /// Provider for KontenDataSource
// ///
// /// Provides the datasource for konten (content) operations.
// /// Dependencies: FirebaseFirestore
// final kontenDataSourceProvider = Provider<KontenDataSource>((ref) {
//   final firestore = ref.watch(firebaseFirestoreProvider);

//   return KontenDataSource(firestore: firestore);
// });

// /// Provider for AssignmentDataSource
// ///
// /// Provides the datasource for assignment operations.
// /// Dependencies: FirebaseFirestore
// final assignmentDataSourceProvider = Provider<AssignmentDataSource>((ref) {
//   final firestore = ref.watch(firebaseFirestoreProvider);

//   return AssignmentDataSource(firestore: firestore);
// });

// /// Provider for ChatDataSource
// ///
// /// Provides the datasource for chat (session & message) operations.
// /// Dependencies: FirebaseFirestore
// final chatDataSourceProvider = Provider<ChatDataSource>((ref) {
//   final firestore = ref.watch(firebaseFirestoreProvider);

//   return ChatDataSource(firestore: firestore);
// });

// /// Provider for NotificationDataSource
// ///
// /// Provides the datasource for notification operations.
// /// Dependencies: FirebaseFirestore
// final notificationDataSourceProvider = Provider<NotificationDataSource>((ref) {
//   final firestore = ref.watch(firebaseFirestoreProvider);

//   return NotificationDataSource(firestore: firestore);
// });

// /// Provider for AIRecommendationDataSource
// ///
// /// Provides the datasource for AI recommendation operations.
// /// Dependencies: FirebaseFirestore
// final aiRecommendationDataSourceProvider =
//     Provider<AIRecommendationDataSource>((ref) {
//   final firestore = ref.watch(firebaseFirestoreProvider);

//   return AIRecommendationDataSource(firestore: firestore);
// });
