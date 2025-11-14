import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aconsia_app/core/services/firebase_storage_service.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/dokter_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/upload_dokter_profile_photo.dart';

part 'upload_photo_provider.g.dart';

// ==================== SERVICE ====================

@riverpod
FirebaseStorageService firebaseStorageService(FirebaseStorageServiceRef ref) {
  return FirebaseStorageService();
}

// ==================== USE CASE ====================

@riverpod
UploadDokterProfilePhoto uploadDokterProfilePhoto(
  UploadDokterProfilePhotoRef ref,
) {
  return UploadDokterProfilePhoto(
    storageService: ref.watch(firebaseStorageServiceProvider),
    profileRepository: ref.watch(dokterProfileRepositoryProvider),
  );
}

// ==================== UPLOAD STATE ====================

/// State untuk tracking upload progress
class UploadPhotoState {
  final bool isUploading;
  final double uploadProgress; // 0.0 to 1.0
  final String? errorMessage;
  final String? downloadUrl;

  UploadPhotoState({
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.errorMessage,
    this.downloadUrl,
  });

  UploadPhotoState copyWith({
    bool? isUploading,
    double? uploadProgress,
    String? errorMessage,
    String? downloadUrl,
  }) {
    return UploadPhotoState(
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      errorMessage: errorMessage,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}

// ==================== CONTROLLER ====================

/// Controller untuk upload dokter profile photo
@riverpod
class UploadPhotoController extends _$UploadPhotoController {
  @override
  UploadPhotoState build() {
    return UploadPhotoState();
  }

  /// Upload dokter profile photo
  Future<void> uploadDokterPhoto({
    required String uid,
    required File imageFile,
    Function(String downloadUrl)? onSuccess,
    Function(String error)? onError,
  }) async {
    state = state.copyWith(
      isUploading: true,
      uploadProgress: 0.0,
      errorMessage: null,
    );

    // Simulate progress (karena Firebase Storage putFile tidak return progress stream by default)
    state = state.copyWith(uploadProgress: 0.3);

    final useCase = ref.read(uploadDokterProfilePhotoProvider);
    final result = await useCase(uid: uid, imageFile: imageFile);

    result.fold(
      (error) {
        state = state.copyWith(
          isUploading: false,
          errorMessage: error,
        );
        onError?.call(error);
      },
      (downloadUrl) {
        state = state.copyWith(
          isUploading: false,
          uploadProgress: 1.0,
          downloadUrl: downloadUrl,
          errorMessage: null,
        );
        onSuccess?.call(downloadUrl);
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = UploadPhotoState();
  }
}
