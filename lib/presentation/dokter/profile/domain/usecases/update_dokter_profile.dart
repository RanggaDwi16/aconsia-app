import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';

/// UseCase: Update Dokter Profile
class UpdateDokterProfile
    implements UseCase<String, UpdateDokterProfileParams> {
  final DokterProfileRepository repository;

  UpdateDokterProfile({required this.repository});

  @override
  Future<Either<String, String>> call(UpdateDokterProfileParams params) {
    return repository.updateDokterProfile(
      profile: params.profile,
    );
  }
}

class UpdateDokterProfileParams {
  final DokterProfileModel profile;

  UpdateDokterProfileParams({required this.profile});
}
