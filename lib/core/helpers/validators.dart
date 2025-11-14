class Validators {
  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Password Validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Required Field Validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  // Link Validator (for URLs)
  static String? validateLink(String? value) {
    if (value == null || value.isEmpty) {
      return 'Link tidak boleh kosong';
    }
    if (!value.startsWith('https://')) {
      return 'Input link harus diawali dengan https://';
    }
    return null;
  }

  static String? validateNamaPemilikLahan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }

    // Hanya huruf dan spasi
    if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$').hasMatch(value)) {
      return 'Nama lengkap hanya boleh mengandung huruf';
    }

    // Panjang karakter 1–50
    if (value.trim().isEmpty || value.trim().length > 50) {
      return 'Nama lengkap terdiri dari 1 hingga 50 karakter';
    }

    return null;
  }

  static String? validateNomorHp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor handphone tidak boleh kosong';
    }

    // Hanya boleh angka
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor handphone hanya boleh berisi angka';
    }

    // Harus diawali angka 8
    if (!value.startsWith('8')) {
      return 'Nomor handphone harus diawali dengan angka 8';
    }

    // Panjang nomor HP setelah 8: minimal 9 digit (total 10 termasuk 8), maksimal 12 digit
    if (value.length < 10 || value.length > 13) {
      return 'Nomor hp terdiri dari 10 hingga 15 digit';
    }

    return null;
  }

  //validator nomor KTP
  static String? validateNomorKtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor KTP tidak boleh kosong';
    }

    // Hanya boleh angka
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor KTP hanya boleh berisi angka';
    }

    // Panjang nomor KTP: 16 digit
    if (value.length != 16) {
      return 'Nomor KTP harus terdiri dari 16 digit';
    }

    return null;
  }

  static String? validateAlamatLahan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat lahan tidak boleh kosong';
    }
    if (value.length > 255) {
      return 'Alamat lahan tidak melebihi 255 karakter';
    }
    return null;
  }

  static String? validateLuasKepemilikanLahan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Luas kepemilikan lahan tidak boleh kosong';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Luas kepemilikan lahan harus berupa angka dengan maksimal 2 angka di belakang titik';
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'Luas kepemilikan lahan harus lebih dari 0';
    }

    final integerPart = value.split('.').first;
    if (integerPart.isEmpty || integerPart.length > 4) {
      return 'Luas kepemilikan terdiri 1 hingga 4 digit';
    }
    return null;
  }

  static String? validateLuasLahanDigarap(String? value) {
    if (value == null || value.isEmpty) {
      return 'Luas lahan yang digarap tidak boleh kosong';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Luas lahan yang digarap harus berupa angka dengan maksimal 2 angka di belakang titik';
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'Luas lahan yang digarap harus lebih dari 0';
    }

    final integerPart = value.split('.').first;
    if (integerPart.isEmpty || integerPart.length > 4) {
      return 'Luas lahan terdiri 1 hingga 4 digit';
    }
    return null;
  }

  static String? validateJarakSumberAir(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jarak sumber air tidak boleh kosong';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Jarak sumber air harus berupa angka dengan maksimal 2 angka di belakang titik';
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'Jarak sumber air harus lebih dari 0';
    }

    final integerPart = value.split('.').first;
    if (integerPart.isEmpty || integerPart.length > 4) {
      return 'Jarak sumber air terdiri 1 hingga 4 digit';
    }
    return null;
  }

  static String? validateCatatanTambahan(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 255) {
        return 'Catatan tambahan tidak melebihi 255 karakter';
      }
    }
    return null; // ✅ valid kalau kosong atau panjangnya <= 255
  }

  static String? validateHistoricalPanen(String? value) {
    if (value == null || value.isEmpty) {
      return 'Historical panen tidak boleh kosong';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Historical panen harus berupa angka dengan maksimal 2 angka di belakang titik';
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'Historical panen harus lebih dari 0';
    }

    final integerPart = value.split('.').first;
    if (integerPart.isEmpty || integerPart.length > 4) {
      return 'Historical panen terdiri dari 1 hingga 4 digit';
    }
    return null;
  }

  static String? validateSeranganHama(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Serangan hama tidak boleh kosong';
    }
    if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$').hasMatch(value)) {
      return 'Serangan hama hanya boleh mengandung huruf';
    }
    if (value.trim().length > 50) {
      return 'Serangan hama terdiri dari 1 hingga 50 karakter';
    }
    return null;
  }

  // Takaran Dolomit
  static String? validateTakaranDolomit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Takaran dolomit tidak boleh kosong';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Takaran dolomit harus berupa angka dengan maksimal 2 angka di belakang titik';
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'Takaran dolomit harus lebih dari 0';
    }

    final integerPart = value.split('.').first;
    if (integerPart.isEmpty || integerPart.length > 4) {
      return 'Takaran dolomit terdiri 1 hingga 4 digit';
    }
    return null;
  }

  // PH Tanah
  static String? validatePhTanah(String? value) {
    if (value == null || value.isEmpty) {
      return 'PH tanah tidak boleh kosong';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'PH tanah harus berupa angka dengan maksimal 2 angka di belakang titik';
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0 || doubleValue > 14) {
      return 'PH tanah harus antara 0 hingga 14';
    }

    final integerPart = value.split('.').first;
    if (integerPart.isEmpty || integerPart.length > 2) {
      return 'PH tanah terdiri dari 1 hingga 2 digit';
    }
    return null;
  }

  // Takaran Pupuk Kandang
  static String? validateTakaranPupukKandang(String? value) {
    if (value == null || value.isEmpty) {
      return 'Takaran pupuk kandang tidak boleh kosong';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
      return 'Takaran pupuk kandang harus berupa angka dengan maksimal 2 angka di belakang titik';
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'Takaran pupuk kandang harus lebih dari 0';
    }

    final integerPart = value.split('.').first;
    if (integerPart.isEmpty || integerPart.length > 4) {
      return 'Takaran pupuk kandang terdiri 1 hingga 4 digit';
    }
    return null;
  }

  // Potensi Kendala / Historical Budidaya
  static String? validatePotensiKendala(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Potensi kendala tidak boleh kosong';
    }
    if (value.trim().length > 255) {
      return 'Potensi kendala/Historical budidaya tidak melebihi 255 karakter';
    }
    return null;
  }

  // Catatan Rekomendasi
  static String? validateCatatanRekomendasi(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Catatan rekomendasi tidak boleh kosong';
    }
    if (value.trim().length > 255) {
      return 'Catatan rekomendasi tidak melebihi 255 karakter';
    }
    return null;
  }

  // Alasan Penolakan
  static String? validateAlasanPenolakan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alasan penolakan tidak boleh kosong';
    }

    if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$').hasMatch(value)) {
      return 'Alasan penolakan hanya boleh mengandung huruf';
    }
    if (value.trim().length > 255) {
      return 'Alasan penolakan tidak melebihi 255 karakter';
    }
    return null;
  }
}
