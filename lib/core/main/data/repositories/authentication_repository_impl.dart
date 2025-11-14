import 'package:aconsia_app/core/main/data/datasources/authentication_remote_data_source.dart';
import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/main/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, UserModel>> login(
      {required String email, required String password}) async {
    try {
      final result =
          await remoteDataSource.login(email: email, password: password);
      return result;
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> logout() async {
    try {
      final result = await remoteDataSource.logout();
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> registerDokter(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final result = await remoteDataSource.registerDokter(
          email: email, password: password, name: name);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> registerPasien(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final result = await remoteDataSource.registerPasien(
          email: email, password: password, name: name);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> forgotPassword({required String email}) async {
    try {
      final result = await remoteDataSource.forgotPassword(email: email);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserModel>> getCurrentUserData() async {
    try {
      final result = await remoteDataSource.getCurrentUserData();
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> updateProfileCompleted(
      {required String uid, required bool isCompleted}) async {
    try {
      final result = await remoteDataSource.updateProfileCompleted(
          uid: uid, isCompleted: isCompleted);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteAccount({required String uid}) async {
    try {
      final result = await remoteDataSource.deleteAccount(uid: uid);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
