import 'package:aconsia_app/core/helpers/timestamp/timestamp_convert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pasien_profile_model.freezed.dart';
part 'pasien_profile_model.g.dart';

@freezed
class PasienProfileModel with _$PasienProfileModel {
  const factory PasienProfileModel({
    @JsonKey(name: "uid") String? uid,
    @JsonKey(name: "dokterId") String? dokterId,
    @JsonKey(name: "namaLengkap") String? namaLengkap,
    @JsonKey(name: "nomorTelepon") String? nomorTelepon,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "fotoProfilUrl") String? fotoProfilUrl,
    @JsonKey(name: "noRekamMedis") String? noRekamMedis,
    @JsonKey(name: "nik") String? nik,

    // 🔹 Gunakan converter kamu di sini
    @JsonKey(
      name: "tanggalLahir",
      fromJson: timestampFromJson,
      toJson: timestampToJson,
    )
    Timestamp? tanggalLahir,
    @JsonKey(name: "jenisKelamin") String? jenisKelamin,
    @JsonKey(name: "agama") String? agama,
    @JsonKey(name: "statusPernikahan") String? statusPernikahan,
    @JsonKey(name: "pendidikanTerakhir") String? pendidikanTerakhir,
    @JsonKey(name: "pekerjaan") String? pekerjaan,
    @JsonKey(name: "alamatLengkap") String? alamatLengkap,
    @JsonKey(name: "rt") String? rt,
    @JsonKey(name: "rw") String? rw,
    @JsonKey(name: "kelurahanDesa") String? kelurahanDesa,
    @JsonKey(name: "kecamatan") String? kecamatan,
    @JsonKey(name: "kotaKabupaten") String? kotaKabupaten,
    @JsonKey(name: "provinsi") String? provinsi,
    @JsonKey(name: "tempatLahir") String? tempatLahir,
    @JsonKey(name: "jenisOperasi") String? jenisOperasi,
    @JsonKey(name: "jenisAnestesi") String? jenisAnestesi,
    @JsonKey(name: "klasifikasiASA") String? klasifikasiAsa,
    @JsonKey(name: "tinggiBadan") double? tinggiBadan,
    @JsonKey(name: "beratBadan") double? beratBadan,
    @JsonKey(name: "namaWali") String? namaWali,
    @JsonKey(name: "hubunganWali") String? hubunganWali,
    @JsonKey(name: "nomorHpWali") String? nomorHpWali,
    @JsonKey(name: "alamatWali") String? alamatWali,
    @JsonKey(name: "kontenFavoritIds") List<String>? kontenFavoritIds,
    @JsonKey(name: "aiKeywords") List<String>? aiKeywords,
    @JsonKey(name: "assessmentCompleted")
    @Default(false)
    bool assessmentCompleted,
    @JsonKey(name: "preOperativeAssessment")
    Map<String, dynamic>? preOperativeAssessment,
    @JsonKey(
      name: "preOperativeAssessmentUpdatedAt",
      fromJson: timestampFromJson,
      toJson: timestampToJson,
    )
    Timestamp? preOperativeAssessmentUpdatedAt,

    // 🔹 Gunakan converter juga di timestamp lain
    @JsonKey(
      name: "createdAt",
      fromJson: timestampFromJson,
      toJson: timestampToJson,
    )
    Timestamp? createdAt,
    @JsonKey(
      name: "updatedAt",
      fromJson: timestampFromJson,
      toJson: timestampToJson,
    )
    Timestamp? updatedAt,
  }) = _PasienProfileModel;

  factory PasienProfileModel.fromJson(Map<String, dynamic> json) =>
      _$PasienProfileModelFromJson(json);
}
