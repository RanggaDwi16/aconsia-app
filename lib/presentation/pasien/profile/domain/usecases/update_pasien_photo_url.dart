import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';

/// UseCase: Update Pasien Photo URL
class UpdatePasienPhotoUrl
    implements UseCase<String, UpdatePasienPhotoUrlParams> {
  final PasienProfileRepository repository;

  UpdatePasienPhotoUrl({required this.repository});

  @override
  Future<Either<String, String>> call(UpdatePasienPhotoUrlParams params) {
    return repository.updatePasienPhotoUrl(
      uid: params.uid,
      photoUrl: params.photoUrl,
    );
  }
}

class UpdatePasienPhotoUrlParams {
  final String uid;

  final String photoUrl;

  UpdatePasienPhotoUrlParams({
    required this.uid,
    required this.photoUrl,
  });
}
