import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUser implements UseCase<UserModel, GetCurrentUserParams> {
  final AuthenticationRepository repository;

  GetCurrentUser({required this.repository});

  @override
  Future<Either<String, UserModel>> call(GetCurrentUserParams params) {
    return repository.getCurrentUserData();
  }
}

class GetCurrentUserParams {
  GetCurrentUserParams();
}
