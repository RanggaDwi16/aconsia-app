import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'cloudinary_storage_service.g.dart';

@riverpod
CloudinaryStorageService cloudinaryStorageService(
    CloudinaryStorageServiceRef ref) {
  return CloudinaryStorageService();
}

/// Service untuk upload gambar ke Cloudinary (GRATIS)
/// Alternative dari Firebase Storage
class CloudinaryStorageService {
  static const int maxFileSizeInBytes = 1024 * 1024; // 1MB

  late final CloudinaryPublic _cloudinary;

  CloudinaryStorageService() {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'aconsia_app';
    
    if (cloudName.isEmpty) {
      throw Exception(
        'CLOUDINARY_CLOUD_NAME tidak ditemukan di .env file. '
        'Silakan setup Cloudinary terlebih dahulu.'
      );
    }
    
    _cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
  }

  /// Upload dokter profile photo
  /// Folder: dokter_photos/{uid}
  Future<String> uploadDokterProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    try {
      final compressedFile = await _compressImage(imageFile);

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          compressedFile.path,
          folder: 'dokter_photos/$uid',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception('Gagal upload foto dokter: $e');
    }
  }

  /// Upload pasien profile photo
  /// Folder: pasien_photos/{uid}
  Future<String> uploadPasienProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    try {
      final compressedFile = await _compressImage(imageFile);

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          compressedFile.path,
          folder: 'pasien_photos/$uid',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception('Gagal upload foto pasien: $e');
    }
  }

  /// Upload konten image
  /// Folder: konten_images
  Future<String> uploadKontenImage({
    required File imageFile,
    required String fileName,
  }) async {
    try {
      final compressedFile = await _compressImage(imageFile);

      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          compressedFile.path,
          folder: 'konten_images',
          publicId: fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_'),
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception('Gagal upload gambar konten: $e');
    }
  }

  /// Delete image by URL (Note: Delete requires admin API, tidak available di cloudinary_public)
  /// Untuk delete, bisa pakai Cloudinary Admin API atau manual via dashboard
  Future<void> deleteImage(String imageUrl) async {
    // Note: cloudinary_public package tidak support delete
    // Alternatif:
    // 1. Gunakan Cloudinary Admin API (butuh API secret)
    // 2. Delete manual via Cloudinary dashboard
    // 3. Overwrite dengan gambar baru (recommended untuk profile photo)
    throw UnimplementedError(
        'Delete hanya available via Cloudinary Admin API. Untuk profile photo, cukup overwrite dengan gambar baru.');
  }

  /// Compress image to max 1MB
  Future<File> _compressImage(File file) async {
    final fileSizeInBytes = await file.length();

    // Jika sudah kecil, langsung return
    if (fileSizeInBytes <= maxFileSizeInBytes) {
      return file;
    }

    // Compress dengan quality bertahap
    final dir = path.dirname(file.path);
    final targetPath =
        path.join(dir, 'compressed_${path.basename(file.path)}');

    int quality = 85;
    File? result;

    while (quality > 10) {
      final xFileResult = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      if (xFileResult == null) {
        throw Exception('Gagal compress image');
      }

      result = File(xFileResult.path);
      final compressedSize = await result.length();

      if (compressedSize <= maxFileSizeInBytes) {
        return result;
      }

      quality -= 15;
    }

    return result ?? file;
  }
}
