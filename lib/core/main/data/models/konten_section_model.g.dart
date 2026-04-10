// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'konten_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KontenSectionModelImpl _$$KontenSectionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$KontenSectionModelImpl(
      id: json['id'] as String?,
      kontenId: json['kontenId'] as String?,
      judulBagian: json['judulBagian'] as String?,
      isiKonten: json['isiKonten'] as String?,
      urutan: (json['urutan'] as num?)?.toInt(),
      createdAt: dateTimeFromJson(json['createdAt']),
      updatedAt: dateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$KontenSectionModelImplToJson(
        _$KontenSectionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kontenId': instance.kontenId,
      'judulBagian': instance.judulBagian,
      'isiKonten': instance.isiKonten,
      'urutan': instance.urutan,
      'createdAt': dateTimeToJson(instance.createdAt),
      'updatedAt': dateTimeToJson(instance.updatedAt),
    };
