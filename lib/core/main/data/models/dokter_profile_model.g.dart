// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dokter_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DokterProfileModelImpl _$$DokterProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DokterProfileModelImpl(
      uid: json['uid'] as String?,
      namaLengkap: json['fullName'] as String?,
      nomorStr: json['strNumber'] as String?,
      nomorSip: json['sipNumber'] as String?,
      spesialisasi: json['specialization'] as String?,
      hospitalName: json['hospitalName'] as String?,
      status: json['status'] as String?,
      tanggalGabung: json['tanggalGabung'] as String?,
      tempatLahir: json['tempatLahir'] as String?,
      tanggalLahir: json['tanggalLahir'] as String?,
      jenisKelamin: json['jenisKelamin'] as String?,
      email: json['email'] as String?,
      nomorTelepon: json['nomorTelepon'] as String?,
      fotoProfilUrl: json['fotoProfilUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$DokterProfileModelImplToJson(
        _$DokterProfileModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.namaLengkap,
      'strNumber': instance.nomorStr,
      'sipNumber': instance.nomorSip,
      'specialization': instance.spesialisasi,
      'hospitalName': instance.hospitalName,
      'status': instance.status,
      'tanggalGabung': instance.tanggalGabung,
      'tempatLahir': instance.tempatLahir,
      'tanggalLahir': instance.tanggalLahir,
      'jenisKelamin': instance.jenisKelamin,
      'email': instance.email,
      'nomorTelepon': instance.nomorTelepon,
      'fotoProfilUrl': instance.fotoProfilUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
