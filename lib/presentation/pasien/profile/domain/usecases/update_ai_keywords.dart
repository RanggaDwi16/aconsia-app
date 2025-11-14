import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';

/// UseCase: Update AI Keywords for Recommendations
class UpdateAiKeywords implements UseCase<String, UpdateAiKeywordsParams> {
  final PasienProfileRepository repository;

  UpdateAiKeywords({required this.repository});

  @override
  Future<Either<String, String>> call(UpdateAiKeywordsParams params) {
    return repository.updateAIKeywords(
      pasienId: params.pasienId,
      keywords: params.aiKeywords,
    );
  }
}

class UpdateAiKeywordsParams {
  final String pasienId;

  final List<String> aiKeywords;

  UpdateAiKeywordsParams({
    required this.pasienId,
    required this.aiKeywords,
  });
}
