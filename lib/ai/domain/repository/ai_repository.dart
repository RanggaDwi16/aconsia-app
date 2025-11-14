import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:dartz/dartz.dart';

abstract class AiRepository {
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
