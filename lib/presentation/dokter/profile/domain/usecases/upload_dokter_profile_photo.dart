import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/services/firebase_storage_service.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';

/// UseCase: Upload Dokter Profile Photo
/// Handles image upload + update DokterProfile.fotoProfilUrl
class UploadDokterProfilePhoto {
  final FirebaseStorageService storageService;
  final DokterProfileRepository profileRepository;

  UploadDokterProfilePhoto({
    required this.storageService,
    required this.profileRepository,
  });

  Future<Either<String, String>> call({
    required String uid,
    required File imageFile,
  }) async {
    // 1. Upload to Firebase Storage
    final uploadResult = await storageService.uploadDokterProfilePhoto(
      uid: uid,
      imageFile: imageFile,
    );

    return uploadResult.fold(
      (error) => Left(error),
      (downloadUrl) async {
        // 2. Update DokterProfile with new URL
        final updateResult = await profileRepository.updateDokterPhotoUrl(
          uid: uid,
          photoUrl: downloadUrl,
        );

        return updateResult.fold(
          (error) => Left('Foto terupload tapi gagal update profil: $error'),
          (_) => Right(downloadUrl),
        );
      },
    );
  }
}
