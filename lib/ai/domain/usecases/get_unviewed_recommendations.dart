import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:dartz/dartz.dart';

class GetUnviewedRecommendations implements UseCase<List<AIRecommendationModel>, GetUnviewedRecommendationsParams> {
  final AiRepository repository;

  GetUnviewedRecommendations({required this.repository});

  @override
  Future<Either<String, List<AIRecommendationModel>>> call(
      GetUnviewedRecommendationsParams params) {
    return repository.getUnviewedRecommendations(
      pasienId: params.pasienId,
    );
  }
}

class GetUnviewedRecommendationsParams {
  final String pasienId;

  GetUnviewedRecommendationsParams({required this.pasienId});
}