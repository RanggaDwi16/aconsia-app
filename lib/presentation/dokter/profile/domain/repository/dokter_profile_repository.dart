import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';

abstract class DokterProfileRepository {
  /// Get dokter profile by UID
  Future<Either<String, DokterProfileModel>> getDokterProfile({
    required String uid,
  });

  /// Update dokter profile
  Future<Either<String, String>> updateDokterProfile({
    required DokterProfileModel profile,
  });

  /// Update dokter photo URL (Cloudinary)
  Future<Either<String, String>> updateDokterPhotoUrl({
    required String uid,
    required String photoUrl,
  });

  /// Delete dokter profile
  Future<Either<String, String>> deleteDokterProfile({
    required String uid,
  });

  /// Stream dokter profile (real-time updates)
  Stream<DokterProfileModel?> streamDokterProfile({
    required String uid,
  });

  /// Check if dokter profile exists
  Future<Either<String, bool>> checkProfileExists({
    required String uid,
  });
}
