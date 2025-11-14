import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';

/// UseCase: Delete Pasien Profile
class DeletePasienProfile
    implements UseCase<String, DeletePasienProfileParams> {
  final PasienProfileRepository repository;

  DeletePasienProfile({required this.repository});

  @override
  Future<Either<String, String>> call(DeletePasienProfileParams params) {
    return repository.deletePasienProfile(params.uid);
  }
}

class DeletePasienProfileParams {
  final String uid;

  DeletePasienProfileParams({required this.uid});
}
