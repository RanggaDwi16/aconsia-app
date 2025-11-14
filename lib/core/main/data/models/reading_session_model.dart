import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_session_model.freezed.dart';
part 'reading_session_model.g.dart';

/// Model untuk tracking pasien yang sedang membaca konten
/// Digunakan untuk real-time notification di dashboard dokter
@freezed
class ReadingSessionModel with _$ReadingSessionModel {
  const factory ReadingSessionModel({
    required String id,
    required String pasienId, // Reference to pasien_profiles
    required String kontenId, // Reference to konten
    required String sectionId, // Current section being read
    required String dokterId, // Reference to dokter_profiles
    required DateTime startedAt,
    @Default(true) bool isActive, // Still reading?
    DateTime? endedAt,
  }) = _ReadingSessionModel;

  factory ReadingSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ReadingSessionModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory ReadingSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReadingSessionModel(
      id: doc.id,
      pasienId: data['pasienId'] ?? '',
      kontenId: data['kontenId'] ?? '',
      sectionId: data['sectionId'] ?? '',
      dokterId: data['dokterId'] ?? '',
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      endedAt: data['endedAt'] != null
          ? (data['endedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(ReadingSessionModel session) {
    return {
      'pasienId': session.pasienId,
      'kontenId': session.kontenId,
      'sectionId': session.sectionId,
      'dokterId': session.dokterId,
      'startedAt': Timestamp.fromDate(session.startedAt),
      'isActive': session.isActive,
      'endedAt':
          session.endedAt != null ? Timestamp.fromDate(session.endedAt!) : null,
    };
  }
}
