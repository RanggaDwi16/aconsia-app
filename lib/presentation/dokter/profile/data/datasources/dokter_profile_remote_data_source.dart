import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';

/// Remote DataSource untuk Dokter Profile
abstract class DokterProfileRemoteDataSource {
  Future<Either<String, DokterProfileModel>> getDokterProfile(
      {required String uid});

  Stream<DokterProfileModel?> streamDokterProfile({required String uid});

  Future<Either<String, String>> updateDokterProfile(
      {required DokterProfileModel profile});

  Future<Either<String, String>> updateDokterPhotoUrl(
      {required String uid, required String photoUrl});

  Future<Either<String, String>> deleteDokterProfile({required String uid});
  Future<Either<String, bool>> checkProfileExists({
    required String uid,
  });
}

class DokterProfileRemoteDataSourceImpl
    implements DokterProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  DokterProfileRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, bool>> checkProfileExists({required String uid}) async {
    try {
      final doc = await firestore.collection('dokter_profiles').doc(uid).get();
      return Right(doc.exists);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteDokterProfile(
      {required String uid}) async {
    try {
      await firestore.collection('dokter_profiles').doc(uid).delete();
      return const Right('Profil dokter berhasil dihapus.');
    } catch (e) {
      return Left('Gagal menghapus profil dokter: $e');
    }
  }

  @override
  Future<Either<String, DokterProfileModel>> getDokterProfile(
      {required String uid}) async {
    try {
      final doc = await firestore.collection('dokter_profiles').doc(uid).get();
      if (!doc.exists) {
        return const Left('Profil tidak ditemukan.');
      }
      return Right(DokterProfileModel.fromJson(doc.data()!));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<DokterProfileModel?> streamDokterProfile({required String uid}) {
    try {
      return firestore.collection('dokter_profiles').doc(uid).snapshots().map(
          (doc) =>
              doc.exists ? DokterProfileModel.fromJson(doc.data()!) : null);
    } catch (e) {
      throw Exception('Gagal melakukan streaming profil dokter: $e');
    }
  }

  @override
  Future<Either<String, String>> updateDokterPhotoUrl(
      {required String uid, required String photoUrl}) async {
    try {
      await firestore.collection('dokter_profiles').doc(uid).update({
        'fotoProfilUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Foto profil berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update foto: $e');
    }
  }

  @override
  Future<Either<String, String>> updateDokterProfile(
      {required DokterProfileModel profile}) async {
    try {
      await firestore
          .collection('dokter_profiles')
          .doc(profile.uid)
          .set(profile.toJson(), SetOptions(merge: true));
      return const Right('Profil dokter berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update profil: $e');
    }
  }
}
