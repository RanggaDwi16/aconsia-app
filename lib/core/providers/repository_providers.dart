// import 'package:aconsia_app/data/repositories/auth_repository_impl.dart';
// import 'package:aconsia_app/data/repositories/profile_repository_impl.dart';
// import 'package:aconsia_app/data/repositories/konten_repository_impl.dart';
// import 'package:aconsia_app/data/repositories/assignment_repository_impl.dart';
// import 'package:aconsia_app/data/repositories/chat_repository_impl.dart';
// import 'package:aconsia_app/data/repositories/notification_repository_impl.dart';
// import 'package:aconsia_app/data/repositories/ai_recommendation_repository_impl.dart';
// import 'package:aconsia_app/domain/repositories/auth_repository.dart';
// import 'package:aconsia_app/domain/repositories/profile_repository.dart';
// import 'package:aconsia_app/domain/repositories/konten_repository.dart';
// import 'package:aconsia_app/domain/repositories/assignment_repository.dart';
// import 'package:aconsia_app/domain/repositories/chat_repository.dart';
// import 'package:aconsia_app/domain/repositories/notification_repository.dart';
// import 'package:aconsia_app/domain/repositories/ai_recommendation_repository.dart';
// import 'package:aconsia_app/core/providers/datasource_providers.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ==================== REPOSITORY PROVIDERS ====================
// // These providers create singleton instances of all repositories
// // with proper datasource dependency injection.
// //
// // Repositories expose domain interfaces and encapsulate:
// // - Input validation
// // - Business logic
// // - Multi-datasource orchestration
// // - Error handling with Either<Failure, Success> pattern

// /// Provider for AuthRepository
// ///
// /// Provides the repository for authentication operations.
// ///
// /// **Capabilities:**
// /// - Sign up (email/password with role validation)
// /// - Sign in (email/password)
// /// - Sign out
// /// - Password reset
// /// - Profile completion tracking
// /// - Account deletion
// ///
// /// **Dependencies:** AuthDataSource
// ///
// /// **Example usage:**
// /// ```dart
// /// final authRepo = ref.watch(authRepositoryProvider);
// /// final result = await authRepo.signIn(
// ///   email: 'user@example.com',
// ///   password: 'password123',
// /// );
// /// ```
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   final authDataSource = ref.watch(authDataSourceProvider);

//   return AuthRepositoryImpl(authDataSource: authDataSource);
// });

// /// Provider for ProfileRepository
// ///
// /// Provides the repository for profile management (dokter & pasien).
// ///
// /// **Capabilities:**
// /// - Create/update dokter profiles (with STR number validation)
// /// - Create/update pasien profiles (with Indonesian phone validation)
// /// - Photo URL management
// /// - Favorites management
// /// - AI keywords management
// /// - Profile retrieval by ID or email
// ///
// /// **Dependencies:** ProfileDataSource
// ///
// /// **Example usage:**
// /// ```dart
// /// final profileRepo = ref.watch(profileRepositoryProvider);
// /// final result = await profileRepo.createPasienProfile(pasienProfile);
// /// ```
// // final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
// //   final profileDataSource = ref.watch(profileDataSourceProvider);

// //   return ProfileRepositoryImpl(profileDataSource: profileDataSource);
// // });

// /// Provider for KontenRepository
// ///
// /// Provides the repository for konten (educational content) management.
// ///
// /// **Capabilities:**
// /// - Create konten with sections (batch operation)
// /// - Update konten metadata
// /// - Add/update/delete sections
// /// - Publish/unpublish konten
// /// - Search by keywords
// /// - Get konten with sections (joined query)
// /// - Judul uniqueness validation
// ///
// /// **Dependencies:** KontenDataSource
// ///
// /// **Example usage:**
// /// ```dart
// /// final kontenRepo = ref.watch(kontenRepositoryProvider);
// /// final result = await kontenRepo.createKonten(
// ///   konten: kontenModel,
// ///   sections: sectionsList,
// /// );
// /// ```
// final kontenRepositoryProvider = Provider<KontenRepository>((ref) {
//   final kontenDataSource = ref.watch(kontenDataSourceProvider);

//   return KontenRepositoryImpl(kontenDataSource: kontenDataSource);
// });

// /// Provider for AssignmentRepository
// ///
// /// Provides the repository for assignment management with complex orchestration.
// ///
// /// **Capabilities:**
// /// - Create assignment (validates konten is published, pasien exists, no duplicates)
// /// - Update current section (enforces sequential reading - cannot skip)
// /// - Mark as completed (auto-updates pasien AI keywords from konten)
// /// - Get assignments by pasien/dokter
// /// - Calculate completion percentage
// /// - Auto-create notifications on assignment creation
// ///
// /// **Dependencies:**
// /// - AssignmentDataSource
// /// - KontenDataSource (verify konten exists & published)
// /// - ProfileDataSource (verify pasien exists, get dokter name, update AI keywords)
// /// - NotificationDataSource (auto-create assignment notification)
// ///
// /// **Example usage:**
// /// ```dart
// /// final assignmentRepo = ref.watch(assignmentRepositoryProvider);
// /// final result = await assignmentRepo.createAssignment(assignmentModel);
// /// // Automatically creates notification for pasien
// /// ```
// final assignmentRepositoryProvider = Provider<AssignmentRepository>((ref) {
//   final assignmentDataSource = ref.watch(assignmentDataSourceProvider);
//   final kontenDataSource = ref.watch(kontenDataSourceProvider);
//   final profileDataSource = ref.watch(profileDataSourceProvider);
//   final notificationDataSource = ref.watch(notificationDataSourceProvider);

//   return AssignmentRepositoryImpl(
//     assignmentDataSource: assignmentDataSource,
//     kontenDataSource: kontenDataSource,
//     profileDataSource: profileDataSource,
//     notificationDataSource: notificationDataSource,
//   );
// });

// /// Provider for ChatRepository
// ///
// /// Provides the repository for chat session and message management.
// ///
// /// **Capabilities:**
// /// - Create/get chat sessions (validates pasienId != dokterId)
// /// - Send messages (validates length, inappropriate content, spam)
// /// - Get messages (paginated with cursor)
// /// - Mark messages as read
// /// - Reset unread counts
// /// - Real-time message streams
// /// - Auto-create notifications on message send
// ///
// /// **Dependencies:**
// /// - ChatDataSource
// /// - NotificationDataSource (auto-create chat notification)
// /// - ProfileDataSource (get sender name for notification)
// ///
// /// **Example usage:**
// /// ```dart
// /// final chatRepo = ref.watch(chatRepositoryProvider);
// /// final result = await chatRepo.sendMessage(
// ///   sessionId: sessionId,
// ///   message: messageModel,
// /// );
// /// // Automatically creates notification for recipient
// /// ```
// final chatRepositoryProvider = Provider<ChatRepository>((ref) {
//   final chatDataSource = ref.watch(chatDataSourceProvider);
//   final notificationDataSource = ref.watch(notificationDataSourceProvider);
//   final profileDataSource = ref.watch(profileDataSourceProvider);

//   return ChatRepositoryImpl(
//     chatDataSource: chatDataSource,
//     notificationDataSource: notificationDataSource,
//     profileDataSource: profileDataSource,
//   );
// });

// /// Provider for NotificationRepository
// ///
// /// Provides the repository for notification management.
// ///
// /// **Capabilities:**
// /// - Create notifications (validates type, user ID, content)
// /// - Get user notifications (paginated)
// /// - Get unread notifications
// /// - Mark as read (single/all)
// /// - Delete notifications (single/all)
// /// - Get unread count
// /// - Real-time notification streams
// /// - Helper methods for chat & assignment notifications
// /// - User preference checking (extendable for do-not-disturb)
// ///
// /// **Dependencies:** NotificationDataSource
// ///
// /// **Example usage:**
// /// ```dart
// /// final notifRepo = ref.watch(notificationRepositoryProvider);
// /// final result = await notifRepo.createChatNotification(
// ///   recipientId: recipientId,
// ///   senderName: 'Dr. Smith',
// ///   message: 'Hello!',
// ///   sessionId: sessionId,
// /// );
// /// ```
// final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
//   final notificationDataSource = ref.watch(notificationDataSourceProvider);

//   return NotificationRepositoryImpl(
//     notificationDataSource: notificationDataSource,
//   );
// });

// /// Provider for AIRecommendationRepository
// ///
// /// Provides the repository for AI-powered content recommendation.
// ///
// /// **Capabilities:**
// /// - Create single/batch recommendations
// /// - Get recommendations for pasien (paginated)
// /// - Get unviewed recommendations
// /// - Mark as viewed
// /// - Delete recommendations (single/all)
// /// - Check if recommendation exists (duplicate prevention)
// /// - Get recommendation count
// /// - Search by keywords
// /// - Real-time recommendation streams
// /// - **AI Orchestration:** Generate recommendations based on pasien AI keywords
// /// - **Auto cleanup:** Clear old recommendations (30 days)
// /// - **Keyword management:** Update pasien keywords from completed konten
// ///
// /// **Dependencies:**
// /// - AIRecommendationDataSource
// /// - KontenDataSource (search konten by keywords)
// /// - ProfileDataSource (get/update pasien AI keywords)
// ///
// /// **AI Workflow (generateRecommendationsForPasien):**
// /// 1. Get pasien's AI keywords
// /// 2. Search konten matching those keywords
// /// 3. Calculate relevance scores (keyword match percentage)
// /// 4. Filter by 20% relevance threshold
// /// 5. Prevent duplicates
// /// 6. Batch create recommendations
// /// 7. Auto-cleanup old recommendations (30 days)
// ///
// /// **Example usage:**
// /// ```dart
// /// final aiRepo = ref.watch(aiRecommendationRepositoryProvider);
// ///
// /// // Generate AI recommendations
// /// final result = await aiRepo.generateRecommendationsForPasien(
// ///   pasienId: pasienId,
// /// );
// ///
// /// // Update pasien keywords from completed konten
// /// await aiRepo.updatePasienKeywordsFromKonten(
// ///   pasienId: pasienId,
// ///   kontenId: kontenId,
// /// );
// /// ```
// final aiRecommendationRepositoryProvider =
//     Provider<AIRecommendationRepository>((ref) {
//   final aiRecommendationDataSource =
//       ref.watch(aiRecommendationDataSourceProvider);
//   final kontenDataSource = ref.watch(kontenDataSourceProvider);
//   final profileDataSource = ref.watch(profileDataSourceProvider);

//   return AIRecommendationRepositoryImpl(
//     aiRecommendationDataSource: aiRecommendationDataSource,
//     kontenDataSource: kontenDataSource,
//     profileDataSource: profileDataSource,
//   );
// });
