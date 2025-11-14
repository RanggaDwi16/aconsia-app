import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class AiRemoteDataSource {
  Future<Either<String, AIRecommendationModel>> createRecommendation({
    required AIRecommendationModel recommendation,
  });
  Future<Either<String, List<AIRecommendationModel>>>
      getRecommendationsForPasien({required String pasienId, int limit = 10});
  Future<Either<String, List<AIRecommendationModel>>>
      getUnviewedRecommendations({
    required String pasienId,
  });

  Future<Either<String, String>> markAsViewed({
    required String recommendationId,
  });

  Future<Either<String, String>> batchCreateRecommendations({
    required List<AIRecommendationModel> recommendations,
  });

  Future<Either<String, String>> deleteRecommendation({
    required String recommendationId,
  });

  Future<Either<String, String>> deleteAllRecommendations({
    required String pasienId,
  });

  Future<Either<String, bool>> recommendationExists({
    required String pasienId,
    required String kontenId,
  });

  Future<Either<String, int>> getRecommendationCount({
    required String pasienId,
  });

  Future<Either<String, List<AIRecommendationModel>>>
      getRecommendationsByKeywords({
    required String pasienId,
    required List<String> keywords,
  });

  Future<Either<String, String>> clearOldRecommendations({
    required int daysOld,
  });
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final FirebaseFirestore firestore;

  AiRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, String>> batchCreateRecommendations(
      {required List<AIRecommendationModel> recommendations}) async {
    try {
      final batch = firestore.batch();

      for (var rec in recommendations) {
        final ref = firestore.collection('ai_recommendations').doc();
        final recWithId = rec.copyWith(id: ref.id);
        batch.set(ref, AIRecommendationModel.toFirestore(recWithId));
      }

      await batch.commit();
      return const Right('Sukses membuat rekomendasi secara batch.');
    } catch (e) {
      return Left('Gagal batch create recommendations: $e');
    }
  }

  @override
  Future<Either<String, String>> clearOldRecommendations(
      {required int daysOld}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      final oldRecs = await firestore
          .collection('ai_recommendations')
          .where('createdAt', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      final batch = firestore.batch();
      for (var doc in oldRecs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return const Right('Sukses menghapus rekomendasi lama.');
    } catch (e) {
      return Left('Gagal menghapus rekomendasi lama: $e');
    }
  }

  @override
  Future<Either<String, AIRecommendationModel>> createRecommendation(
      {required AIRecommendationModel recommendation}) async {
    try {
      final ref = firestore.collection('ai_recommendations').doc();
      final recWithId = recommendation.copyWith(id: ref.id);

      await ref.set(AIRecommendationModel.toFirestore(recWithId));
      return Right(recWithId);
    } catch (e) {
      return Left('Gagal membuat rekomendasi: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteAllRecommendations(
      {required String pasienId}) async {
    try {
      final recs = await firestore
          .collection('ai_recommendations')
          .where('pasienId', isEqualTo: pasienId)
          .get();

      final batch = firestore.batch();
      for (var doc in recs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return const Right('Sukses menghapus semua rekomendasi.');
    } catch (e) {
      return Left('Gagal menghapus semua rekomendasi: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteRecommendation(
      {required String recommendationId}) async {
    try {
      await firestore
          .collection('ai_recommendations')
          .doc(recommendationId)
          .delete();
      return const Right('Sukses menghapus rekomendasi.');
    } catch (e) {
      return Left('Gagal hapus rekomendasi: $e');
    }
  }

  @override
  Future<Either<String, int>> getRecommendationCount(
      {required String pasienId}) async {
    try {
      final snapshot = await firestore
          .collection('ai_recommendations')
          .where('pasienId', isEqualTo: pasienId)
          .count()
          .get();

      return Right(snapshot.count ?? 0);
    } catch (e) {
      return Left('Gagal mendapatkan jumlah rekomendasi: $e');
    }
  }

  @override
  Future<Either<String, List<AIRecommendationModel>>>
      getRecommendationsByKeywords(
          {required String pasienId, required List<String> keywords}) async {
    try {
      final limitedKeywords = keywords.take(10).toList();

      final snapshot = await firestore
          .collection('ai_recommendations')
          .where('pasienId', isEqualTo: pasienId)
          .where('matchedKeywords', arrayContainsAny: limitedKeywords)
          .orderBy('relevanceScore', descending: true)
          .get();

      final recommendations = snapshot.docs
          .map((doc) => AIRecommendationModel.fromFirestore(doc))
          .toList();

      return Right(recommendations);
    } catch (e) {
      return Left('Gagal mendapatkan rekomendasi berdasarkan kata kunci: $e');
    }
  }

  @override
  Future<Either<String, List<AIRecommendationModel>>>
      getRecommendationsForPasien(
          {required String pasienId, int limit = 10}) async {
    try {
      final snapshot = await firestore
          .collection('ai_recommendations')
          .where('pasienId', isEqualTo: pasienId)
          .orderBy('relevanceScore', descending: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final recommendations = snapshot.docs
          .map((doc) => AIRecommendationModel.fromFirestore(doc))
          .toList();

      return Right(recommendations);
    } catch (e) {
      return Left('Gagal mendapatkan rekomendasi untuk pasien: $e');
    }
  }

  @override
  Future<Either<String, List<AIRecommendationModel>>>
      getUnviewedRecommendations({required String pasienId}) async {
    try {
      final snapshot = await firestore
          .collection('ai_recommendations')
          .where('pasienId', isEqualTo: pasienId)
          .where('isViewed', isEqualTo: false)
          .orderBy('relevanceScore', descending: true)
          .get();

      final recommendations = snapshot.docs
          .map((doc) => AIRecommendationModel.fromFirestore(doc))
          .toList();

      return Right(recommendations);
    } catch (e) {
      return Left('Gagal mendapatkan rekomendasi yang belum dilihat: $e');
    }
  }

  @override
  Future<Either<String, String>> markAsViewed(
      {required String recommendationId}) async {
    try {
      await firestore
          .collection('ai_recommendations')
          .doc(recommendationId)
          .update({
        'isViewed': true,
        'viewedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Sukses menandai rekomendasi sebagai telah dilihat.');
    } catch (e) {
      return Left('Gagal menandai rekomendasi sebagai telah dilihat: $e');
    }
  }

  @override
  Future<Either<String, bool>> recommendationExists(
      {required String pasienId, required String kontenId}) async {
    try {
      final snapshot = await firestore
          .collection('ai_recommendations')
          .where('pasienId', isEqualTo: pasienId)
          .where('kontenId', isEqualTo: kontenId)
          .limit(1)
          .get();

      return Right(snapshot.docs.isNotEmpty);
    } catch (e) {
      return Left('Gagal memeriksa keberadaan rekomendasi: $e');
    }
  }
}
