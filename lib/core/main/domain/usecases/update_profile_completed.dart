import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateProfileCompleted
    implements UseCase<String, UpdateProfileCompletedParams> {
  final AuthenticationRepository repository;

  UpdateProfileCompleted({required this.repository});

  @override
  Future<Either<String, String>> call(UpdateProfileCompletedParams params) {
    return repository.updateProfileCompleted(
      uid: params.uid,
      isCompleted: params.isCompleted,
    );
  }
}

class UpdateProfileCompletedParams {
  final String uid;
  final bool isCompleted;

  UpdateProfileCompletedParams({
    required this.uid,
    required this.isCompleted,
  });
}
