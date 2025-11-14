import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class Login implements UseCase<UserModel, LoginParams> {
  final AuthenticationRepository repository;

  Login({required this.repository});

  @override
  Future<Either<String, UserModel>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
