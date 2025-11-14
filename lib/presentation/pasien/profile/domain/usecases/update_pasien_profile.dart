import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';

/// UseCase: Update Pasien Profile
class UpdatePasienProfile
    implements UseCase<String, UpdatePasienProfileParams> {
  final PasienProfileRepository repository;

  UpdatePasienProfile({required this.repository});

  @override
  Future<Either<String, String>> call(
      UpdatePasienProfileParams params) {
    return repository.updatePasienProfile(model: params.updatedProfile);
  }
}

class UpdatePasienProfileParams {
  final PasienProfileModel updatedProfile;

  UpdatePasienProfileParams({
    required this.updatedProfile,
  });
}
