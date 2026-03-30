class Patient {
  final String mrn;
  final String namaLengkap;
  final String nomorTelepon;
  final String email;
  final String status; // pending, approved, rejected
  final String? anesthesiaType;
  final String? doctorName;
  final String? surgeryDate;
  final int comprehensionScore;
  final String createdAt;
  final String? approvalDate;
  final String? rejectionReason;

  Patient({
    required this.mrn,
    required this.namaLengkap,
    required this.nomorTelepon,
    required this.email,
    this.status = 'pending',
    this.anesthesiaType,
    this.doctorName,
    this.surgeryDate,
    this.comprehensionScore = 0,
    required this.createdAt,
    this.approvalDate,
    this.rejectionReason,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'mrn': mrn,
      'namaLengkap': namaLengkap,
      'nomorTelepon': nomorTelepon,
      'email': email,
      'status': status,
      'anesthesiaType': anesthesiaType,
      'doctorName': doctorName,
      'surgeryDate': surgeryDate,
      'comprehensionScore': comprehensionScore,
      'createdAt': createdAt,
      'approvalDate': approvalDate,
      'rejectionReason': rejectionReason,
    };
  }

  // Create from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      mrn: json['mrn'] ?? '',
      namaLengkap: json['namaLengkap'] ?? '',
      nomorTelepon: json['nomorTelepon'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? 'pending',
      anesthesiaType: json['anesthesiaType'],
      doctorName: json['doctorName'],
      surgeryDate: json['surgeryDate'],
      comprehensionScore: json['comprehensionScore'] ?? 0,
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      approvalDate: json['approvalDate'],
      rejectionReason: json['rejectionReason'],
    );
  }

  // Copy with
  Patient copyWith({
    String? mrn,
    String? namaLengkap,
    String? nomorTelepon,
    String? email,
    String? status,
    String? anesthesiaType,
    String? doctorName,
    String? surgeryDate,
    int? comprehensionScore,
    String? createdAt,
    String? approvalDate,
    String? rejectionReason,
  }) {
    return Patient(
      mrn: mrn ?? this.mrn,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      email: email ?? this.email,
      status: status ?? this.status,
      anesthesiaType: anesthesiaType ?? this.anesthesiaType,
      doctorName: doctorName ?? this.doctorName,
      surgeryDate: surgeryDate ?? this.surgeryDate,
      comprehensionScore: comprehensionScore ?? this.comprehensionScore,
      createdAt: createdAt ?? this.createdAt,
      approvalDate: approvalDate ?? this.approvalDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
