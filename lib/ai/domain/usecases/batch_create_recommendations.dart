import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:dartz/dartz.dart';

class BatchCreateRecommendations
    implements UseCase<String, BatchCreateRecommendationsParams> {
  final AiRepository repository;

  BatchCreateRecommendations({required this.repository});

  @override
  Future<Either<String, String>> call(BatchCreateRecommendationsParams params) {
    return repository.batchCreateRecommendations(
      recommendations: params.recommendations,
    );
  }
}

class BatchCreateRecommendationsParams {
  final List<AIRecommendationModel> recommendations;

  BatchCreateRecommendationsParams({required this.recommendations});
}
