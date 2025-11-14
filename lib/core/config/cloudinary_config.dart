/// Cloudinary Configuration for ACONSIA App
///
/// This file contains all Cloudinary settings including:
/// - Cloud name
/// - Upload presets
/// - Folder structure
/// - Transformation presets
/// - URL configurations
///
/// **IMPORTANT:**
/// Replace placeholder values with actual Cloudinary credentials
/// from your Cloudinary dashboard (https://cloudinary.com/console)
library;

class CloudinaryConfig {
  // ==================== CLOUDINARY CREDENTIALS ====================

  /// Your Cloudinary cloud name
  /// Get this from: Cloudinary Dashboard > Account Details > Cloud name
  ///
  /// **TODO:** Replace with actual cloud name
  static const String cloudName =
      'YOUR_CLOUD_NAME'; // Example: 'aconsia-health'

  /// Upload preset for unsigned uploads (recommended for mobile apps)
  ///
  /// How to create:
  /// 1. Go to Settings > Upload > Upload presets
  /// 2. Click "Add upload preset"
  /// 3. Set Signing Mode to "Unsigned"
  /// 4. Configure folder, transformations, etc.
  /// 5. Copy the preset name
  ///
  /// **TODO:** Replace with actual upload preset
  static const String uploadPreset = 'aconsia_upload_preset';

  // ==================== FOLDER STRUCTURE ====================

  /// Folder for dokter profile photos
  static const String dokterPhotosFolder = 'aconsia/dokter/photos';

  /// Folder for pasien profile photos
  static const String pasienPhotosFolder = 'aconsia/pasien/photos';

  /// Folder for konten images (educational content)
  static const String kontenImagesFolder = 'aconsia/konten/images';

  /// Folder for konten section images
  static const String sectionImagesFolder = 'aconsia/konten/sections';

  /// Folder for chat attachments (if implemented)
  static const String chatAttachmentsFolder = 'aconsia/chat/attachments';

  // ==================== IMAGE QUALITY SETTINGS ====================

  /// Quality for profile photos (0-100, higher = better quality)
  static const int profilePhotoQuality = 85;

  /// Quality for konten images (0-100)
  static const int kontenImageQuality = 90;

  /// Quality for thumbnails (0-100)
  static const int thumbnailQuality = 70;

  /// Max file size for uploads in bytes (5MB)
  static const int maxFileSize = 5 * 1024 * 1024;

  /// Max image width in pixels (will compress if larger)
  static const int maxImageWidth = 1920;

  /// Max image height in pixels (will compress if larger)
  static const int maxImageHeight = 1920;

  /// Thumbnail width
  static const int thumbnailWidth = 300;

  /// Thumbnail height
  static const int thumbnailHeight = 300;

  // ==================== TRANSFORMATION PRESETS ====================

  /// Profile photo transformation (square, cropped)
  ///
  /// Usage: append to URL like: /c_fill,g_face,h_400,w_400/
  static const String profilePhotoTransform =
      'c_fill,g_face,h_400,w_400,q_auto';

  /// Profile photo thumbnail (small, square)
  static const String profileThumbnailTransform =
      'c_thumb,g_face,h_150,w_150,q_auto';

  /// Konten image transformation (fit, maintain aspect ratio)
  static const String kontenImageTransform = 'c_limit,h_1080,w_1920,q_auto';

  /// Konten thumbnail transformation
  static const String kontenThumbnailTransform = 'c_fill,h_300,w_300,q_auto';

  // ==================== ALLOWED FILE TYPES ====================

  /// Allowed image MIME types
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
  ];

  /// Allowed file extensions
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // ==================== URL HELPERS ====================

  /// Build Cloudinary URL with transformations
  ///
  /// Example:
  /// ```dart
  /// final url = CloudinaryConfig.buildImageUrl(
  ///   publicId: 'aconsia/dokter/photos/user123',
  ///   transformation: CloudinaryConfig.profilePhotoTransform,
  /// );
  /// ```
  static String buildImageUrl({
    required String publicId,
    String? transformation,
  }) {
    final baseUrl = 'https://res.cloudinary.com/$cloudName/image/upload';

    if (transformation != null && transformation.isNotEmpty) {
      return '$baseUrl/$transformation/$publicId';
    }

    return '$baseUrl/$publicId';
  }

  /// Build thumbnail URL
  static String buildThumbnailUrl({
    required String publicId,
    bool isProfile = false,
  }) {
    final transform =
        isProfile ? profileThumbnailTransform : kontenThumbnailTransform;

    return buildImageUrl(publicId: publicId, transformation: transform);
  }

  /// Extract public ID from Cloudinary URL
  ///
  /// Example:
  /// Input: https://res.cloudinary.com/aconsia/image/upload/v123456/aconsia/dokter/photos/user123.jpg
  /// Output: aconsia/dokter/photos/user123
  static String? extractPublicId(String url) {
    if (!url.contains('cloudinary.com')) return null;

    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;

      // Find 'upload' segment
      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex == segments.length - 1) return null;

      // Get segments after 'upload' (skip version if exists)
      var pathAfterUpload = segments.skip(uploadIndex + 1).toList();

      // Skip version segment if it starts with 'v'
      if (pathAfterUpload.isNotEmpty && pathAfterUpload[0].startsWith('v')) {
        pathAfterUpload = pathAfterUpload.skip(1).toList();
      }

      // Join remaining segments and remove file extension
      final publicId = pathAfterUpload.join('/');
      return publicId.replaceAll(RegExp(r'\.(jpg|jpeg|png|webp)$'), '');
    } catch (e) {
      return null;
    }
  }

  /// Check if URL is a Cloudinary URL
  static bool isCloudinaryUrl(String url) {
    return url.contains('cloudinary.com');
  }

  /// Get folder path for user type
  static String getFolderForUserType(String userType) {
    switch (userType.toLowerCase()) {
      case 'dokter':
        return dokterPhotosFolder;
      case 'pasien':
        return pasienPhotosFolder;
      default:
        return pasienPhotosFolder;
    }
  }

  // ==================== VALIDATION HELPERS ====================

  /// Check if file type is allowed
  static bool isAllowedFileType(String mimeType) {
    return allowedImageTypes.contains(mimeType.toLowerCase());
  }

  /// Check if file extension is allowed
  static bool isAllowedExtension(String extension) {
    return allowedExtensions
        .contains(extension.toLowerCase().replaceAll('.', ''));
  }

  /// Check if file size is within limit
  static bool isFileSizeValid(int fileSizeBytes) {
    return fileSizeBytes <= maxFileSize;
  }

  /// Get human-readable file size limit
  static String get maxFileSizeFormatted {
    final mb = maxFileSize / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }
}

/// Extension methods for Cloudinary URLs
extension CloudinaryUrlExtension on String {
  /// Check if this string is a Cloudinary URL
  bool get isCloudinaryUrl => CloudinaryConfig.isCloudinaryUrl(this);

  /// Extract public ID from this URL
  String? get publicId => CloudinaryConfig.extractPublicId(this);

  /// Build thumbnail URL from this public ID
  String toThumbnail({bool isProfile = false}) {
    return CloudinaryConfig.buildThumbnailUrl(
      publicId: this,
      isProfile: isProfile,
    );
  }
}
