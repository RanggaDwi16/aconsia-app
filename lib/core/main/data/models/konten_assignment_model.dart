import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'konten_assignment_model.freezed.dart';
part 'konten_assignment_model.g.dart';

@freezed
class KontenAssignmentModel with _$KontenAssignmentModel {
  const factory KontenAssignmentModel({
    required String id,
    required String pasienId, // Reference to pasien_profiles collection
    required String kontenId, // Reference to konten collection
    required String assignedBy, // Dokter ID who assigned
    required DateTime assignedAt,
    @Default(1) int currentBagian, // Current section being read (1, 2, 3...)
    @Default(false) bool isCompleted, // All sections read?
    DateTime? completedAt,
    required DateTime updatedAt,
  }) = _KontenAssignmentModel;

  factory KontenAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$KontenAssignmentModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory KontenAssignmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KontenAssignmentModel(
      id: doc.id,
      pasienId: data['pasienId'] ?? '',
      kontenId: data['kontenId'] ?? '',
      assignedBy: data['assignedBy'] ?? '',
      assignedAt: (data['assignedAt'] as Timestamp).toDate(),
      currentBagian: data['currentBagian'] ?? 1,
      isCompleted: data['isCompleted'] ?? false,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(KontenAssignmentModel assignment) {
    return {
      'pasienId': assignment.pasienId,
      'kontenId': assignment.kontenId,
      'assignedBy': assignment.assignedBy,
      'assignedAt': Timestamp.fromDate(assignment.assignedAt),
      'currentBagian': assignment.currentBagian,
      'isCompleted': assignment.isCompleted,
      'completedAt': assignment.completedAt != null
          ? Timestamp.fromDate(assignment.completedAt!)
          : null,
      'updatedAt': Timestamp.fromDate(assignment.updatedAt),
    };
  }
}
