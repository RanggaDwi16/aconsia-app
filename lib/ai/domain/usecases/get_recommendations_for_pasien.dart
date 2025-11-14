import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:dartz/dartz.dart';

class GetRecommendationsForPasien
    implements
        UseCase<List<AIRecommendationModel>,
            GetRecommendationsForPasienParams> {
  final AiRepository repository;

  GetRecommendationsForPasien({required this.repository});

  @override
  Future<Either<String, List<AIRecommendationModel>>> call(
      GetRecommendationsForPasienParams params) {
    return repository.getRecommendationsForPasien(
      pasienId: params.pasienId,
    );
  }
}

class GetRecommendationsForPasienParams {
  final String pasienId;

  GetRecommendationsForPasienParams({required this.pasienId});
}
