// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReadingSessionModelImpl _$$ReadingSessionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReadingSessionModelImpl(
      id: json['id'] as String,
      pasienId: json['pasienId'] as String,
      kontenId: json['kontenId'] as String,
      sectionId: json['sectionId'] as String,
      dokterId: json['dokterId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
    );

Map<String, dynamic> _$$ReadingSessionModelImplToJson(
        _$ReadingSessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pasienId': instance.pasienId,
      'kontenId': instance.kontenId,
      'sectionId': instance.sectionId,
      'dokterId': instance.dokterId,
      'startedAt': instance.startedAt.toIso8601String(),
      'isActive': instance.isActive,
      'endedAt': instance.endedAt?.toIso8601String(),
    };
