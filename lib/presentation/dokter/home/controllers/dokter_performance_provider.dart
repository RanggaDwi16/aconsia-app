import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DokterPerformanceSummary {
  final int totalQuizResults;
  final double avgScore;
  final int excellentCount;
  final int needsAttentionCount;

  const DokterPerformanceSummary({
    required this.totalQuizResults,
    required this.avgScore,
    required this.excellentCount,
    required this.needsAttentionCount,
  });
}

final dokterPerformanceProvider =
    FutureProvider.family<DokterPerformanceSummary, String>((ref, dokterId) async {
  if (dokterId.isEmpty) {
    return const DokterPerformanceSummary(
      totalQuizResults: 0,
      avgScore: 0,
      excellentCount: 0,
      needsAttentionCount: 0,
    );
  }

  final firestore = FirebaseFirestore.instance;

  final pasienSnapshot = await firestore
      .collection('pasien_profiles')
      .where('dokterId', isEqualTo: dokterId)
      .get();

  final pasienIds = pasienSnapshot.docs.map((e) => e.id).toList();
  if (pasienIds.isEmpty) {
    return const DokterPerformanceSummary(
      totalQuizResults: 0,
      avgScore: 0,
      excellentCount: 0,
      needsAttentionCount: 0,
    );
  }

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> quizDocs = [];
  for (var i = 0; i < pasienIds.length; i += 10) {
    final chunk = pasienIds.sublist(
      i,
      i + 10 > pasienIds.length ? pasienIds.length : i + 10,
    );

    final snap = await firestore
        .collection('quiz_results')
        .where('pasienId', whereIn: chunk)
        .get();
    quizDocs.addAll(snap.docs);
  }

  if (quizDocs.isEmpty) {
    return const DokterPerformanceSummary(
      totalQuizResults: 0,
      avgScore: 0,
      excellentCount: 0,
      needsAttentionCount: 0,
    );
  }

  var totalScore = 0.0;
  var excellentCount = 0;
  var needsAttentionCount = 0;

  for (final doc in quizDocs) {
    final data = doc.data();
    final rawScore = data['overallScore'];
    final score = rawScore is num
        ? rawScore.toDouble()
        : double.tryParse(rawScore?.toString() ?? '') ?? 0.0;
    totalScore += score;

    if (score >= 80) {
      excellentCount += 1;
    }
    if (score < 70) {
      needsAttentionCount += 1;
    }
  }

  final avgScore = totalScore / quizDocs.length;

  return DokterPerformanceSummary(
    totalQuizResults: quizDocs.length,
    avgScore: avgScore,
    excellentCount: excellentCount,
    needsAttentionCount: needsAttentionCount,
  );
});
