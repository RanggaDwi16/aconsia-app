import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:dartz/dartz.dart';

class GetRecommendationsByKeywords
    implements
        UseCase<List<AIRecommendationModel>,
            GetRecommendationsByKeywordsParams> {
  final AiRepository repository;

  GetRecommendationsByKeywords({required this.repository});

  @override
  Future<Either<String, List<AIRecommendationModel>>> call(
      GetRecommendationsByKeywordsParams params) {
    return repository.getRecommendationsByKeywords(
      keywords: params.keywords,
      pasienId: params.pasienId,
    );
  }
}

class GetRecommendationsByKeywordsParams {
  final List<String> keywords;
  final String pasienId;

  GetRecommendationsByKeywordsParams({
    required this.keywords,
    required this.pasienId,
  });
}
