import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';

abstract class PasienProfileRepository {
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
