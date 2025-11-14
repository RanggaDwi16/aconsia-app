import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterDokter implements UseCase<String, RegisterDokterParams> {
  final AuthenticationRepository repository;

  RegisterDokter({required this.repository});

  @override
  Future<Either<String, String>> call(RegisterDokterParams params) {
    return repository.registerDokter(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

class RegisterDokterParams {
  final String email;
  final String password;
  final String name;

  RegisterDokterParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
