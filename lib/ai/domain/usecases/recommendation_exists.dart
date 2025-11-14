import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class RecommendationExists
    implements UseCase<bool, RecommendationExistsParams> {
  final AiRepository repository;

  RecommendationExists({required this.repository});

  @override
  Future<Either<String, bool>> call(RecommendationExistsParams params) {
    return repository.recommendationExists(
      pasienId: params.pasienId,
      kontenId: params.kontenId,
    );
  }
}

class RecommendationExistsParams {
  final String pasienId;
  final String kontenId;

  RecommendationExistsParams({
    required this.pasienId,
    required this.kontenId,
  });
}
