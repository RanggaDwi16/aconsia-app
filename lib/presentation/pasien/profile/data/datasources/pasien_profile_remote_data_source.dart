import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';

abstract class PasienProfileRemoteDataSource {
  /// Get pasien profile by UID
  Future<Either<String, PasienProfileModel>> getPasienProfile(
      {required String uid});

  /// Update pasien profile
  Future<Either<String, String>> updatePasienProfile({
    required PasienProfileModel model,
  });

  /// Update pasien photo URL (Cloudinary)
  Future<Either<String, String>> updatePasienPhotoUrl({
    required String uid,
    required String photoUrl,
  });

  /// Delete pasien profile
  Future<Either<String, String>> deletePasienProfile(String uid);

  /// Stream pasien profile (real-time updates)
  Stream<PasienProfileModel?> streamPasienProfile({required String uid});

  /// Add konten to favorites
  Future<Either<String, String>> addKontenToFavorites({
    required String pasienId,
    required String kontenId,
  });

  /// Remove konten from favorites
  Future<Either<String, String>> removeKontenFromFavorites({
    required String pasienId,
    required String kontenId,
  });

  /// Update AI keywords for recommendations
  Future<Either<String, String>> updateAIKeywords({
    required String pasienId,
    required List<String> keywords,
  });

  /// Check if pasien profile exists
  Future<Either<String, bool>> checkProfileExists();
  Future<Either<String, List<DokterProfileModel>>> getAllDokterOptions();
}

class PasienProfileRemoteDataSourceImpl
    implements PasienProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  PasienProfileRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, String>> addKontenToFavorites(
      {required String pasienId, required String kontenId}) async {
    try {
      await firestore.collection('pasien_profiles').doc(pasienId).update({
        'kontenFavoritIds': FieldValue.arrayUnion([kontenId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Tambah favorit berhasil.');
    } catch (e) {
      return Left('Gagal tambah favorit: $e');
    }
  }

  @override
  Future<Either<String, bool>> checkProfileExists() async {
    try {
      final querySnapshot =
          await firestore.collection('pasien_profiles').limit(1).get();

      final exists = querySnapshot.docs.isNotEmpty;
      return Right(exists);
    } catch (e) {
      return Left('Failed to check profile existence: $e');
    }
  }

  @override
  Future<Either<String, String>> deletePasienProfile(String uid) async {
    try {
      await firestore.collection('pasien_profiles').doc(uid).delete();
      return Right('Pasien profile deleted successfully.');
    } catch (e) {
      return Left('Failed to delete pasien profile: $e');
    }
  }

  @override
  Future<Either<String, PasienProfileModel>> getPasienProfile(
      {required String uid}) async {
    try {
      final doc = await firestore.collection('pasien_profiles').doc(uid).get();

      if (!doc.exists) {
        return Left('Pasien profile not found.');
      }

      final profile = PasienProfileModel.fromJson(doc.data()!);
      return Right(profile);
    } catch (e) {
      return Left('Failed to get pasien profile: $e');
    }
  }

  @override
  Future<Either<String, String>> removeKontenFromFavorites(
      {required String pasienId, required String kontenId}) async {
    try {
      await firestore.collection('pasien_profiles').doc(pasienId).update({
        'kontenFavoritIds': FieldValue.arrayRemove([kontenId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Hapus favorit berhasil.');
    } catch (e) {
      return Left('Gagal hapus favorit: $e');
    }
  }

  @override
  Stream<PasienProfileModel?> streamPasienProfile({required String uid}) {
    return firestore
        .collection('pasien_profiles')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return PasienProfileModel.fromJson(doc.data()!);
    });
  }

  @override
  Future<Either<String, String>> updateAIKeywords(
      {required String pasienId, required List<String> keywords}) async {
    try {
      await firestore.collection('pasien_profiles').doc(pasienId).update({
        'aiKeywords': keywords,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Update keywords berhasil.');
    } catch (e) {
      return Left('Gagal update keywords: $e');
    }
  }

  @override
  Future<Either<String, String>> updatePasienPhotoUrl(
      {required String uid, required String photoUrl}) async {
    try {
      await firestore.collection('pasien_profiles').doc(uid).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Right('Photo URL updated successfully.');
    } catch (e) {
      return Left('Failed to update photo URL: $e');
    }
  }

  @override
  Future<Either<String, String>> updatePasienProfile(
      {required PasienProfileModel model}) async {
    try {
      await firestore
          .collection('pasien_profiles')
          .doc(model.uid)
          .set(model.toJson(), SetOptions(merge: true));
      return const Right('Profil berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update profil: $e');
    }
  }

  @override
  Future<Either<String, List<DokterProfileModel>>> getAllDokterOptions() async {
    try {
      final querySnapshot = await firestore.collection('dokter_profiles').get();

      final dokterList = querySnapshot.docs
          .map((doc) => DokterProfileModel.fromJson(doc.data()))
          .toList();

      return Right(dokterList);
    } catch (e) {
      return Left('Gagal mengambil daftar dokter: $e');
    }
  }
}
