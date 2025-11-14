import 'dart:io';

import 'package:aconsia_app/core/services/cloudinary_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_photo_provider.g.dart';

// State untuk upload photo
class UploadPhotoState {
  final bool isUploading;
  final String? errorMessage;
  final String? downloadUrl;

  UploadPhotoState({
    this.isUploading = false,
    this.errorMessage,
    this.downloadUrl,
  });

  UploadPhotoState copyWith({
    bool? isUploading,
    String? errorMessage,
    String? downloadUrl,
  }) {
    return UploadPhotoState(
      isUploading: isUploading ?? this.isUploading,
      errorMessage: errorMessage ?? this.errorMessage,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}

@riverpod
class UploadPhotoController extends _$UploadPhotoController {
  @override
  UploadPhotoState build() {
    return UploadPhotoState();
  }

  Future<void> uploadDokterPhoto({
    required String uid,
    required File imageFile,
    required void Function(String url) onSuccess,
    required void Function(String error) onError,
  }) async {
    state = state.copyWith(isUploading: true, errorMessage: null);

    try {
      final storageService = ref.read(cloudinaryStorageServiceProvider);
      final downloadUrl = await storageService.uploadDokterProfilePhoto(
        uid: uid,
        imageFile: imageFile,
      );

      state = state.copyWith(
        isUploading: false,
        downloadUrl: downloadUrl,
      );

      onSuccess(downloadUrl);
    } catch (e) {
      final errorMessage = e.toString();
      state = state.copyWith(
        isUploading: false,
        errorMessage: errorMessage,
      );
      onError(errorMessage);
    }
  }

  Future<void> uploadPasienPhoto({
    required String uid,
    required File imageFile,
    required void Function(String url) onSuccess,
    required void Function(String error) onError,
  }) async {
    state = state.copyWith(isUploading: true, errorMessage: null);

    try {
      final storageService = ref.read(cloudinaryStorageServiceProvider);
      final downloadUrl = await storageService.uploadPasienProfilePhoto(
        uid: uid,
        imageFile: imageFile,
      );

      state = state.copyWith(
        isUploading: false,
        downloadUrl: downloadUrl,
      );

      onSuccess(downloadUrl);
    } catch (e) {
      final errorMessage = e.toString();
      state = state.copyWith(
        isUploading: false,
        errorMessage: errorMessage,
      );
      onError(errorMessage);
    }
  }

  Future<void> uploadKontenImage({
    required File imageFile,
    required String fileName,
    required void Function(String url) onSuccess,
    required void Function(String error) onError,
  }) async {
    state = state.copyWith(isUploading: true, errorMessage: null);

    try {
      final storageService = ref.read(cloudinaryStorageServiceProvider);
      final downloadUrl = await storageService.uploadKontenImage(
        imageFile: imageFile,
        fileName: fileName,
      );

      state = state.copyWith(
        isUploading: false,
        downloadUrl: downloadUrl,
      );

      onSuccess(downloadUrl);
    } catch (e) {
      final errorMessage = e.toString();
      state = state.copyWith(
        isUploading: false,
        errorMessage: errorMessage,
      );
      onError(errorMessage);
    }
  }
}
