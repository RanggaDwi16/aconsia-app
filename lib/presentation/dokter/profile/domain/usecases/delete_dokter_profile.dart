import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';

/// UseCase: Delete Dokter Profile
class DeleteDokterProfile implements UseCase<String, DeleteDokterProfileParams> {
  final DokterProfileRepository repository;

  DeleteDokterProfile({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteDokterProfileParams params) {
    return repository.deleteDokterProfile(uid: params.uid);
  }
}

class DeleteDokterProfileParams {
  final String uid;

  DeleteDokterProfileParams({required this.uid});
}
