import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aconsia_app/core/utils/role_normalizer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    String? name, // Nullable name
    required String role, // 'dokter' or 'pasien'
    @Default(false) bool isProfileCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};

    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? data['displayName'],
      role: normalizeRole(data['role']?.toString()),
      isProfileCompleted: data['isProfileCompleted'] ?? false,
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt']),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(UserModel user) {
    return {
      'email': user.email,
      'name': user.name,
      'role': normalizeRole(user.role),
      'isProfileCompleted': user.isProfileCompleted,
      'createdAt': Timestamp.fromDate(user.createdAt),
      'updatedAt': Timestamp.fromDate(user.updatedAt),
    };
  }
}
