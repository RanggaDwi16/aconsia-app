import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class Logout implements UseCase<String, void> {
  final AuthenticationRepository repository;

  Logout({required this.repository});

  @override
  Future<Either<String, String>> call(void params) {
    return repository.logout();
  }
}
