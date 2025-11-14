import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'konten_model.freezed.dart';
part 'konten_model.g.dart';

@freezed
class KontenModel with _$KontenModel {
  const factory KontenModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "dokterId") String? dokterId,
    @JsonKey(name: "judul") String? judul,
    @JsonKey(name: "jenisAnestesi") String? jenisAnestesi,
    @JsonKey(name: "tataCara") String? tataCara,
    @JsonKey(name: "resikoTindakan") String? resikoTindakan,
    @JsonKey(name: "komplikasi") String? komplikasi,
    @JsonKey(name: "indikasiTindakan") String? indikasiTindakan,
    @JsonKey(name: "prognosis") String? prognosis,
    @JsonKey(name: "alternatifLain") String? alternatifLain,
    @JsonKey(name: "gambarUrl") String? gambarUrl,
    @JsonKey(name: "aiKeywords") String? aiKeywords,
    @JsonKey(name: "jumlahBagian") int? jumlahBagian,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _KontenModel;

  factory KontenModel.fromJson(Map<String, dynamic> json) =>
      _$KontenModelFromJson(json);
}
