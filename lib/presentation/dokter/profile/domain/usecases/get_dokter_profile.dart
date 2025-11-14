import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';

/// UseCase: Get Dokter Profile
class GetDokterProfile
    implements UseCase<DokterProfileModel, GetDokterProfileParams> {
  final DokterProfileRepository repository;

  GetDokterProfile({required this.repository});

  @override
  Future<Either<String, DokterProfileModel>> call(
      GetDokterProfileParams params) {
    return repository.getDokterProfile(uid: params.uid);
  }
}

class GetDokterProfileParams {
  final String uid;

  GetDokterProfileParams({required this.uid});
}
