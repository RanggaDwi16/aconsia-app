// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      role: json['role'] as String,
      isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'isProfileCompleted': instance.isProfileCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
