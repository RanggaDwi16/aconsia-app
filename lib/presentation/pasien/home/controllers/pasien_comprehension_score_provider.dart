import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienComprehensionState {
  final int score;
  final DateTime? latestCompletedAt;
  final String source;

  const PasienComprehensionState({
    required this.score,
    required this.latestCompletedAt,
    required this.source,
  });

  const PasienComprehensionState.empty()
      : score = 0,
        latestCompletedAt = null,
        source = 'none';
}

final pasienComprehensionScoreProvider = FutureProvider.family<
    PasienComprehensionState, String>((ref, pasienId) async {
  if (pasienId.trim().isEmpty) {
    return const PasienComprehensionState.empty();
  }

  final allResults =
      await ref.read(fetchAllQuizResultsProvider(pasienId: pasienId).future);
  if (allResults.isEmpty) {
    return const PasienComprehensionState.empty();
  }

  allResults.sort((a, b) => b.completedAt.compareTo(a.completedAt));
  final latest = allResults.first;
  String source = 'unknown';

  if (latest.questionResults.isNotEmpty) {
    final metaRaw = latest.questionResults.last['_meta'];
    if (metaRaw is Map<String, dynamic>) {
      final src = metaRaw['source'];
      if (src is String && src.trim().isNotEmpty) {
        source = src.trim();
      }
    } else if (metaRaw is Map) {
      final src = metaRaw['source'];
      if (src is String && src.trim().isNotEmpty) {
        source = src.trim();
      }
    }
  }

  return PasienComprehensionState(
    score: latest.overallScore.clamp(0, 100),
    latestCompletedAt: latest.completedAt,
    source: source,
  );
});
