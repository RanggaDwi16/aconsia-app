import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class DeleteRecommendation implements UseCase<String, DeleteRecommendationParams> {
  final AiRepository repository;

  DeleteRecommendation({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteRecommendationParams params) {
    return repository.deleteRecommendation(
      recommendationId: params.recommendationId,
    );
  }
}

class DeleteRecommendationParams {
  final String recommendationId;

  DeleteRecommendationParams({required this.recommendationId});
}