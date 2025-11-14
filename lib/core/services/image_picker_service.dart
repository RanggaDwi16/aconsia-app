import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:aconsia_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

/// Service for picking images from camera or gallery
///
/// **Features:**
/// - Pick from camera
/// - Pick from gallery
/// - Multiple image selection
/// - Image source selection dialog
/// - Permission handling
///
/// **Usage:**
/// ```dart
/// final service = ImagePickerService();
///
/// // Pick single image from gallery
/// final result = await service.pickImageFromGallery();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (file) => print('Selected: ${file.path}'),
/// );
///
/// // Pick from camera
/// final cameraResult = await service.pickImageFromCamera();
///
/// // Pick multiple images
/// final multiResult = await service.pickMultipleImages(maxImages: 5);
/// ```
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // ==================== SINGLE IMAGE SELECTION ====================

  /// Pick image from gallery
  ///
  /// **Parameters:**
  /// - `imageQuality`: Quality of the image (0-100, default: 85)
  /// - `maxWidth`: Maximum width (optional)
  /// - `maxHeight`: Maximum height (optional)
  ///
  /// **Returns:**
  /// - `Right(File)`: Image selected successfully
  /// - `Left(Failure)`: Error or user cancelled
  Future<Either<Failure, File>> pickImageFromGallery({
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile == null) {
        return Left(Failure.validation(
          message: 'Tidak ada gambar yang dipilih.',
        ));
      }

      return Right(File(pickedFile.path));
    } catch (e) {
      if (e.toString().contains('photo access')) {
        return Left(Failure.permissionDenied(
          message: 'Akses galeri ditolak. Silakan aktifkan izin di pengaturan.',
        ));
      }

      return Left(Failure.unknown(
        message: 'Gagal memilih gambar dari galeri: ${e.toString()}',
      ));
    }
  }

  /// Pick image from camera
  ///
  /// **Parameters:**
  /// - `imageQuality`: Quality of the image (0-100, default: 85)
  /// - `maxWidth`: Maximum width (optional)
  /// - `maxHeight`: Maximum height (optional)
  /// - `preferredCameraDevice`: Front or back camera (default: rear)
  ///
  /// **Returns:**
  /// - `Right(File)`: Photo captured successfully
  /// - `Left(Failure)`: Error or user cancelled
  Future<Either<Failure, File>> pickImageFromCamera({
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        preferredCameraDevice: preferredCameraDevice,
      );

      if (pickedFile == null) {
        return Left(Failure.validation(
          message: 'Tidak ada foto yang diambil.',
        ));
      }

      return Right(File(pickedFile.path));
    } catch (e) {
      if (e.toString().contains('camera access')) {
        return Left(Failure.permissionDenied(
          message: 'Akses kamera ditolak. Silakan aktifkan izin di pengaturan.',
        ));
      }

      return Left(Failure.unknown(
        message: 'Gagal mengambil foto dari kamera: ${e.toString()}',
      ));
    }
  }

  // ==================== MULTIPLE IMAGE SELECTION ====================

  /// Pick multiple images from gallery
  ///
  /// **Parameters:**
  /// - `maxImages`: Maximum number of images to select (default: 10)
  /// - `imageQuality`: Quality of images (0-100, default: 85)
  /// - `maxWidth`: Maximum width (optional)
  /// - `maxHeight`: Maximum height (optional)
  ///
  /// **Returns:**
  /// - `Right(List<File>)`: Images selected successfully
  /// - `Left(Failure)`: Error or user cancelled
  Future<Either<Failure, List<File>>> pickMultipleImages({
    int maxImages = 10,
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFiles.isEmpty) {
        return Left(Failure.validation(
          message: 'Tidak ada gambar yang dipilih.',
        ));
      }

      // Limit to max images
      final limitedFiles = pickedFiles.take(maxImages).toList();

      // Convert to File objects
      final files = limitedFiles.map((xFile) => File(xFile.path)).toList();

      return Right(files);
    } catch (e) {
      if (e.toString().contains('photo access')) {
        return Left(Failure.permissionDenied(
          message: 'Akses galeri ditolak. Silakan aktifkan izin di pengaturan.',
        ));
      }

      return Left(Failure.unknown(
        message: 'Gagal memilih gambar dari galeri: ${e.toString()}',
      ));
    }
  }

  // ==================== VIDEO SELECTION (OPTIONAL) ====================

  /// Pick video from gallery
  ///
  /// Can be extended for future video support.
  Future<Either<Failure, File>> pickVideoFromGallery({
    Duration? maxDuration,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: maxDuration,
      );

      if (pickedFile == null) {
        return Left(Failure.validation(
          message: 'Tidak ada video yang dipilih.',
        ));
      }

      return Right(File(pickedFile.path));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Gagal memilih video: ${e.toString()}',
      ));
    }
  }

  /// Pick video from camera
  Future<Either<Failure, File>> pickVideoFromCamera({
    Duration? maxDuration,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: maxDuration,
        preferredCameraDevice: preferredCameraDevice,
      );

      if (pickedFile == null) {
        return Left(Failure.validation(
          message: 'Tidak ada video yang direkam.',
        ));
      }

      return Right(File(pickedFile.path));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Gagal merekam video: ${e.toString()}',
      ));
    }
  }

  // ==================== HELPER METHODS ====================

  /// Get available cameras (front, rear, or both)
  Future<List<CameraDevice>> getAvailableCameras() async {
    // This is a placeholder - actual implementation would need platform channels
    return [CameraDevice.rear, CameraDevice.front];
  }

  /// Check if camera is available
  Future<bool> isCameraAvailable() async {
    try {
      final cameras = await getAvailableCameras();
      return cameras.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

/// Image source type for selection dialog
enum ImageSourceType {
  camera,
  gallery,
  both,
}

/// Extension for ImageSourceType
extension ImageSourceTypeExtension on ImageSourceType {
  String get displayName {
    switch (this) {
      case ImageSourceType.camera:
        return 'Kamera';
      case ImageSourceType.gallery:
        return 'Galeri';
      case ImageSourceType.both:
        return 'Kamera atau Galeri';
    }
  }

  String get icon {
    switch (this) {
      case ImageSourceType.camera:
        return '📷';
      case ImageSourceType.gallery:
        return '🖼️';
      case ImageSourceType.both:
        return '📁';
    }
  }
}
