enum PasienProfileFailureCode {
  permissionDenied,
  notFound,
  invalidArgument,
  unknown,
}

class PasienProfileFailure {
  const PasienProfileFailure({
    required this.code,
    required this.message,
    this.raw,
  });

  final PasienProfileFailureCode code;
  final String message;
  final Object? raw;

  bool get isPermissionDenied =>
      code == PasienProfileFailureCode.permissionDenied;

  bool get isNotFound => code == PasienProfileFailureCode.notFound;

  static const String _permissionDeniedTag = '[permissionDenied]';
  static const String _notFoundTag = '[notFound]';
  static const String _invalidArgumentTag = '[invalidArgument]';
  static const String _unknownTag = '[unknown]';

  static PasienProfileFailure fromRaw(Object raw) {
    if (raw is PasienProfileFailure) return raw;
    final text = raw.toString();
    final lower = text.toLowerCase();

    if (text.startsWith(_permissionDeniedTag) ||
        lower.contains('permission-denied')) {
      return PasienProfileFailure(
        code: PasienProfileFailureCode.permissionDenied,
        message: _stripTag(text, _permissionDeniedTag).isEmpty
            ? 'Anda tidak memiliki akses ke data pasien ini.'
            : _stripTag(text, _permissionDeniedTag),
        raw: raw,
      );
    }

    if (text.startsWith(_notFoundTag) || lower.contains('not found')) {
      return PasienProfileFailure(
        code: PasienProfileFailureCode.notFound,
        message: _stripTag(text, _notFoundTag).isEmpty
            ? 'Profil pasien tidak ditemukan.'
            : _stripTag(text, _notFoundTag),
        raw: raw,
      );
    }

    if (text.startsWith(_invalidArgumentTag) || lower.contains('invalid')) {
      return PasienProfileFailure(
        code: PasienProfileFailureCode.invalidArgument,
        message: _stripTag(text, _invalidArgumentTag).isEmpty
            ? 'Parameter pasien tidak valid.'
            : _stripTag(text, _invalidArgumentTag),
        raw: raw,
      );
    }

    return PasienProfileFailure(
      code: PasienProfileFailureCode.unknown,
      message: _stripTag(text, _unknownTag).isEmpty
          ? 'Gagal memuat detail pasien. Silakan coba lagi.'
          : _stripTag(text, _unknownTag),
      raw: raw,
    );
  }

  static String _stripTag(String text, String tag) {
    if (text.startsWith(tag)) {
      return text.replaceFirst(tag, '').trim();
    }
    return text.trim();
  }
}
