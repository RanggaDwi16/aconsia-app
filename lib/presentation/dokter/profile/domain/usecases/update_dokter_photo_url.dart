import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';

/// UseCase: Update Dokter Photo URL
class UpdateDokterPhotoUrl
    implements UseCase<String, UpdateDokterPhotoUrlParams> {
  final DokterProfileRepository repository;

  UpdateDokterPhotoUrl({required this.repository});

  @override
  Future<Either<String, String>> call(UpdateDokterPhotoUrlParams params) {
    return repository.updateDokterPhotoUrl(
      uid: params.uid,
      photoUrl: params.photoUrl,
    );
  }
}

class UpdateDokterPhotoUrlParams {
  final String uid;
  final String photoUrl;

  UpdateDokterPhotoUrlParams({
    required this.uid,
    required this.photoUrl,
  });
}
