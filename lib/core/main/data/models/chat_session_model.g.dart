// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatSessionModelImpl _$$ChatSessionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatSessionModelImpl(
      id: json['id'] as String,
      pasienId: json['pasienId'] as String,
      dokterId: json['dokterId'] as String,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      unreadCountPasien: (json['unreadCountPasien'] as num?)?.toInt() ?? 0,
      unreadCountDokter: (json['unreadCountDokter'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChatSessionModelImplToJson(
        _$ChatSessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pasienId': instance.pasienId,
      'dokterId': instance.dokterId,
      'lastMessage': instance.lastMessage,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'unreadCountPasien': instance.unreadCountPasien,
      'unreadCountDokter': instance.unreadCountDokter,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
