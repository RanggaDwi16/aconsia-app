import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base class untuk semua failures di aplikasi
@freezed
class Failure with _$Failure {
  // Firebase Auth Failures
  const factory Failure.auth({
    required String message,
    String? code,
  }) = AuthFailure;

  // Firestore Failures
  const factory Failure.firestore({
    required String message,
    String? code,
  }) = FirestoreFailure;

  // Network Failures
  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  // Cloudinary Upload Failures
  const factory Failure.imageUpload({
    required String message,
  }) = ImageUploadFailure;

  // Validation Failures
  const factory Failure.validation({
    required String message,
    Map<String, String>? fieldErrors,
  }) = ValidationFailure;

  // Not Found Failures
  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  // Permission Denied Failures
  const factory Failure.permissionDenied({
    required String message,
  }) = PermissionDeniedFailure;

  // Server Failures (Cloud Functions)
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  // Unknown/Unexpected Failures
  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;
}

/// Extension untuk convert Exception ke Failure
extension ExceptionToFailure on Exception {
  Failure toFailure() {
    final message = toString();

    // Firebase Auth errors
    if (message.contains('firebase_auth')) {
      return Failure.auth(
        message: _parseFirebaseAuthError(message),
        code: _extractErrorCode(message),
      );
    }

    // Firestore errors
    if (message.contains('cloud_firestore') || message.contains('firestore')) {
      return Failure.firestore(
        message: _parseFirestoreError(message),
        code: _extractErrorCode(message),
      );
    }

    // Network errors
    if (message.contains('network') || message.contains('socket')) {
      return Failure.network(
        message: 'Tidak ada koneksi internet. Periksa koneksi Anda.',
      );
    }

    // Permission denied
    if (message.contains('permission') || message.contains('denied')) {
      return Failure.permissionDenied(
        message: 'Anda tidak memiliki izin untuk mengakses data ini.',
      );
    }

    // Default unknown error
    return Failure.unknown(message: message);
  }

  String _parseFirebaseAuthError(String error) {
    if (error.contains('user-not-found')) {
      return 'Email tidak terdaftar.';
    } else if (error.contains('wrong-password')) {
      return 'Password salah.';
    } else if (error.contains('email-already-in-use')) {
      return 'Email sudah digunakan.';
    } else if (error.contains('weak-password')) {
      return 'Password terlalu lemah. Minimal 6 karakter.';
    } else if (error.contains('invalid-email')) {
      return 'Format email tidak valid.';
    } else if (error.contains('too-many-requests')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    }
    return 'Terjadi kesalahan autentikasi.';
  }

  String _parseFirestoreError(String error) {
    if (error.contains('not-found')) {
      return 'Data tidak ditemukan.';
    } else if (error.contains('already-exists')) {
      return 'Data sudah ada.';
    } else if (error.contains('permission-denied')) {
      return 'Akses ditolak.';
    } else if (error.contains('unavailable')) {
      return 'Layanan tidak tersedia. Coba lagi nanti.';
    }
    return 'Terjadi kesalahan database.';
  }

  String? _extractErrorCode(String error) {
    final codeMatch = RegExp(r'\[(.*?)\]').firstMatch(error);
    return codeMatch?.group(1);
  }
}
