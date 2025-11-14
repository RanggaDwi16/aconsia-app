import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';
import 'package:aconsia_app/presentation/pasien/profile/data/datasources/pasien_profile_remote_data_source.dart';

/// Implementation of PasienProfileRepository
class PasienProfileRepositoryImpl implements PasienProfileRepository {
  final PasienProfileRemoteDataSource remoteDataSource;

  PasienProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, String>> addKontenToFavorites(
      {required String pasienId, required String kontenId}) async {
    try {
      final result = await remoteDataSource.addKontenToFavorites(
        pasienId: pasienId,
        kontenId: kontenId,
      );
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal menambahkan konten ke favorit: $e');
    }
  }

  @override
  Future<Either<String, bool>> checkProfileExists() async {
    try {
      final result = await remoteDataSource.checkProfileExists();
      return result.fold(
        (failure) => Left(failure),
        (exists) => Right(exists),
      );
    } catch (e) {
      return Left('Gagal memeriksa keberadaan profil: $e');
    }
  }

  @override
  Future<Either<String, String>> deletePasienProfile(String uid) async {
    try {
      final result = await remoteDataSource.deletePasienProfile(uid);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal menghapus profil: $e');
    }
  }

  @override
  Future<Either<String, PasienProfileModel>> getPasienProfile(
      {required String uid}) async {
    try {
      final result = await remoteDataSource.getPasienProfile(uid: uid);
      return result.fold(
        (failure) => Left(failure),
        (profile) => Right(profile),
      );
    } catch (e) {
      return Left('Gagal mendapatkan profil: $e');
    }
  }

  @override
  Future<Either<String, String>> removeKontenFromFavorites(
      {required String pasienId, required String kontenId}) async {
    try {
      final result = await remoteDataSource.removeKontenFromFavorites(
        pasienId: pasienId,
        kontenId: kontenId,
      );
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal menghapus konten dari favorit: $e');
    }
  }

  @override
  Stream<PasienProfileModel?> streamPasienProfile(
      {required String uid}) async* {
    try {
      yield* remoteDataSource.streamPasienProfile(uid: uid);
    } catch (e) {
      // Handle error if necessary
    }
  }

  @override
  Future<Either<String, String>> updateAIKeywords(
      {required String pasienId, required List<String> keywords}) async {
    try {
      final result = await remoteDataSource.updateAIKeywords(
        pasienId: pasienId,
        keywords: keywords,
      );
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal memperbarui kata kunci AI: $e');
    }
  }

  @override
  Future<Either<String, String>> updatePasienPhotoUrl(
      {required String uid, required String photoUrl}) async {
    try {
      final result = await remoteDataSource.updatePasienPhotoUrl(
        uid: uid,
        photoUrl: photoUrl,
      );
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal memperbarui URL foto pasien: $e');
    }
  }

  @override
  Future<Either<String, String>> updatePasienProfile(
      {required PasienProfileModel model}) async {
    try {
      final result = await remoteDataSource.updatePasienProfile(model: model);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal update profil: $e');
    }
  }

  @override
  Future<Either<String, List<DokterProfileModel>>> getAllDokterOptions() async {
    try {
      final result = await remoteDataSource.getAllDokterOptions();
      return result.fold(
        (failure) => Left(failure),
        (dokterList) => Right(dokterList),
      );
    } catch (e) {
      return Left('Gagal mendapatkan daftar dokter: $e');
    }
  }
}
