import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class ForgotPassword implements UseCase<String, ForgotPasswordParams> {
  final AuthenticationRepository repository;

  ForgotPassword({required this.repository});

  @override
  Future<Either<String, String>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(
      email: params.email,
    );
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({
    required this.email,
  });
}
