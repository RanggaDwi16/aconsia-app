import 'package:aconsia_app/assignment/controllers/mark_as_completed/post_mark_as_completed_provider.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/services/openai_service.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/quiz_result_model.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/ai_recommendation_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizResultPage extends HookConsumerWidget {
  final KontenModel konten;
  final String sessionId; // Reading session ID
  final List<Map<String, dynamic>> quizResults;
  final Map<String, dynamic>? preGeneratedSummary; // For free chat mode
  final String? source;

  const QuizResultPage({
    super.key,
    required this.konten,
    required this.sessionId,
    required this.quizResults,
    this.preGeneratedSummary, // Optional: null for quiz mode, filled for free chat
    this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openAI = ref.watch(openAIServiceProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final isLoading = useState(true);
    final summary = useState<Map<String, dynamic>?>(null);
    final resolvedKontenId = (konten.id ?? '').trim().isEmpty
        ? 'standalone_ai'
        : konten.id!.trim();
    final sourceTag = (source ?? '').trim().isEmpty
        ? (resolvedKontenId == 'standalone_ai'
            ? 'ai_chat_standalone'
            : 'ai_chat_contextual')
        : source!.trim();
    final isStandaloneSession =
        sessionId.startsWith('standalone_') || resolvedKontenId == 'standalone_ai';

    // Generate learning summary on load
    useEffect(() {
      Future.microtask(() async {
        try {
          // Use pre-generated summary if available (free chat mode)
          // Otherwise generate from quiz results (quiz mode)
          final response = preGeneratedSummary ??
              await openAI.generateLearningSummary(
                kontenTitle: konten.judul ?? 'Materi Pembelajaran',
                quizResults: quizResults,
              );

          summary.value = response;

          // Save quiz result to Firestore
          final quizResultModel = QuizResultModel(
            id: '', // Will be set by provider
            pasienId: uid,
            kontenId: resolvedKontenId,
            sessionId: sessionId,
            overallScore: response['overall_score'] ?? 0,
            status: response['status'] ?? 'fair',
            strengths: (response['strengths'] as List?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
            areasToImprove: (response['areas_to_improve'] as List?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
            summary: response['summary']?.toString() ?? '',
            recommendations: (response['recommendations'] as List?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
            motivationalMessage: response['motivational_message']?.toString(),
            questionResults: [
              ...quizResults,
              {
                '_meta': {
                  'source': sourceTag,
                  'sessionType': isStandaloneSession
                      ? 'standalone_ai'
                      : 'konten_ai',
                },
              }
            ],
            completedAt: DateTime.now(),
          );

          // DEBUG: Print konten ID sebelum save
          await ref.read(saveQuizResultProvider.notifier).save(quizResultModel);

          // Invalidate AI recommendations to refresh recommendations list
          ref.invalidate(fetchAiRecommendationsProvider);
          ref.invalidate(fetchAllUnreadKontenProvider);

          // End reading session after summary generated
          if (!isStandaloneSession) {
            await ref
                .read(endReadingSessionProvider.notifier)
                .endSession(sessionId: sessionId);
          }

          // Check if this is from assignment, mark as completed if score >= 70
          final avgScore = response['overall_score'] ?? 0;
          if (avgScore >= 70 && resolvedKontenId != 'standalone_ai') {
            // Try to mark assignment as completed (if exists)
            // We'll get assignmentId from the assignment provider
            try {
              // Get assignment for this konten + pasien
              final assignmentId =
                  await _getAssignmentId(ref, uid, resolvedKontenId);
              if (assignmentId != null) {
                await ref
                    .read(postMarkAsCompletedProvider.notifier)
                    .postMarkAsCompleted(assignmentId: assignmentId);
              }
            } catch (e) {
              // Assignment doesn't exist, skip marking complete
            }
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal generate rangkuman: $e')),
          );
        } finally {
          isLoading.value = false;
        }
      });
      return null;
    }, []);

    return Scaffold(
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : AconsiaPageBackground(
              colors: const [UiPalette.blue50, UiPalette.white],
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(UiSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AconsiaTopActionRow(
                      title: 'Ringkasan Sesi AI',
                      subtitle: 'Ringkasan pemahaman setelah sesi pembelajaran',
                      onBack: () {
                        if (GoRouter.of(context).canPop()) {
                          context.pop();
                          return;
                        }
                        ref.read(selectedIndexPasienProvider.notifier).state = 0;
                        context.goNamed(RouteName.mainPasien);
                      },
                    ),
                    const Gap(UiSpacing.sm),
                    _buildScoreCard(summary.value!),
                    const Gap(UiSpacing.md),
                    if (summary.value!['strengths'] != null &&
                        (summary.value!['strengths'] as List).isNotEmpty) ...[
                      _buildSection(
                        icon: Icons.check_circle,
                        iconColor: UiPalette.emerald600,
                        title: 'Yang Sudah Dikuasai',
                        items: (summary.value!['strengths'] as List)
                            .map((e) => e.toString())
                            .toList(),
                        backgroundColor: UiPalette.emerald50,
                        borderColor: UiPalette.emerald100,
                      ),
                      const Gap(UiSpacing.sm),
                    ],
                    if (summary.value!['areas_to_improve'] != null &&
                        (summary.value!['areas_to_improve'] as List)
                            .isNotEmpty) ...[
                      _buildSection(
                        icon: Icons.lightbulb_outline,
                        iconColor: UiPalette.amber600,
                        title: 'Perlu Dipelajari Lebih Lanjut',
                        items: (summary.value!['areas_to_improve'] as List)
                            .map((e) => e.toString())
                            .toList(),
                        backgroundColor: UiPalette.amber50,
                        borderColor: UiPalette.amber100,
                      ),
                      const Gap(UiSpacing.sm),
                    ],
                    _buildSummaryCard(summary.value!['summary']),
                    const Gap(UiSpacing.sm),
                    if (summary.value!['recommendations'] != null &&
                        (summary.value!['recommendations'] as List)
                            .isNotEmpty) ...[
                      _buildRecommendationsCard(
                        (summary.value!['recommendations'] as List)
                            .map((e) => e.toString())
                            .toList(),
                      ),
                      const Gap(UiSpacing.sm),
                    ],
                    _buildMotivationalCard(summary.value!['motivational_message']),
                    const Gap(UiSpacing.lg),
                    Button.filled(
                      onPressed: () {
                        context.goNamed(RouteName.mainPasien);
                      },
                      label: 'Kembali ke Beranda',
                      borderRadius: 12,
                      height: 48,
                    ),
                    const Gap(UiSpacing.xs),
                    Button.outlined(
                      onPressed: resolvedKontenId == 'standalone_ai'
                          ? () {}
                          : () {
                              context.pushNamed(
                                RouteName.detailKonten,
                                extra: resolvedKontenId,
                              );
                            },
                      disabled: resolvedKontenId == 'standalone_ai',
                      label: 'Review Materi Kembali',
                      borderRadius: 12,
                      height: 48,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildScoreCard(Map<String, dynamic> summary) {
    final score = summary['overall_score'] ?? 0;
    final status = summary['status'] ?? 'fair';

    Color scoreColor;
    String statusText;
    IconData icon;

    if (status == 'excellent') {
      scoreColor = Colors.green;
      statusText = 'Luar Biasa!';
      icon = Icons.emoji_events;
    } else if (status == 'good') {
      scoreColor = Colors.blue;
      statusText = 'Bagus!';
      icon = Icons.thumb_up;
    } else if (status == 'fair') {
      scoreColor = Colors.orange;
      statusText = 'Cukup Baik';
      icon = Icons.sentiment_satisfied;
    } else {
      scoreColor = Colors.red;
      statusText = 'Perlu Belajar Lagi';
      icon = Icons.school;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF5FF), Color(0xFFFFFFFF)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: UiPalette.blue100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 44, color: scoreColor),
          const Gap(UiSpacing.xs),
          Text(
            statusText,
            style: UiTypography.h2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: scoreColor,
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Skor Pemahaman: ',
                style: UiTypography.bodySmall,
              ),
              Text(
                '$score/100',
                style: UiTypography.h1.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const Gap(8),
              Expanded(
                child: Text(
                  title,
                  style: UiTypography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UiPalette.slate900,
                  ),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(8),
                    Expanded(child: Text(item)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return AconsiaCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: UiPalette.blue600),
              Gap(8),
              Text(
                'Rangkuman Pembelajaran',
                style: UiTypography.label,
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          Text(
            summary,
            style: UiTypography.body.copyWith(color: UiPalette.slate700),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(List<String> recommendations) {
    return Container(
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        color: UiPalette.blue50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UiPalette.blue100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.recommend_outlined, color: UiPalette.blue600),
              Gap(8),
              Text(
                'Rekomendasi Selanjutnya',
                style: UiTypography.label,
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          ...recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: UiTypography.label),
                    Expanded(
                      child: Text(
                        rec,
                        style: UiTypography.body.copyWith(color: UiPalette.slate700),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMotivationalCard(String message) {
    return Container(
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [UiPalette.emerald50, UiPalette.blue50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UiPalette.emerald100),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: UiPalette.red600, size: 30),
          const Gap(12),
          Expanded(
            child: Text(
              message,
              style: UiTypography.body.copyWith(
                fontStyle: FontStyle.italic,
                color: UiPalette.slate700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get assignment ID
  Future<String?> _getAssignmentId(
    WidgetRef ref,
    String pasienId,
    String kontenId,
  ) async {
    // Import assignment provider
    // final assignments = await ref
    //     .read(fetchAssignmentsByPasienProvider(pasienId: pasienId).future);
    // return assignments
    //     ?.firstWhere((a) => a.kontenId == kontenId)
    //     .id;

    // For now, return null (will implement in assignment integration phase)
    return null;
  }
}
