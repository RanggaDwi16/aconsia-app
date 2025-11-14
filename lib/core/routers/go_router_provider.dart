import 'dart:math';

import 'package:aconsia_app/core/providers/token_manager_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/presentation/auth/pages/forgot_password_page.dart';
import 'package:aconsia_app/presentation/auth/pages/helpdesk_page.dart';
import 'package:aconsia_app/presentation/auth/pages/login_dokter_page.dart';
import 'package:aconsia_app/presentation/auth/pages/login_pasien_page.dart';
import 'package:aconsia_app/presentation/auth/pages/register_dokter_page.dart';
import 'package:aconsia_app/presentation/auth/pages/register_pasien_page.dart';
import 'package:aconsia_app/presentation/auth/pages/splash_page.dart';
import 'package:aconsia_app/presentation/auth/pages/welcome_page.dart';
import 'package:aconsia_app/presentation/dokter/home/pages/add_pasien_medic_information_page.dart';
import 'package:aconsia_app/presentation/dokter/home/pages/detail_pasien_page.dart';
import 'package:aconsia_app/presentation/dokter/home/pages/list_active_pasien_page.dart';
import 'package:aconsia_app/presentation/dokter/konten/pages/add_konten_page.dart';
import 'package:aconsia_app/presentation/dokter/konten/pages/edit_konten_page.dart';
import 'package:aconsia_app/presentation/dokter/main/pages/main_dokter_page.dart';
import 'package:aconsia_app/presentation/dokter/profile/pages/edit_profile_page.dart';
import 'package:aconsia_app/presentation/pasien/home/pages/all_recommendations_page.dart';
import 'package:aconsia_app/presentation/pasien/konten/pages/chat_ai_page.dart';
import 'package:aconsia_app/presentation/pasien/konten/pages/detail_konten_page.dart';
import 'package:aconsia_app/presentation/pasien/konten/pages/hasil_chat_ai_page.dart';
import 'package:aconsia_app/presentation/pasien/quiz/pages/quiz_result_page.dart';
import 'package:aconsia_app/presentation/pasien/main/pages/main_pasien_page.dart';
import 'package:aconsia_app/presentation/pasien/profile/pages/edit_profile_pasien_page.dart';
import 'package:aconsia_app/presentation/pasien/profile/pages/profile_pasien_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

@Riverpod(keepAlive: true)
Raw<GoRouter> router(Ref ref) {
  return GoRouter(
    initialLocation: '/welcome',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/welcome',
        name: RouteName.welcome,
        builder: (context, state) => const WelcomePage(),
        redirect: (context, state) async {
          final tokenManager = await ref.read(tokenManagerProvider.future);
          final isProfileCompleted = await tokenManager.isProfileCompleted();
          final user = await tokenManager.getRole();

          if (user != null && user.isNotEmpty) {
            if (user == 'dokter') {
              if (!isProfileCompleted) {
                return RouteName.editProfile;
              }
              return RouteName.mainDokter;
            } else if (user == 'pasien') {
              if (!isProfileCompleted) {
                return RouteName.editProfilePasien;
              }
              return RouteName.mainPasien;
            }
          }
          return null;
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: RouteName.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/login-dokter',
        name: RouteName.loginDokter,
        builder: (context, state) => LoginDokterPage(),
      ),
      GoRoute(
        path: '/register-dokter',
        name: RouteName.registerDokter,
        builder: (context, state) => RegisterDokterPage(),
      ),
      GoRoute(
        path: '/login-pasien',
        name: RouteName.loginPasien,
        builder: (context, state) => LoginPasienPage(),
      ),
      GoRoute(
        path: '/register-pasien',
        name: RouteName.registerPasien,
        builder: (context, state) => RegisterPasienPage(),
      ),
      GoRoute(
        path: '/helpdesk',
        name: RouteName.helpdesk,
        builder: (context, state) => HelpdeskPage(),
      ),
      GoRoute(
        path: '/main-dokter',
        name: RouteName.mainDokter,
        builder: (context, state) => MainDokterPage(),
      ),
      GoRoute(
          path: '/add-pasien-medic-information',
          name: RouteName.addPasienMedicInformation,
          builder: (context, state) {
            final pasienId = state.extra as String?;
            return AddPasienMedicInformationPage(pasienId: pasienId);
          }),
      GoRoute(
        path: '/main-pasien',
        name: RouteName.mainPasien,
        builder: (context, state) => MainPasienPage(),
      ),
      GoRoute(
        path: '/detail-pasien',
        name: RouteName.detailPasien,
        builder: (context, state) {
          final pasienId = state.extra as String?;
          return DetailPasienPage(pasienId: pasienId);
        },
      ),
      GoRoute(
        path: '/profile-pasien',
        name: RouteName.profilePasien,
        builder: (context, state) => ProfilePasienPage(),
      ),
      GoRoute(
        path: '/list-active-pasien',
        name: RouteName.listActivePasien,
        builder: (context, state) => ListActivePasienPage(),
      ),
      GoRoute(
        path: '/add-konten',
        name: RouteName.addKonten,
        builder: (context, state) => AddKontenPage(),
      ),
      GoRoute(
        path: '/edit-konten',
        name: RouteName.editKonten,
        builder: (context, state) {
          final konteId = state.extra as String?;
          return EditKontenPage(kontenId: konteId!);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        name: RouteName.editProfile,
        builder: (context, state) => EditProfilePage(),
      ),
      GoRoute(
        path: '/edit-profile-pasien',
        name: RouteName.editProfilePasien,
        builder: (context, state) => EditProfilePasienPage(),
      ),
      GoRoute(
        path: '/detail-konten',
        name: RouteName.detailKonten,
        builder: (context, state) {
          final konteId = state.extra as String?;
          return DetailKontenPage(kontenId: konteId);
        },
      ),
      GoRoute(
        path: '/chat-ai',
        name: RouteName.chatAi,
        builder: (context, state) => ChatAiPage(),
      ),
      GoRoute(
        path: '/hasil-chat-ai',
        name: RouteName.hasilChatAi,
        builder: (context, state) => HasilChatAiPage(),
      ),
      GoRoute(
        path: '/quiz-result',
        name: RouteName.quizResult,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          
          // Safe casting for quizResults
          final quizResultsRaw = data['quizResults'];
          final List<Map<String, dynamic>> quizResults;
          
          if (quizResultsRaw is List) {
            quizResults = quizResultsRaw
                .map((e) => e is Map<String, dynamic> 
                    ? e 
                    : (e as Map).cast<String, dynamic>())
                .toList();
          } else {
            quizResults = [];
          }
          
          return QuizResultPage(
            konten: data['konten'],
            sessionId: data['sessionId'],
            quizResults: quizResults,
            preGeneratedSummary: data['summary'], // For free chat mode
          );
        },
      ),
      GoRoute(
        path: '/all-recommendations',
        name: RouteName.allRecommendations,
        builder: (context, state) => const AllRecommendationsPage(),
      ),
      // Notification routes - Hidden for now (Phase 3)
      // GoRoute(
      //   path: '/notification-list',
      //   name: RouteName.notificationList,
      //   builder: (context, state) => const NotificationListPage(),
      // ),
      // Assignment routes - Hidden for now (Phase 2)
      // GoRoute(
      //   path: '/assignment-list',
      //   name: RouteName.assignmentList,
      //   builder: (context, state) => const AssignmentListPage(),
      // ),
      // GoRoute(
      //   path: '/assignment-detail',
      //   name: RouteName.assignmentDetail,
      //   builder: (context, state) {
      //     final data = state.extra as Map<String, dynamic>;
      //     return AssignmentDetailPage(
      //       assignment: data['assignment'],
      //       konten: data['konten'],
      //     );
      //   },
      // ),
    ],
  );
}
