import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class DeleteAllRecommendations
    implements UseCase<String, DeleteAllRecommendationsParams> {
  final AiRepository repository;

  DeleteAllRecommendations({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteAllRecommendationsParams params) {
    return repository.deleteAllRecommendations(
      pasienId: params.pasienId,
    );
  }
}

class DeleteAllRecommendationsParams {
  final String pasienId;

  DeleteAllRecommendationsParams({required this.pasienId});
}
