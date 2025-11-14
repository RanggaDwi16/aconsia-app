import 'package:aconsia_app/core/main/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<String, String>> registerDokter({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<String, String>> registerPasien({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<String, String>> logout();

  Future<Either<String, String>> forgotPassword({
    required String email,
  });

  Future<Either<String, UserModel>> getCurrentUserData();

  Future<Either<String, String>> updateProfileCompleted({
    required String uid,
    required bool isCompleted,
  });

  Future<Either<String, String>> deleteAccount({
    required String uid,
  });
}
