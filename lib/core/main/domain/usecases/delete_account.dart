import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class DeleteAccount implements UseCase<String, DeleteAccountParams> {
  final AuthenticationRepository repository;

  DeleteAccount({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteAccountParams params) {
    return repository.deleteAccount(
      uid: params.uid,
    );
  }
}

class DeleteAccountParams {
  final String uid;

  DeleteAccountParams({
    required this.uid,
  });
}
