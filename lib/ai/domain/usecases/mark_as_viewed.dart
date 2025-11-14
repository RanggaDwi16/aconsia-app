import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class MarkAsViewed implements UseCase<String, MarkAsViewedParams> {
  final AiRepository repository;

  MarkAsViewed({required this.repository});

  @override
  Future<Either<String, String>> call(MarkAsViewedParams params) {
    return repository.markAsViewed(
      recommendationId: params.recommendationId,
    );
  }
}

class MarkAsViewedParams {
  final String recommendationId;

  MarkAsViewedParams({required this.recommendationId});
}