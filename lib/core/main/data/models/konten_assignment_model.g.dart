// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'konten_assignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KontenAssignmentModelImpl _$$KontenAssignmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$KontenAssignmentModelImpl(
      id: json['id'] as String,
      pasienId: json['pasienId'] as String,
      kontenId: json['kontenId'] as String,
      assignedBy: json['assignedBy'] as String,
      assignedAt: DateTime.parse(json['assignedAt'] as String),
      currentBagian: (json['currentBagian'] as num?)?.toInt() ?? 1,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$KontenAssignmentModelImplToJson(
        _$KontenAssignmentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pasienId': instance.pasienId,
      'kontenId': instance.kontenId,
      'assignedBy': instance.assignedBy,
      'assignedAt': instance.assignedAt.toIso8601String(),
      'currentBagian': instance.currentBagian,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
