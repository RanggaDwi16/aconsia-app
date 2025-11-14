import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRemoteDataSource {
  Future<Either<String, int>> getPasienCountByDokterId({
    required String dokterId,
  });
  Future<Either<String, String>> addPasienMedicInformation({
    required String pasienId,
    required PasienProfileModel profile,
  });

  Future<Either<String, List<PasienProfileModel>>> getPasienListByDokterId({
    required String dokterId,
  });

  Future<Either<String, PasienProfileModel>> getPasienProfileById({
    required String pasienId,
  });
}

class HomeremoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeremoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, int>> getPasienCountByDokterId(
      {required String dokterId}) async {
    try {
      final querySnapshot = await firestore
          .collection('pasien_profiles')
          .where('dokterId', isEqualTo: dokterId)
          .get();

      final count = querySnapshot.size;

      return Right(count);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> addPasienMedicInformation(
      {required String pasienId, required PasienProfileModel profile}) async {
    try {
      final pasienRef = firestore.collection('pasien_profiles').doc(pasienId);

      await pasienRef.update({
        'jenisOperasi': profile.jenisOperasi,
        'jenisAnestesi': profile.jenisAnestesi,
        'klasifikasiASA': profile.klasifikasiAsa,
      });

      return Right('Informasi medis pasien berhasil ditambahkan.');
    } catch (e) {
      return Left('Gagal menambahkan informasi medis pasien: $e');
    }
  }

  @override
  Future<Either<String, List<PasienProfileModel>>> getPasienListByDokterId(
      {required String dokterId}) async {
    try {
      final querySnapshot = await firestore
          .collection('pasien_profiles')
          .where('dokterId', isEqualTo: dokterId)
          .get();

      final pasienList = querySnapshot.docs
          .map((doc) => PasienProfileModel.fromJson(doc.data()))
          .toList();

      return Right(pasienList);
    } catch (e) {
      return Left('Gagal mengambil daftar pasien: $e');
    }
  }

  @override
  Future<Either<String, PasienProfileModel>> getPasienProfileById(
      {required String pasienId}) async {
    try {
      final docSnapshot =
          await firestore.collection('pasien_profiles').doc(pasienId).get();

      if (docSnapshot.exists) {
        final pasienProfile = PasienProfileModel.fromJson(docSnapshot.data()!);
        return Right(pasienProfile);
      } else {
        return Left('Profil pasien tidak ditemukan.');
      }
    } catch (e) {
      return Left('Gagal mengambil profil pasien: $e');
    }
  }
}
