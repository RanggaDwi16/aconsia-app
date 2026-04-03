import 'package:aconsia_app/core/main/data/models/quiz_result_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienLearningSummaryParams {
  final String pasienId;
  final String dokterId;

  const PasienLearningSummaryParams({
    required this.pasienId,
    required this.dokterId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasienLearningSummaryParams &&
        other.pasienId == pasienId &&
        other.dokterId == dokterId;
  }

  @override
  int get hashCode => Object.hash(pasienId, dokterId);
}

class PasienLearningSummary {
  final int totalKonten;
  final int completedKonten;
  final int unreadKonten;
  final double completionRate;
  final int totalQuiz;
  final double averageQuizScore;
  final QuizResultModel? latestQuiz;

  const PasienLearningSummary({
    required this.totalKonten,
    required this.completedKonten,
    required this.unreadKonten,
    required this.completionRate,
    required this.totalQuiz,
    required this.averageQuizScore,
    required this.latestQuiz,
  });

  const PasienLearningSummary.empty()
      : totalKonten = 0,
        completedKonten = 0,
        unreadKonten = 0,
        completionRate = 0,
        totalQuiz = 0,
        averageQuizScore = 0,
        latestQuiz = null;
}

final pasienLearningSummaryProvider = FutureProvider.family<
    PasienLearningSummary, PasienLearningSummaryParams>((ref, params) async {
  if (params.pasienId.isEmpty || params.dokterId.isEmpty) {
    return const PasienLearningSummary.empty();
  }

  final allKonten = await ref.read(
    fetchKontenByDokterIdProvider(dokterId: params.dokterId).future,
  );
  if (allKonten == null || allKonten.isEmpty) {
    return const PasienLearningSummary.empty();
  }

  final allQuiz = await ref.read(
    fetchAllQuizResultsProvider(pasienId: params.pasienId).future,
  );

  final kontenIds = allKonten
      .map((e) => e.id ?? '')
      .where((id) => id.isNotEmpty)
      .toSet();
  final quizForDoctorKonten =
      allQuiz.where((q) => kontenIds.contains(q.kontenId)).toList();

  final completedKontenIds = quizForDoctorKonten.map((e) => e.kontenId).toSet();
  final completedKonten = completedKontenIds.length;
  final totalKonten = kontenIds.length;
  final unreadKonten = (totalKonten - completedKonten).clamp(0, totalKonten);
  final completionRate =
      totalKonten == 0 ? 0.0 : (completedKonten / totalKonten) * 100.0;

  final totalQuiz = quizForDoctorKonten.length;
  final totalScore = quizForDoctorKonten.fold<double>(
    0.0,
    (acc, result) => acc + result.overallScore.toDouble(),
  );
  final averageQuizScore = totalQuiz == 0 ? 0.0 : totalScore / totalQuiz;

  quizForDoctorKonten.sort((a, b) => b.completedAt.compareTo(a.completedAt));
  final latestQuiz = quizForDoctorKonten.isEmpty ? null : quizForDoctorKonten.first;

  return PasienLearningSummary(
    totalKonten: totalKonten,
    completedKonten: completedKonten,
    unreadKonten: unreadKonten,
    completionRate: completionRate,
    totalQuiz: totalQuiz,
    averageQuizScore: averageQuizScore,
    latestQuiz: latestQuiz,
  );
});
