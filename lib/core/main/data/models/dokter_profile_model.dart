import 'package:freezed_annotation/freezed_annotation.dart';

part 'dokter_profile_model.freezed.dart';
part 'dokter_profile_model.g.dart';

@freezed
class DokterProfileModel with _$DokterProfileModel {
  const factory DokterProfileModel({
    @JsonKey(name: "uid") String? uid,
    @JsonKey(name: "fullName") String? namaLengkap,
    @JsonKey(name: "strNumber") String? nomorStr,
    @JsonKey(name: "sipNumber") String? nomorSip,
    @JsonKey(name: "specialization") String? spesialisasi,
    @JsonKey(name: "hospitalName") String? hospitalName,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "tanggalGabung") String? tanggalGabung,
    @JsonKey(name: "tempatLahir") String? tempatLahir,
    @JsonKey(name: "tanggalLahir") String? tanggalLahir,
    @JsonKey(name: "jenisKelamin") String? jenisKelamin,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "nomorTelepon") String? nomorTelepon,
    @JsonKey(name: "fotoProfilUrl") String? fotoProfilUrl,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _DokterProfileModel;

  factory DokterProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DokterProfileModelFromJson(json);
}
