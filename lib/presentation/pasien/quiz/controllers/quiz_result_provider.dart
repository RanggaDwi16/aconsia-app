import 'package:aconsia_app/core/main/data/models/quiz_result_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      await ref.set(QuizResultModel.toFirestore(resultWithId));

      state = AsyncData(resultWithId.id);

      // Invalidate the fetch provider to refresh the UI
      this.ref.invalidate(fetchQuizResultByKontenProvider(
            pasienId: result.pasienId,
            kontenId: result.kontenId,
          ));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
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
