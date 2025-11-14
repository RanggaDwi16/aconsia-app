import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class GetRecommendationCount
    implements UseCase<int, GetRecommendationCountParams> {
  final AiRepository repository;

  GetRecommendationCount({required this.repository});

  @override
  Future<Either<String, int>> call(GetRecommendationCountParams params) {
    return repository.getRecommendationCount(
      pasienId: params.pasienId,
    );
  }
}

class GetRecommendationCountParams {
  final String pasienId;

  GetRecommendationCountParams({required this.pasienId});
}
