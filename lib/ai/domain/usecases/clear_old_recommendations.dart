import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class ClearOldRecommendations implements UseCase<String, ClearOldRecommendationsParams> {
  final AiRepository repository;

  ClearOldRecommendations({required this.repository});

  @override
  Future<Either<String, String>> call(ClearOldRecommendationsParams params) {
    return repository.clearOldRecommendations(daysOld: params.daysOld);
  }
}

class ClearOldRecommendationsParams {
  final int daysOld;

  ClearOldRecommendationsParams({required this.daysOld});
}