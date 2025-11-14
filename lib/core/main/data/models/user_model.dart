import 'package:cloud_firestore/cloud_firestore.dart';
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
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'],
      role: data['role'] ?? '',
      isProfileCompleted: data['isProfileCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(UserModel user) {
    return {
      'email': user.email,
      'name': user.name,
      'role': user.role,
      'isProfileCompleted': user.isProfileCompleted,
      'createdAt': Timestamp.fromDate(user.createdAt),
      'updatedAt': Timestamp.fromDate(user.updatedAt),
    };
  }
}
