import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_storage_service.g.dart';

@riverpod
FirebaseStorageService firebaseStorageService(FirebaseStorageServiceRef ref) {
  return FirebaseStorageService();
}

/// Service untuk mengelola upload/delete foto ke Firebase Storage
/// Max size: 1MB, auto-compress sebelum upload
class FirebaseStorageService {
  final FirebaseStorage _storage;
  static const int maxFileSizeInBytes = 1024 * 1024; // 1MB

  FirebaseStorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Upload dokter profile photo dengan auto-compression
  /// Path: dokter_photos/{uid}/profile.jpg
  Future<Either<String, String>> uploadDokterProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    try {
      // Compress image jika ukuran > 1MB
      final compressedFile = await _compressImage(imageFile);

      // Upload ke Firebase Storage
      final fileName = 'profile.jpg';
      final ref = _storage.ref().child('dokter_photos/$uid/$fileName');

      final uploadTask = ref.putFile(compressedFile);
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return Right(downloadUrl);
    } catch (e) {
      return Left('Gagal upload foto: $e');
    }
  }

  /// Upload pasien profile photo dengan auto-compression
  /// Path: pasien_photos/{uid}/profile.jpg
  Future<Either<String, String>> uploadPasienProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    try {
      final compressedFile = await _compressImage(imageFile);

      final fileName = 'profile.jpg';
      final ref = _storage.ref().child('pasien_photos/$uid/$fileName');

      final uploadTask = ref.putFile(compressedFile);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return Right(downloadUrl);
    } catch (e) {
      return Left('Gagal upload foto: $e');
    }
  }

  /// Delete dokter profile photo
  Future<Either<String, Unit>> deleteDokterProfilePhoto({
    required String uid,
  }) async {
    try {
      final ref = _storage.ref().child('dokter_photos/$uid/profile.jpg');
      await ref.delete();
      return const Right(unit);
    } catch (e) {
      return Left('Gagal hapus foto: $e');
    }
  }

  /// Delete pasien profile photo
  Future<Either<String, Unit>> deletePasienProfilePhoto({
    required String uid,
  }) async {
    try {
      final ref = _storage.ref().child('pasien_photos/$uid/profile.jpg');
      await ref.delete();
      return const Right(unit);
    } catch (e) {
      return Left('Gagal hapus foto: $e');
    }
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
    final targetPath = path.join(dir, 'compressed_${path.basename(file.path)}');

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

      // Convert XFile to File
      result = File(xFileResult.path);
      final compressedSize = await result.length();

      if (compressedSize <= maxFileSizeInBytes) {
        return result;
      }

      quality -= 15;
    }

    // Jika masih terlalu besar, return hasil terakhir
    return result ?? file;
  }

  /// Get download URL by path
  Future<Either<String, String>> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      final url = await ref.getDownloadURL();
      return Right(url);
    } catch (e) {
      return Left('Gagal mendapatkan URL: $e');
    }
  }

  /// Helper methods yang throw exception untuk Provider usage
  Future<String> uploadDokterProfilePhotoOrThrow({
    required String uid,
    required File imageFile,
  }) async {
    final result =
        await uploadDokterProfilePhoto(uid: uid, imageFile: imageFile);
    return result.fold(
      (error) => throw Exception(error),
      (url) => url,
    );
  }

  Future<String> uploadPasienProfilePhotoOrThrow({
    required String uid,
    required File imageFile,
  }) async {
    final result =
        await uploadPasienProfilePhoto(uid: uid, imageFile: imageFile);
    return result.fold(
      (error) => throw Exception(error),
      (url) => url,
    );
  }

  Future<String> uploadKontenImageOrThrow({
    required File imageFile,
    required String fileName,
  }) async {
    try {
      final compressedFile = await _compressImage(imageFile);
      final ref = _storage.ref().child('konten_images/$fileName');
      final uploadTask = ref.putFile(compressedFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Gagal upload gambar konten: $e');
    }
  }
}
