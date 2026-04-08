// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pasien_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasienProfileModelImpl _$$PasienProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PasienProfileModelImpl(
      uid: json['uid'] as String?,
      dokterId: json['dokterId'] as String?,
      namaLengkap: json['namaLengkap'] as String?,
      nomorTelepon: json['nomorTelepon'] as String?,
      email: json['email'] as String?,
      fotoProfilUrl: json['fotoProfilUrl'] as String?,
      noRekamMedis: json['noRekamMedis'] as String?,
      nik: json['nik'] as String?,
      tanggalLahir: timestampFromJson(json['tanggalLahir']),
      jenisKelamin: json['jenisKelamin'] as String?,
      agama: json['agama'] as String?,
      statusPernikahan: json['statusPernikahan'] as String?,
      pendidikanTerakhir: json['pendidikanTerakhir'] as String?,
      pekerjaan: json['pekerjaan'] as String?,
      alamatLengkap: json['alamatLengkap'] as String?,
      rt: json['rt'] as String?,
      rw: json['rw'] as String?,
      kelurahanDesa: json['kelurahanDesa'] as String?,
      kecamatan: json['kecamatan'] as String?,
      kotaKabupaten: json['kotaKabupaten'] as String?,
      provinsi: json['provinsi'] as String?,
      tempatLahir: json['tempatLahir'] as String?,
      jenisOperasi: json['jenisOperasi'] as String?,
      jenisAnestesi: json['jenisAnestesi'] as String?,
      klasifikasiAsa: json['klasifikasiASA'] as String?,
      tinggiBadan: (json['tinggiBadan'] as num?)?.toDouble(),
      beratBadan: (json['beratBadan'] as num?)?.toDouble(),
      namaWali: json['namaWali'] as String?,
      hubunganWali: json['hubunganWali'] as String?,
      nomorHpWali: json['nomorHpWali'] as String?,
      alamatWali: json['alamatWali'] as String?,
      kontenFavoritIds: (json['kontenFavoritIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      aiKeywords: (json['aiKeywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: timestampFromJson(json['createdAt']),
      updatedAt: timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PasienProfileModelImplToJson(
        _$PasienProfileModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'dokterId': instance.dokterId,
      'namaLengkap': instance.namaLengkap,
      'nomorTelepon': instance.nomorTelepon,
      'email': instance.email,
      'fotoProfilUrl': instance.fotoProfilUrl,
      'noRekamMedis': instance.noRekamMedis,
      'nik': instance.nik,
      'tanggalLahir': timestampToJson(instance.tanggalLahir),
      'jenisKelamin': instance.jenisKelamin,
      'agama': instance.agama,
      'statusPernikahan': instance.statusPernikahan,
      'pendidikanTerakhir': instance.pendidikanTerakhir,
      'pekerjaan': instance.pekerjaan,
      'alamatLengkap': instance.alamatLengkap,
      'rt': instance.rt,
      'rw': instance.rw,
      'kelurahanDesa': instance.kelurahanDesa,
      'kecamatan': instance.kecamatan,
      'kotaKabupaten': instance.kotaKabupaten,
      'provinsi': instance.provinsi,
      'tempatLahir': instance.tempatLahir,
      'jenisOperasi': instance.jenisOperasi,
      'jenisAnestesi': instance.jenisAnestesi,
      'klasifikasiASA': instance.klasifikasiAsa,
      'tinggiBadan': instance.tinggiBadan,
      'beratBadan': instance.beratBadan,
      'namaWali': instance.namaWali,
      'hubunganWali': instance.hubunganWali,
      'nomorHpWali': instance.nomorHpWali,
      'alamatWali': instance.alamatWali,
      'kontenFavoritIds': instance.kontenFavoritIds,
      'aiKeywords': instance.aiKeywords,
      'createdAt': timestampToJson(instance.createdAt),
      'updatedAt': timestampToJson(instance.updatedAt),
    };
