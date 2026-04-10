import 'package:aconsia_app/core/helpers/timestamp/timestamp_convert.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'konten_section_model.freezed.dart';
part 'konten_section_model.g.dart';

@freezed
class KontenSectionModel with _$KontenSectionModel {
  const factory KontenSectionModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "kontenId") String? kontenId,
    @JsonKey(name: "judulBagian") String? judulBagian,
    @JsonKey(name: "isiKonten") String? isiKonten,
    @JsonKey(name: "urutan") int? urutan,
    @JsonKey(
      name: "createdAt",
      fromJson: dateTimeFromJson,
      toJson: dateTimeToJson,
    )
    DateTime? createdAt,
    @JsonKey(
      name: "updatedAt",
      fromJson: dateTimeFromJson,
      toJson: dateTimeToJson,
    )
    DateTime? updatedAt,
  }) = _KontenSectionModel;

  factory KontenSectionModel.fromJson(Map<String, dynamic> json) =>
      _$KontenSectionModelFromJson(json);
      
}
