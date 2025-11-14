import 'package:aconsia_app/assignment/controllers/mark_as_completed/post_mark_as_completed_provider.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/services/openai_service.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/quiz_result_model.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/ai_recommendation_provider.dart';
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

  const QuizResultPage({
    super.key,
    required this.konten,
    required this.sessionId,
    required this.quizResults,
    this.preGeneratedSummary, // Optional: null for quiz mode, filled for free chat
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openAI = ref.watch(openAIServiceProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final isLoading = useState(true);
    final summary = useState<Map<String, dynamic>?>(null);

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
            kontenId: konten.id!,
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
            questionResults: quizResults,
            completedAt: DateTime.now(),
          );

          // DEBUG: Print konten ID sebelum save
          print('🔥 DEBUG: Saving quiz result for kontenId: ${konten.id}');
          print('🔥 DEBUG: pasienId: $uid');

          await ref.read(saveQuizResultProvider.notifier).save(quizResultModel);

          print('🔥 DEBUG: Quiz result saved successfully!');

          // Invalidate AI recommendations to refresh recommendations list
          ref.invalidate(fetchAiRecommendationsProvider);
          ref.invalidate(fetchAllUnreadKontenProvider);

          // End reading session after summary generated
          print('🔥 DEBUG: Ending reading session: $sessionId');
          await ref
              .read(endReadingSessionProvider.notifier)
              .endSession(sessionId: sessionId);

          print('🔥 DEBUG: Reading session ended successfully!');
          print('🔥 DEBUG: Session $sessionId is now inactive');

          // Check if this is from assignment, mark as completed if score >= 70
          final avgScore = response['overall_score'] ?? 0;
          if (avgScore >= 70) {
            // Try to mark assignment as completed (if exists)
            // We'll get assignmentId from the assignment provider
            try {
              // Get assignment for this konten + pasien
              final assignmentId = await _getAssignmentId(ref, uid, konten.id!);
              if (assignmentId != null) {
                await ref
                    .read(postMarkAsCompletedProvider.notifier)
                    .postMarkAsCompleted(assignmentId: assignmentId);
              }
            } catch (e) {
              // Assignment doesn't exist, skip marking complete
              print('No assignment found: $e');
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
      appBar: CustomAppBar(
        title: 'Hasil Pembelajaran',
        centertitle: true,
        leading: const SizedBox(), // Disable back button
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score Card
                  _buildScoreCard(summary.value!),
                  const Gap(24),

                  // Strengths
                  if (summary.value!['strengths'] != null &&
                      (summary.value!['strengths'] as List).isNotEmpty) ...[
                    _buildSection(
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      title: '✨ Yang Sudah Dikuasai',
                      items: (summary.value!['strengths'] as List)
                          .map((e) => e.toString())
                          .toList(),
                      color: Colors.green,
                    ),
                    const Gap(16),
                  ],

                  // Areas to improve
                  if (summary.value!['areas_to_improve'] != null &&
                      (summary.value!['areas_to_improve'] as List)
                          .isNotEmpty) ...[
                    _buildSection(
                      icon: Icons.lightbulb,
                      iconColor: Colors.orange,
                      title: '📚 Perlu Dipelajari Lebih Lanjut',
                      items: (summary.value!['areas_to_improve'] as List)
                          .map((e) => e.toString())
                          .toList(),
                      color: Colors.orange,
                    ),
                    const Gap(16),
                  ],

                  // Summary
                  _buildSummaryCard(summary.value!['summary']),
                  const Gap(16),

                  // Recommendations
                  if (summary.value!['recommendations'] != null &&
                      (summary.value!['recommendations'] as List)
                          .isNotEmpty) ...[
                    _buildRecommendationsCard(
                      (summary.value!['recommendations'] as List)
                          .map((e) => e.toString())
                          .toList(),
                    ),
                    const Gap(16),
                  ],

                  // Motivational message
                  _buildMotivationalCard(
                      summary.value!['motivational_message']),
                  const Gap(24),

                  // Actions
                  Button.filled(
                    onPressed: () {
                      // Go back to home
                      context.goNamed(RouteName.mainPasien);
                    },
                    label: 'Kembali ke Beranda',
                  ),
                  const Gap(12),
                  Button.outlined(
                    onPressed: () {
                      // Navigate to detail konten to review
                      context.pushNamed(
                        RouteName.detailKonten,
                        extra: konten.id,
                      );
                    },
                    label: 'Review Materi Kembali',
                  ),
                ],
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scoreColor.withOpacity(0.8), scoreColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const Gap(12),
          Text(
            statusText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Skor Pemahaman: ',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '$score/100',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description, color: AppColor.primaryColor),
              Gap(8),
              Text(
                'Rangkuman Pembelajaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(summary),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(List<String> recommendations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.recommend, color: Colors.purple),
              Gap(8),
              Text(
                'Rekomendasi Selanjutnya',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(12),
          ...recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 18)),
                    Expanded(child: Text(rec)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMotivationalCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100,
            Colors.purple.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.red, size: 32),
          const Gap(12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
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
