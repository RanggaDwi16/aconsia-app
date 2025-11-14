import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/cloudinary/cloudinary_repository.dart';
import 'package:aconsia_app/core/providers/cloudinary_providers.dart';

/// State for image upload process
class ImageUploadState {
  final bool isUploading;
  final int progress; // 0-100
  final String? imageUrl;
  final String? errorMessage;
  final bool isSuccess;

  const ImageUploadState({
    this.isUploading = false,
    this.progress = 0,
    this.imageUrl,
    this.errorMessage,
    this.isSuccess = false,
  });

  ImageUploadState copyWith({
    bool? isUploading,
    int? progress,
    String? imageUrl,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ImageUploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      imageUrl: imageUrl ?? this.imageUrl,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  /// Reset to initial state
  ImageUploadState reset() {
    return const ImageUploadState();
  }
}

/// StateNotifier for managing image upload state
///
/// **Features:**
/// - Upload progress tracking
/// - Error handling
/// - Success state management
/// - Multiple upload support
///
/// **Usage:**
/// ```dart
/// // In UI
/// final uploadState = ref.watch(imageUploadNotifierProvider);
///
/// // Upload image
/// await ref.read(imageUploadNotifierProvider.notifier).uploadFromGallery(
///   folder: CloudinaryConfig.dokterPhotosFolder,
/// );
///
/// // Check state
/// if (uploadState.isUploading) {
///   return CircularProgressIndicator(value: uploadState.progress / 100);
/// }
///
/// if (uploadState.isSuccess) {
///   return Image.network(uploadState.imageUrl!);
/// }
/// ```
class ImageUploadNotifier extends StateNotifier<ImageUploadState> {
  final CloudinaryRepository _cloudinaryRepository;

  ImageUploadNotifier(this._cloudinaryRepository)
      : super(const ImageUploadState());

  // ==================== SINGLE IMAGE UPLOAD ====================

  /// Upload image from gallery
  Future<void> uploadFromGallery({
    required String folder,
    String? publicId,
  }) async {
    // Reset state
    state = const ImageUploadState();

    // Set uploading
    state = state.copyWith(isUploading: true);

    // Upload
    final result = await _cloudinaryRepository.pickAndUploadFromGallery(
      folder: folder,
      publicId: publicId,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
    );

    // Handle result
    result.fold(
      (failure) {
        state = state.copyWith(
          isUploading: false,
          errorMessage: failure.message,
          isSuccess: false,
        );
      },
      (url) {
        state = state.copyWith(
          isUploading: false,
          imageUrl: url,
          isSuccess: true,
          progress: 100,
        );
      },
    );
  }

  /// Upload image from camera
  Future<void> uploadFromCamera({
    required String folder,
    String? publicId,
  }) async {
    // Reset state
    state = const ImageUploadState();

    // Set uploading
    state = state.copyWith(isUploading: true);

    // Upload
    final result = await _cloudinaryRepository.pickAndUploadFromCamera(
      folder: folder,
      publicId: publicId,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
    );

    // Handle result
    result.fold(
      (failure) {
        state = state.copyWith(
          isUploading: false,
          errorMessage: failure.message,
          isSuccess: false,
        );
      },
      (url) {
        state = state.copyWith(
          isUploading: false,
          imageUrl: url,
          isSuccess: true,
          progress: 100,
        );
      },
    );
  }

  /// Upload existing image file
  Future<void> uploadFile({
    required File file,
    required String folder,
    String? publicId,
  }) async {
    // Reset state
    state = const ImageUploadState();

    // Set uploading
    state = state.copyWith(isUploading: true);

    // Upload
    final result = await _cloudinaryRepository.uploadImageFile(
      file: file,
      folder: folder,
      publicId: publicId,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
    );

    // Handle result
    result.fold(
      (failure) {
        state = state.copyWith(
          isUploading: false,
          errorMessage: failure.message,
          isSuccess: false,
        );
      },
      (url) {
        state = state.copyWith(
          isUploading: false,
          imageUrl: url,
          isSuccess: true,
          progress: 100,
        );
      },
    );
  }

  // ==================== PROFILE PHOTO ====================

  /// Upload profile photo (simplified workflow)
  ///
  /// Automatically determines folder based on user type.
  Future<void> uploadProfilePhoto({
    required String userType, // 'dokter' or 'pasien'
    required String userId,
    bool fromCamera = false,
  }) async {
    // Reset state
    state = const ImageUploadState();

    // Set uploading
    state = state.copyWith(isUploading: true);

    // Upload
    final result = await _cloudinaryRepository.updateProfilePhoto(
      userType: userType,
      userId: userId,
      fromCamera: fromCamera,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
    );

    // Handle result
    result.fold(
      (failure) {
        state = state.copyWith(
          isUploading: false,
          errorMessage: failure.message,
          isSuccess: false,
        );
      },
      (url) {
        state = state.copyWith(
          isUploading: false,
          imageUrl: url,
          isSuccess: true,
          progress: 100,
        );
      },
    );
  }

  // ==================== STATE MANAGEMENT ====================

  /// Reset to initial state
  void reset() {
    state = const ImageUploadState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: '');
  }
}

/// Provider for ImageUploadNotifier
///
/// **Usage:**
/// ```dart
/// // Watch state
/// final uploadState = ref.watch(imageUploadNotifierProvider);
///
/// // Upload image
/// await ref.read(imageUploadNotifierProvider.notifier).uploadFromGallery(
///   folder: CloudinaryConfig.dokterPhotosFolder,
/// );
///
/// // Reset state
/// ref.read(imageUploadNotifierProvider.notifier).reset();
/// ```
final imageUploadNotifierProvider =
    StateNotifierProvider<ImageUploadNotifier, ImageUploadState>((ref) {
  final cloudinaryRepo = ref.watch(cloudinaryRepositoryProvider);
  return ImageUploadNotifier(cloudinaryRepo);
});

// ==================== ADDITIONAL PROVIDERS ====================

/// Provider for getting current upload progress (0-100)
final uploadProgressProvider = Provider<int>((ref) {
  final state = ref.watch(imageUploadNotifierProvider);
  return state.progress;
});

/// Provider for checking if upload is in progress
final isUploadingProvider = Provider<bool>((ref) {
  final state = ref.watch(imageUploadNotifierProvider);
  return state.isUploading;
});

/// Provider for getting uploaded image URL
final uploadedImageUrlProvider = Provider<String?>((ref) {
  final state = ref.watch(imageUploadNotifierProvider);
  return state.imageUrl;
});

/// Provider for getting upload error message
final uploadErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(imageUploadNotifierProvider);
  return state.errorMessage;
});
