import 'package:aconsia_app/core/main/data/models/quiz_result_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_result_provider.g.dart';

/// Save quiz result to Firestore
@Riverpod(keepAlive: true)
class SaveQuizResult extends _$SaveQuizResult {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> save(QuizResultModel result) async {
    state = const AsyncLoading();

    try {
      final firestore = FirebaseFirestore.instance;
      final ref = firestore.collection('quiz_results').doc();
      final resultWithId = result.copyWith(id: ref.id);
      final dokterId = await _resolveDokterId(
        firestore: firestore,
        pasienId: result.pasienId,
      );
      if (dokterId.isEmpty) {
        throw Exception('dokter_id_not_found_for_quiz_result');
      }

      final payload = QuizResultModel.toFirestore(resultWithId);
      final score = payload['overallScore'];
      if (score is! num) {
        throw Exception('invalid_overall_score');
      }
      if (payload['completedAt'] is! Timestamp) {
        payload['completedAt'] = Timestamp.fromDate(result.completedAt);
      }
      payload['dokterId'] = dokterId;

      await ref.set(payload);

      state = AsyncData(resultWithId.id);
      debugPrint(
        '[QUIZ_SAVE] success | quizId=${resultWithId.id} | pasienId=${result.pasienId} | dokterId=$dokterId | score=${result.overallScore}',
      );

      // Invalidate the fetch provider to refresh the UI
      this.ref.invalidate(fetchQuizResultByKontenProvider(
            pasienId: result.pasienId,
            kontenId: result.kontenId,
          ));
    } catch (e) {
      debugPrint('[QUIZ_SAVE] failed | pasienId=${result.pasienId} | reason=$e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<String> _resolveDokterId({
    required FirebaseFirestore firestore,
    required String pasienId,
  }) async {
    final safePasienId = pasienId.trim();
    if (safePasienId.isEmpty) return '';

    String readDokterId(Map<String, dynamic>? data) {
      if (data == null) return '';
      final primary = (data['dokterId'] ?? '').toString().trim();
      if (primary.isNotEmpty) return primary;
      return (data['assignedDokterId'] ?? '').toString().trim();
    }

    final directDoc =
        await firestore.collection('pasien_profiles').doc(safePasienId).get();
    final fromDirect = readDokterId(directDoc.data());
    if (fromDirect.isNotEmpty) return fromDirect;

    final sameUidProfiles = await firestore
        .collection('pasien_profiles')
        .where('uid', isEqualTo: safePasienId)
        .limit(20)
        .get();
    for (final doc in sameUidProfiles.docs) {
      final dokterId = readDokterId(doc.data());
      if (dokterId.isNotEmpty) return dokterId;
    }

    return '';
  }
}

/// Fetch quiz result by konten + pasien
@riverpod
class FetchQuizResultByKonten extends _$FetchQuizResultByKonten {
  @override
  FutureOr<QuizResultModel?> build({
    required String pasienId,
    required String kontenId,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection('quiz_results')
        .where('pasienId', isEqualTo: pasienId)
        .where('kontenId', isEqualTo: kontenId)
        .orderBy('completedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return QuizResultModel.fromFirestore(snapshot.docs.first);
  }
}

/// Fetch all quiz results for pasien
@riverpod
class FetchAllQuizResults extends _$FetchAllQuizResults {
  @override
  FutureOr<List<QuizResultModel>> build({required String pasienId}) async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection('quiz_results')
        .where('pasienId', isEqualTo: pasienId)
        .orderBy('completedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => QuizResultModel.fromFirestore(doc))
        .toList();
  }
}
