import 'package:aconsia_app/core/services/image_picker_service.dart';
import 'package:aconsia_app/core/services/image_upload_service.dart';
import 'package:aconsia_app/core/cloudinary/cloudinary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== SERVICE PROVIDERS ====================

/// Provider for ImagePickerService
///
/// Provides image picking functionality from camera or gallery.
final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService();
});

/// Provider for ImageUploadService
///
/// Provides image upload functionality to Cloudinary.
final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService();
});

// ==================== REPOSITORY PROVIDER ====================

/// Provider for CloudinaryRepository
///
/// Provides complete image management workflow:
/// - Pick images from camera/gallery
/// - Upload to Cloudinary
/// - Compress images
/// - Progress tracking
/// - URL management
///
/// **Usage:**
/// ```dart
/// final cloudinaryRepo = ref.watch(cloudinaryRepositoryProvider);
///
/// // Pick and upload from gallery
/// final result = await cloudinaryRepo.pickAndUploadFromGallery(
///   folder: CloudinaryConfig.dokterPhotosFolder,
///   onProgress: (progress) => print('$progress%'),
/// );
///
/// // Update profile photo
/// final photoResult = await cloudinaryRepo.updateProfilePhoto(
///   userType: 'dokter',
///   userId: userId,
///   fromCamera: false,
/// );
/// ```
final cloudinaryRepositoryProvider = Provider<CloudinaryRepository>((ref) {
  final imagePickerService = ref.watch(imagePickerServiceProvider);
  final imageUploadService = ref.watch(imageUploadServiceProvider);

  return CloudinaryRepository(
    imagePickerService: imagePickerService,
    imageUploadService: imageUploadService,
  );
});
