import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';
import 'package:aconsia_app/presentation/dokter/profile/data/datasources/dokter_profile_remote_data_source.dart';

class DokterProfileRepositoryImpl implements DokterProfileRepository {
  final DokterProfileRemoteDataSource remoteDataSource;

  DokterProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, bool>> checkProfileExists({required String uid}) async {
    try {
      final result = await remoteDataSource.checkProfileExists(uid: uid);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteDokterProfile(
      {required String uid}) async {
    try {
      final result = await remoteDataSource.deleteDokterProfile(uid: uid);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DokterProfileModel>> getDokterProfile(
      {required String uid}) async {
    try {
      final result = await remoteDataSource.getDokterProfile(uid: uid);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<DokterProfileModel?> streamDokterProfile({required String uid}) {
    try {
      final stream = remoteDataSource.streamDokterProfile(uid: uid);
      return stream;
    } catch (e) {
      throw Exception('Gagal melakukan streaming profil dokter: $e');
    }
  }

  @override
  Future<Either<String, String>> updateDokterPhotoUrl(
      {required String uid, required String photoUrl}) async {
    try {
      final result = await remoteDataSource.updateDokterPhotoUrl(
          uid: uid, photoUrl: photoUrl);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> updateDokterProfile(
      {required DokterProfileModel profile}) async {
    try {
      final result =
          await remoteDataSource.updateDokterProfile(profile: profile);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
