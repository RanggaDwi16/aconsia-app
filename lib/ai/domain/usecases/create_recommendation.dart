import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:dartz/dartz.dart';

class CreateRecommendation
    implements UseCase<AIRecommendationModel, CreateRecommendationParams> {
  final AiRepository repository;

  CreateRecommendation({required this.repository});

  @override
  Future<Either<String, AIRecommendationModel>> call(
      CreateRecommendationParams params) {
    return repository.createRecommendation(
      recommendation: params.recommendation,
    );
  }
}

class CreateRecommendationParams {
  final AIRecommendationModel recommendation;

  CreateRecommendationParams({required this.recommendation});
}
