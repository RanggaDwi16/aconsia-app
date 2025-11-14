import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';

/// UseCase: Get Pasien Profile
class GetPasienProfile
    implements UseCase<PasienProfileModel, GetPasienProfileParams> {
  final PasienProfileRepository repository;

  GetPasienProfile({required this.repository});

  @override
  Future<Either<String, PasienProfileModel>> call(
      GetPasienProfileParams params) {
    return repository.getPasienProfile(uid: params.uid);
  }
}

class GetPasienProfileParams {
  final String uid;

  GetPasienProfileParams({required this.uid});
}
