class Doctor {
  final String id;
  final String namaLengkap;
  final String email;
  final String password;
  final String nomorSTR;
  final String spesialisasi;
  final String rumahSakit;
  final String createdAt;

  Doctor({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.password,
    required this.nomorSTR,
    required this.spesialisasi,
    required this.rumahSakit,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaLengkap': namaLengkap,
      'email': email,
      'password': password,
      'nomorSTR': nomorSTR,
      'spesialisasi': spesialisasi,
      'rumahSakit': rumahSakit,
      'createdAt': createdAt,
    };
  }

  // Create from JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      namaLengkap: json['namaLengkap'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      nomorSTR: json['nomorSTR'] ?? '',
      spesialisasi: json['spesialisasi'] ?? '',
      rumahSakit: json['rumahSakit'] ?? '',
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }
}
