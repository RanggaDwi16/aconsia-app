import 'dart:io';
import 'dart:typed_data';
import 'package:aconsia_app/core/config/cloudinary_config.dart';
import 'package:aconsia_app/core/services/image_upload_service.dart';
import 'package:aconsia_app/core/services/image_picker_service.dart';
import 'package:aconsia_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

/// Repository for managing Cloudinary operations
///
/// This repository coordinates ImagePickerService and ImageUploadService
/// to provide a complete image management solution.
///
/// **Features:**
/// - Pick and upload images in one call
/// - Validate before upload
/// - Progress tracking
/// - Error handling
/// - URL management
///
/// **Usage:**
/// ```dart
/// final repo = CloudinaryRepository(
///   imagePickerService: ImagePickerService(),
///   imageUploadService: ImageUploadService(),
/// );
///
/// // Pick from gallery and upload
/// final result = await repo.pickAndUploadFromGallery(
///   folder: CloudinaryConfig.dokterPhotosFolder,
///   onProgress: (progress) => print('$progress%'),
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (url) => print('Uploaded: $url'),
/// );
/// ```
class CloudinaryRepository {
  final ImagePickerService _imagePickerService;
  final ImageUploadService _imageUploadService;

  CloudinaryRepository({
    required ImagePickerService imagePickerService,
    required ImageUploadService imageUploadService,
  })  : _imagePickerService = imagePickerService,
        _imageUploadService = imageUploadService;

  // ==================== PICK & UPLOAD ====================

  /// Pick image from gallery and upload to Cloudinary
  ///
  /// **Parameters:**
  /// - `folder`: Cloudinary folder path
  /// - `publicId`: Custom public ID (optional)
  /// - `onProgress`: Upload progress callback (0-100)
  ///
  /// **Returns:**
  /// - `Right(String)`: Cloudinary secure URL
  /// - `Left(Failure)`: Error occurred
  Future<Either<Failure, String>> pickAndUploadFromGallery({
    required String folder,
    String? publicId,
    Function(int progress)? onProgress,
  }) async {
    // Step 1: Pick image
    final pickResult = await _imagePickerService.pickImageFromGallery();

    return await pickResult.fold(
      (failure) async => Left(failure),
      (file) async {
        // Step 2: Upload image
        return await uploadImageFile(
          file: file,
          folder: folder,
          publicId: publicId,
          onProgress: onProgress,
        );
      },
    );
  }

  /// Pick image from camera and upload to Cloudinary
  Future<Either<Failure, String>> pickAndUploadFromCamera({
    required String folder,
    String? publicId,
    Function(int progress)? onProgress,
  }) async {
    // Step 1: Take photo
    final pickResult = await _imagePickerService.pickImageFromCamera();

    return await pickResult.fold(
      (failure) async => Left(failure),
      (file) async {
        // Step 2: Upload photo
        return await uploadImageFile(
          file: file,
          folder: folder,
          publicId: publicId,
          onProgress: onProgress,
        );
      },
    );
  }

  /// Pick multiple images and upload to Cloudinary
  Future<Either<Failure, List<String>>> pickAndUploadMultiple({
    required String folder,
    int maxImages = 5,
    Function(int currentIndex, int total, int progress)? onProgress,
  }) async {
    // Step 1: Pick images
    final pickResult = await _imagePickerService.pickMultipleImages(
      maxImages: maxImages,
    );

    return await pickResult.fold(
      (failure) async => Left(failure),
      (files) async {
        // Step 2: Upload all images
        return await uploadMultipleImages(
          files: files,
          folder: folder,
          onProgress: onProgress,
        );
      },
    );
  }

  // ==================== DIRECT UPLOAD ====================

  /// Upload image file to Cloudinary
  ///
  /// Use this if you already have a File object.
  Future<Either<Failure, String>> uploadImageFile({
    required File file,
    required String folder,
    String? publicId,
    Function(int progress)? onProgress,
  }) async {
    final result = await _imageUploadService.uploadImage(
      file: file,
      folder: folder,
      publicId: publicId,
      onProgress: onProgress,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) {
        final url = response.secureUrl;
        if (url.isEmpty) {
          return Left(Failure.imageUpload(
            message: 'URL gambar tidak valid dari Cloudinary.',
          ));
        }
        return Right(url);
      },
    );
  }

  /// Upload image from bytes
  Future<Either<Failure, String>> uploadImageBytes({
    required Uint8List bytes,
    required String folder,
    required String fileName,
    String? publicId,
    Function(int progress)? onProgress,
  }) async {
    final result = await _imageUploadService.uploadImageBytes(
      bytes: bytes,
      folder: folder,
      fileName: fileName,
      publicId: publicId,
      onProgress: onProgress,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) {
        final url = response.secureUrl;
        if (url.isEmpty) {
          return Left(Failure.imageUpload(
            message: 'URL gambar tidak valid dari Cloudinary.',
          ));
        }
        return Right(url);
      },
    );
  }

  /// Upload multiple images
  Future<Either<Failure, List<String>>> uploadMultipleImages({
    required List<File> files,
    required String folder,
    Function(int currentIndex, int total, int progress)? onProgress,
  }) async {
    final result = await _imageUploadService.uploadMultipleImages(
      files: files,
      folder: folder,
      onProgress: onProgress,
    );

    return result.fold(
      (failure) => Left(failure),
      (responses) {
        final urls = responses
            .map((r) => r.secureUrl)
            .where((url) => url.isNotEmpty)
            .toList();

        if (urls.length != responses.length) {
          return Left(Failure.imageUpload(
            message: 'Beberapa gambar gagal mendapatkan URL.',
          ));
        }

        return Right(urls);
      },
    );
  }

  // ==================== PROFILE PHOTO WORKFLOW ====================

  /// Complete workflow for updating profile photo
  ///
  /// This method:
  /// 1. Picks image (from camera or gallery)
  /// 2. Compresses image
  /// 3. Uploads to Cloudinary
  /// 4. Returns optimized URL
  ///
  /// **Parameters:**
  /// - `userType`: 'dokter' or 'pasien'
  /// - `userId`: User ID for folder organization
  /// - `fromCamera`: true for camera, false for gallery
  /// - `onProgress`: Progress callback
  Future<Either<Failure, String>> updateProfilePhoto({
    required String userType,
    required String userId,
    bool fromCamera = false,
    Function(int progress)? onProgress,
  }) async {
    // Get appropriate folder
    final folder = CloudinaryConfig.getFolderForUserType(userType);

    // Pick and upload
    if (fromCamera) {
      return await pickAndUploadFromCamera(
        folder: folder,
        publicId: 'user_$userId',
        onProgress: onProgress,
      );
    } else {
      return await pickAndUploadFromGallery(
        folder: folder,
        publicId: 'user_$userId',
        onProgress: onProgress,
      );
    }
  }

  // ==================== URL HELPERS ====================

  /// Get optimized profile photo URL
  String getOptimizedProfileUrl(String url) {
    final publicId = CloudinaryConfig.extractPublicId(url);
    if (publicId == null) return url;

    return CloudinaryConfig.buildImageUrl(
      publicId: publicId,
      transformation: CloudinaryConfig.profilePhotoTransform,
    );
  }

  /// Get thumbnail URL
  String getThumbnailUrl(String url, {bool isProfile = true}) {
    final publicId = CloudinaryConfig.extractPublicId(url);
    if (publicId == null) return url;

    return CloudinaryConfig.buildThumbnailUrl(
      publicId: publicId,
      isProfile: isProfile,
    );
  }

  /// Validate image URL
  bool isValidCloudinaryUrl(String url) {
    return CloudinaryConfig.isCloudinaryUrl(url);
  }

  /// Extract public ID from URL
  String? extractPublicId(String url) {
    return CloudinaryConfig.extractPublicId(url);
  }

  // ==================== VALIDATION ====================

  /// Validate file before upload
  Either<Failure, Unit> validateFile(File file) {
    // Check file existence
    if (!file.existsSync()) {
      return Left(Failure.validation(
        message: 'File tidak ditemukan.',
      ));
    }

    // Check file size
    final fileSize = file.lengthSync();
    if (!CloudinaryConfig.isFileSizeValid(fileSize)) {
      return Left(Failure.validation(
        message:
            'Ukuran file terlalu besar. Maksimal ${CloudinaryConfig.maxFileSizeFormatted}.',
      ));
    }

    // Check file extension
    final extension = file.path.split('.').last;
    if (!CloudinaryConfig.isAllowedExtension(extension)) {
      return Left(Failure.validation(
        message:
            'Format file tidak didukung. Gunakan: ${CloudinaryConfig.allowedExtensions.join(", ")}.',
      ));
    }

    return const Right(unit);
  }

  /// Validate multiple files
  Either<Failure, Unit> validateFiles(List<File> files) {
    if (files.isEmpty) {
      return Left(Failure.validation(
        message: 'Tidak ada file yang dipilih.',
      ));
    }

    for (var file in files) {
      final validation = validateFile(file);
      if (validation.isLeft()) {
        return validation;
      }
    }

    return const Right(unit);
  }
}
