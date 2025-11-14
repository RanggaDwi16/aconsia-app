// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'konten_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KontenModelImpl _$$KontenModelImplFromJson(Map<String, dynamic> json) =>
    _$KontenModelImpl(
      id: json['id'] as String?,
      dokterId: json['dokterId'] as String?,
      judul: json['judul'] as String?,
      jenisAnestesi: json['jenisAnestesi'] as String?,
      tataCara: json['tataCara'] as String?,
      resikoTindakan: json['resikoTindakan'] as String?,
      komplikasi: json['komplikasi'] as String?,
      indikasiTindakan: json['indikasiTindakan'] as String?,
      prognosis: json['prognosis'] as String?,
      alternatifLain: json['alternatifLain'] as String?,
      gambarUrl: json['gambarUrl'] as String?,
      aiKeywords: json['aiKeywords'] as String?,
      jumlahBagian: (json['jumlahBagian'] as num?)?.toInt(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$KontenModelImplToJson(_$KontenModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dokterId': instance.dokterId,
      'judul': instance.judul,
      'jenisAnestesi': instance.jenisAnestesi,
      'tataCara': instance.tataCara,
      'resikoTindakan': instance.resikoTindakan,
      'komplikasi': instance.komplikasi,
      'indikasiTindakan': instance.indikasiTindakan,
      'prognosis': instance.prognosis,
      'alternatifLain': instance.alternatifLain,
      'gambarUrl': instance.gambarUrl,
      'aiKeywords': instance.aiKeywords,
      'jumlahBagian': instance.jumlahBagian,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
