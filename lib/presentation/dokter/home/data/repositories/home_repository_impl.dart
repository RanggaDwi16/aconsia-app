import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/data/datasources/home_remote_data_source.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, int>> getPasienCountByDokterId({
    required String dokterId,
  }) async {
    try {
      final result =
          await remoteDataSource.getPasienCountByDokterId(dokterId: dokterId);
      return result.fold(
        (failure) => Left(failure),
        (count) => Right(count),
      );
    } catch (e) {
      return Left('Gagal mengambil jumlah pasien: $e');
    }
  }

  @override
  Future<Either<String, String>> addPasienMedicInformation(
      {required String pasienId, required PasienProfileModel profile}) async {
    try {
      final result = await remoteDataSource.addPasienMedicInformation(
        pasienId: pasienId,
        profile: profile,
      );
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left('Gagal menambahkan informasi medis pasien: $e');
    }
  }

  @override
  Future<Either<String, List<PasienProfileModel>>> getPasienListByDokterId(
      {required String dokterId}) async {
    try {
      final result =
          await remoteDataSource.getPasienListByDokterId(dokterId: dokterId);
      return result.fold(
        (failure) => Left(failure),
        (pasienList) => Right(pasienList),
      );
    } catch (e) {
      return Left('Gagal mengambil daftar pasien: $e');
    }
  }

  @override
  Future<Either<String, PasienProfileModel>> getPasienProfileById(
      {required String pasienId}) async {
    try {
      final result =
          await remoteDataSource.getPasienProfileById(pasienId: pasienId);
      return result.fold(
        (failure) => Left(failure),
        (profile) => Right(profile),
      );
    } catch (e) {
      return Left('Gagal mengambil profil pasien: $e');
    }
  }
}
