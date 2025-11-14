import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterPasien implements UseCase<String, RegisterPasienParams> {
  final AuthenticationRepository repository;

  RegisterPasien({required this.repository});

  @override
  Future<Either<String, String>> call(RegisterPasienParams params) {
    return repository.registerPasien(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

class RegisterPasienParams {
  final String email;
  final String password;
  final String name;

  RegisterPasienParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
