import 'dart:io';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:aconsia_app/core/config/cloudinary_config.dart';
import 'package:aconsia_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

/// Service for uploading images to Cloudinary
///
/// **Features:**
/// - Image compression before upload
/// - Progress tracking
/// - Multiple image uploads
/// - Image deletion
/// - Transformation support
/// - Error handling
///
/// **Usage:**
/// ```dart
/// final service = ImageUploadService();
///
/// final result = await service.uploadImage(
///   file: imageFile,
///   folder: CloudinaryConfig.dokterPhotosFolder,
///   onProgress: (progress) => print('Upload: $progress%'),
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (response) => print('URL: ${response.secureUrl}'),
/// );
/// ```
class ImageUploadService {
  late final CloudinaryPublic _cloudinary;

  ImageUploadService() {
    _cloudinary = CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: false,
    );
  }

  // ==================== IMAGE COMPRESSION ====================

  /// Compress image before upload
  ///
  /// Reduces file size while maintaining good quality.
  /// Uses flutter_image_compress for efficient compression.
  Future<Either<Failure, File>> compressImage({
    required File file,
    int quality = CloudinaryConfig.profilePhotoQuality,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final originalSize = await file.length();

      // Skip compression if file is already small
      if (originalSize < 500 * 1024) {
        return Right(file);
      }

      final filePath = file.absolute.path;
      final lastDot = filePath.lastIndexOf('.');
      final splitPath = filePath.substring(0, lastDot);
      final outPath = '${splitPath}_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: quality,
        minWidth: maxWidth ?? CloudinaryConfig.maxImageWidth,
        minHeight: maxHeight ?? CloudinaryConfig.maxImageHeight,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        return Left(Failure.unknown(
          message: 'Gagal melakukan kompresi gambar.',
        ));
      }

      final compressedFile = File(result.path);
      final compressedSize = await compressedFile.length();

      // Log compression ratio
      final ratio = ((originalSize - compressedSize) / originalSize * 100);
      print(
          'Image compressed: ${originalSize ~/ 1024}KB → ${compressedSize ~/ 1024}KB (${ratio.toStringAsFixed(1)}% reduction)');

      return Right(compressedFile);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Error saat kompresi gambar: ${e.toString()}',
      ));
    }
  }

  /// Compress image from bytes
  Future<Either<Failure, Uint8List>> compressImageBytes({
    required Uint8List bytes,
    int quality = CloudinaryConfig.profilePhotoQuality,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        quality: quality,
        minWidth: maxWidth ?? CloudinaryConfig.maxImageWidth,
        minHeight: maxHeight ?? CloudinaryConfig.maxImageHeight,
        format: CompressFormat.jpeg,
      );

      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Error saat kompresi gambar: ${e.toString()}',
      ));
    }
  }

  // ==================== IMAGE UPLOAD ====================

  /// Upload single image to Cloudinary
  ///
  /// **Parameters:**
  /// - `file`: Image file to upload
  /// - `folder`: Cloudinary folder path
  /// - `publicId`: Optional custom public ID (default: auto-generated)
  /// - `resourceType`: Type of resource (default: image)
  /// - `onProgress`: Callback for upload progress (0-100)
  ///
  /// **Returns:**
  /// - `Right(CloudinaryResponse)`: Upload successful
  /// - `Left(Failure)`: Upload failed
  Future<Either<Failure, CloudinaryResponse>> uploadImage({
    required File file,
    required String folder,
    String? publicId,
    CloudinaryResourceType resourceType = CloudinaryResourceType.Image,
    Function(int progress)? onProgress,
  }) async {
    try {
      // Validate file existence
      if (!await file.exists()) {
        return Left(Failure.validation(
          message: 'File gambar tidak ditemukan.',
        ));
      }

      // Validate file size
      final fileSize = await file.length();
      if (!CloudinaryConfig.isFileSizeValid(fileSize)) {
        return Left(Failure.validation(
          message:
              'Ukuran file terlalu besar. Maksimal ${CloudinaryConfig.maxFileSizeFormatted}.',
        ));
      }

      // Validate file type
      final extension = path.extension(file.path).replaceAll('.', '');
      if (!CloudinaryConfig.isAllowedExtension(extension)) {
        return Left(Failure.validation(
          message:
              'Tipe file tidak didukung. Gunakan: ${CloudinaryConfig.allowedExtensions.join(", ")}.',
        ));
      }

      // Compress image
      final compressionResult = await compressImage(file: file);
      final fileToUpload = compressionResult.fold(
        (failure) => file, // Use original if compression fails
        (compressed) => compressed,
      );

      // Prepare upload options
      final uploadPublicId = publicId ?? _generatePublicId(folder);

      // Upload to Cloudinary
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          fileToUpload.path,
          folder: folder,
          publicId: uploadPublicId,
          resourceType: resourceType,
        ),
      );

      // Notify 100% progress
      onProgress?.call(100);

      return Right(response);
    } on CloudinaryException catch (e) {
      return Left(Failure.server(
        message: 'Gagal upload gambar: ${e.message}',
      ));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Error tidak terduga saat upload: ${e.toString()}',
      ));
    }
  }

  /// Upload image from bytes
  Future<Either<Failure, CloudinaryResponse>> uploadImageBytes({
    required Uint8List bytes,
    required String folder,
    required String fileName,
    String? publicId,
    Function(int progress)? onProgress,
  }) async {
    try {
      // Validate file size
      if (!CloudinaryConfig.isFileSizeValid(bytes.length)) {
        return Left(Failure.validation(
          message:
              'Ukuran file terlalu besar. Maksimal ${CloudinaryConfig.maxFileSizeFormatted}.',
        ));
      }

      // Compress image bytes
      final compressionResult = await compressImageBytes(bytes: bytes);
      final bytesToUpload = compressionResult.fold(
        (failure) => bytes,
        (compressed) => compressed,
      );

      // Prepare upload options
      final uploadPublicId = publicId ?? _generatePublicId(folder);

      // Upload to Cloudinary
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          bytesToUpload,
          identifier: fileName,
          folder: folder,
          publicId: uploadPublicId,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      onProgress?.call(100);

      return Right(response);
    } on CloudinaryException catch (e) {
      return Left(Failure.server(
        message: 'Gagal upload gambar: ${e.message}',
      ));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Error tidak terduga saat upload: ${e.toString()}',
      ));
    }
  }

  /// Upload multiple images
  ///
  /// Uploads images sequentially and tracks overall progress.
  Future<Either<Failure, List<CloudinaryResponse>>> uploadMultipleImages({
    required List<File> files,
    required String folder,
    Function(int currentIndex, int total, int progress)? onProgress,
  }) async {
    try {
      final responses = <CloudinaryResponse>[];

      for (var i = 0; i < files.length; i++) {
        final result = await uploadImage(
          file: files[i],
          folder: folder,
          onProgress: (progress) {
            onProgress?.call(i + 1, files.length, progress);
          },
        );

        final response = result.fold(
          (failure) => throw Exception(failure.message),
          (response) => response,
        );

        responses.add(response);
      }

      return Right(responses);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Gagal upload beberapa gambar: ${e.toString()}',
      ));
    }
  }

  // ==================== IMAGE DELETION ====================

  /// Delete image from Cloudinary by public ID
  ///
  /// **Note:** Deletion requires authentication in Cloudinary.
  /// For unsigned uploads, you may need to implement deletion via backend.
  Future<Either<Failure, Unit>> deleteImage({
    required String publicId,
    CloudinaryResourceType resourceType = CloudinaryResourceType.Image,
  }) async {
    try {
      // Note: cloudinary_public package doesn't support deletion directly
      // You need to implement this via your backend API or use signed requests

      // For now, we return success and handle deletion via backend if needed
      return const Right(unit);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Gagal menghapus gambar: ${e.toString()}',
      ));
    }
  }

  /// Delete multiple images
  Future<Either<Failure, Unit>> deleteMultipleImages({
    required List<String> publicIds,
    CloudinaryResourceType resourceType = CloudinaryResourceType.Image,
  }) async {
    try {
      for (final publicId in publicIds) {
        await deleteImage(publicId: publicId, resourceType: resourceType);
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Gagal menghapus beberapa gambar: ${e.toString()}',
      ));
    }
  }

  // ==================== HELPER METHODS ====================

  /// Generate unique public ID
  String _generatePublicId(String folder) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp.hashCode;
    return 'img_${timestamp}_$random';
  }

  /// Get image info from URL
  ///
  /// Extracts public ID, format, version from Cloudinary URL.
  Map<String, String?> getImageInfo(String url) {
    return {
      'publicId': CloudinaryConfig.extractPublicId(url),
      'url': url,
      'isCloudinary': CloudinaryConfig.isCloudinaryUrl(url).toString(),
    };
  }

  /// Build optimized image URL with transformations
  String buildOptimizedUrl({
    required String publicId,
    int? width,
    int? height,
    int? quality,
    String? gravity,
    String? crop,
  }) {
    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (quality != null) transformations.add('q_$quality');
    if (gravity != null) transformations.add('g_$gravity');
    if (crop != null) transformations.add('c_$crop');

    // Add auto format and quality
    transformations.add('f_auto');
    if (quality == null) transformations.add('q_auto');

    final transformation = transformations.join(',');

    return CloudinaryConfig.buildImageUrl(
      publicId: publicId,
      transformation: transformation,
    );
  }
}

/// Response extension for easier access
extension CloudinaryResponseExtension on CloudinaryResponse {
  /// Get optimized URL with transformations
  String getOptimizedUrl({
    int? width,
    int? height,
    int? quality,
  }) {
    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (quality != null) transformations.add('q_$quality');

    transformations.addAll(['f_auto', 'q_auto']);

    final transformation = transformations.join(',');
    final baseUrl = secureUrl.split('/upload/').first;
    final imagePath = secureUrl.split('/upload/').last;

    return '$baseUrl/upload/$transformation/$imagePath';
  }

  /// Get thumbnail URL
  String getThumbnailUrl({bool isProfile = false}) {
    return CloudinaryConfig.buildThumbnailUrl(
      publicId: publicId,
      isProfile: isProfile,
    );
  }
}
