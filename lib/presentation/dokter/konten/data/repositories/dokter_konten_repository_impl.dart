import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/data/datasources/dokter_konten_remote_datasource.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class DokterKontenRepositoryImpl implements DokterKontenRepository {
  final DokterKontenRemoteDataSource remoteDataSource;

  DokterKontenRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, String>> createKonten(
      {required KontenModel konten,
      required List<KontenSectionModel> sections}) async {
    try {
      final result = await remoteDataSource.createKonten(
          konten: konten, sections: sections);
      return result.fold(
        (failure) => Left(failure),
        (kontenId) => Right(kontenId),
      );
    } catch (e) {
      return Left('Gagal membuat konten: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteKonten(
      {required String kontenId}) async {
    try {
      final result = await remoteDataSource.deleteKonten(kontenId: kontenId);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left('Gagal menghapus konten: $e');
    }
  }

  @override
  Future<Either<String, List<KontenModel>>> getKontenByDokterId(
      {required String dokterId}) async {
    try {
      final result =
          await remoteDataSource.getKontenByDokterId(dokterId: dokterId);
      return result.fold(
        (failure) => Left(failure),
        (kontenList) => Right(kontenList),
      );
    } catch (e) {
      return Left('Gagal mengambil konten: $e');
    }
  }

  @override
  Future<Either<String, KontenModel>> getKontenById(
      {required String kontenId}) async {
    try {
      final result = await remoteDataSource.getKontenById(kontenId: kontenId);
      return result.fold(
        (failure) => Left(failure),
        (konten) => Right(konten),
      );
    } catch (e) {
      return Left('Gagal mengambil konten: $e');
    }
  }

  @override
  Future<Either<String, int>> getKontenCountByDokterId(
      {required String dokterId}) async {
    try {
      final result =
          await remoteDataSource.getKontenCountByDokterId(dokterId: dokterId);
      return result.fold(
        (failure) => Left(failure),
        (count) => Right(count),
      );
    } catch (e) {
      return Left('Gagal menghitung konten: $e');
    }
  }

  @override
  Future<Either<String, List<KontenSectionModel>>> getSectionsByKontenId(
      {required String kontenId}) async {
    try {
      final result =
          await remoteDataSource.getSectionsByKontenId(kontenId: kontenId);
      return result.fold(
        (failure) => Left(failure),
        (sections) => Right(sections),
      );
    } catch (e) {
      return Left('Gagal mengambil sections: $e');
    }
  }

  @override
  Future<Either<String, String>> updateKonten({
    required KontenModel konten,
    required KontenSectionModel section,
  }) async {
    try {
      final result =
          await remoteDataSource.updateKonten(konten: konten, section: section);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left('Gagal mengupdate konten: $e');
    }
  }

  @override
  Future<Either<String, String>> updateSection(
      {required KontenSectionModel section}) async {
    try {
      final result = await remoteDataSource.updateSection(section: section);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left('Gagal mengupdate section: $e');
    }
  }
}
