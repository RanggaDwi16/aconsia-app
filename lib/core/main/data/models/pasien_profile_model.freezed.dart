// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pasien_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PasienProfileModel _$PasienProfileModelFromJson(Map<String, dynamic> json) {
  return _PasienProfileModel.fromJson(json);
}

/// @nodoc
mixin _$PasienProfileModel {
  @JsonKey(name: "uid")
  String? get uid => throw _privateConstructorUsedError;
  @JsonKey(name: "dokterId")
  String? get dokterId => throw _privateConstructorUsedError;
  @JsonKey(name: "namaLengkap")
  String? get namaLengkap => throw _privateConstructorUsedError;
  @JsonKey(name: "nomorTelepon")
  String? get nomorTelepon => throw _privateConstructorUsedError;
  @JsonKey(name: "email")
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: "fotoProfilUrl")
  String? get fotoProfilUrl => throw _privateConstructorUsedError;
  @JsonKey(name: "noRekamMedis")
  String? get noRekamMedis => throw _privateConstructorUsedError;
  @JsonKey(name: "nik")
  String? get nik =>
      throw _privateConstructorUsedError; // 🔹 Gunakan converter kamu di sini
  @JsonKey(
      name: "tanggalLahir",
      fromJson: timestampFromJson,
      toJson: timestampToJson)
  Timestamp? get tanggalLahir => throw _privateConstructorUsedError;
  @JsonKey(name: "jenisKelamin")
  String? get jenisKelamin => throw _privateConstructorUsedError;
  @JsonKey(name: "agama")
  String? get agama => throw _privateConstructorUsedError;
  @JsonKey(name: "statusPernikahan")
  String? get statusPernikahan => throw _privateConstructorUsedError;
  @JsonKey(name: "pendidikanTerakhir")
  String? get pendidikanTerakhir => throw _privateConstructorUsedError;
  @JsonKey(name: "pekerjaan")
  String? get pekerjaan => throw _privateConstructorUsedError;
  @JsonKey(name: "alamatLengkap")
  String? get alamatLengkap => throw _privateConstructorUsedError;
  @JsonKey(name: "rt")
  String? get rt => throw _privateConstructorUsedError;
  @JsonKey(name: "rw")
  String? get rw => throw _privateConstructorUsedError;
  @JsonKey(name: "kelurahanDesa")
  String? get kelurahanDesa => throw _privateConstructorUsedError;
  @JsonKey(name: "kecamatan")
  String? get kecamatan => throw _privateConstructorUsedError;
  @JsonKey(name: "kotaKabupaten")
  String? get kotaKabupaten => throw _privateConstructorUsedError;
  @JsonKey(name: "provinsi")
  String? get provinsi => throw _privateConstructorUsedError;
  @JsonKey(name: "tempatLahir")
  String? get tempatLahir => throw _privateConstructorUsedError;
  @JsonKey(name: "jenisOperasi")
  String? get jenisOperasi => throw _privateConstructorUsedError;
  @JsonKey(name: "jenisAnestesi")
  String? get jenisAnestesi => throw _privateConstructorUsedError;
  @JsonKey(name: "klasifikasiASA")
  String? get klasifikasiAsa => throw _privateConstructorUsedError;
  @JsonKey(name: "tinggiBadan")
  double? get tinggiBadan => throw _privateConstructorUsedError;
  @JsonKey(name: "beratBadan")
  double? get beratBadan => throw _privateConstructorUsedError;
  @JsonKey(name: "namaWali")
  String? get namaWali => throw _privateConstructorUsedError;
  @JsonKey(name: "hubunganWali")
  String? get hubunganWali => throw _privateConstructorUsedError;
  @JsonKey(name: "nomorHpWali")
  String? get nomorHpWali => throw _privateConstructorUsedError;
  @JsonKey(name: "alamatWali")
  String? get alamatWali => throw _privateConstructorUsedError;
  @JsonKey(name: "kontenFavoritIds")
  List<String>? get kontenFavoritIds => throw _privateConstructorUsedError;
  @JsonKey(name: "aiKeywords")
  List<String>? get aiKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: "assessmentCompleted")
  bool get assessmentCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: "preOperativeAssessment")
  Map<String, dynamic>? get preOperativeAssessment =>
      throw _privateConstructorUsedError;
  @JsonKey(
      name: "preOperativeAssessmentUpdatedAt",
      fromJson: timestampFromJson,
      toJson: timestampToJson)
  Timestamp? get preOperativeAssessmentUpdatedAt =>
      throw _privateConstructorUsedError; // 🔹 Gunakan converter juga di timestamp lain
  @JsonKey(
      name: "createdAt", fromJson: timestampFromJson, toJson: timestampToJson)
  Timestamp? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: "updatedAt", fromJson: timestampFromJson, toJson: timestampToJson)
  Timestamp? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PasienProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasienProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasienProfileModelCopyWith<PasienProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasienProfileModelCopyWith<$Res> {
  factory $PasienProfileModelCopyWith(
          PasienProfileModel value, $Res Function(PasienProfileModel) then) =
      _$PasienProfileModelCopyWithImpl<$Res, PasienProfileModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "uid") String? uid,
      @JsonKey(name: "dokterId") String? dokterId,
      @JsonKey(name: "namaLengkap") String? namaLengkap,
      @JsonKey(name: "nomorTelepon") String? nomorTelepon,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "fotoProfilUrl") String? fotoProfilUrl,
      @JsonKey(name: "noRekamMedis") String? noRekamMedis,
      @JsonKey(name: "nik") String? nik,
      @JsonKey(
          name: "tanggalLahir",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
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
      @JsonKey(name: "assessmentCompleted") bool assessmentCompleted,
      @JsonKey(name: "preOperativeAssessment")
      Map<String, dynamic>? preOperativeAssessment,
      @JsonKey(
          name: "preOperativeAssessmentUpdatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      Timestamp? preOperativeAssessmentUpdatedAt,
      @JsonKey(
          name: "createdAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      Timestamp? createdAt,
      @JsonKey(
          name: "updatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      Timestamp? updatedAt});
}

/// @nodoc
class _$PasienProfileModelCopyWithImpl<$Res, $Val extends PasienProfileModel>
    implements $PasienProfileModelCopyWith<$Res> {
  _$PasienProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasienProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? dokterId = freezed,
    Object? namaLengkap = freezed,
    Object? nomorTelepon = freezed,
    Object? email = freezed,
    Object? fotoProfilUrl = freezed,
    Object? noRekamMedis = freezed,
    Object? nik = freezed,
    Object? tanggalLahir = freezed,
    Object? jenisKelamin = freezed,
    Object? agama = freezed,
    Object? statusPernikahan = freezed,
    Object? pendidikanTerakhir = freezed,
    Object? pekerjaan = freezed,
    Object? alamatLengkap = freezed,
    Object? rt = freezed,
    Object? rw = freezed,
    Object? kelurahanDesa = freezed,
    Object? kecamatan = freezed,
    Object? kotaKabupaten = freezed,
    Object? provinsi = freezed,
    Object? tempatLahir = freezed,
    Object? jenisOperasi = freezed,
    Object? jenisAnestesi = freezed,
    Object? klasifikasiAsa = freezed,
    Object? tinggiBadan = freezed,
    Object? beratBadan = freezed,
    Object? namaWali = freezed,
    Object? hubunganWali = freezed,
    Object? nomorHpWali = freezed,
    Object? alamatWali = freezed,
    Object? kontenFavoritIds = freezed,
    Object? aiKeywords = freezed,
    Object? assessmentCompleted = null,
    Object? preOperativeAssessment = freezed,
    Object? preOperativeAssessmentUpdatedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      dokterId: freezed == dokterId
          ? _value.dokterId
          : dokterId // ignore: cast_nullable_to_non_nullable
              as String?,
      namaLengkap: freezed == namaLengkap
          ? _value.namaLengkap
          : namaLengkap // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorTelepon: freezed == nomorTelepon
          ? _value.nomorTelepon
          : nomorTelepon // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      fotoProfilUrl: freezed == fotoProfilUrl
          ? _value.fotoProfilUrl
          : fotoProfilUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      noRekamMedis: freezed == noRekamMedis
          ? _value.noRekamMedis
          : noRekamMedis // ignore: cast_nullable_to_non_nullable
              as String?,
      nik: freezed == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String?,
      tanggalLahir: freezed == tanggalLahir
          ? _value.tanggalLahir
          : tanggalLahir // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      jenisKelamin: freezed == jenisKelamin
          ? _value.jenisKelamin
          : jenisKelamin // ignore: cast_nullable_to_non_nullable
              as String?,
      agama: freezed == agama
          ? _value.agama
          : agama // ignore: cast_nullable_to_non_nullable
              as String?,
      statusPernikahan: freezed == statusPernikahan
          ? _value.statusPernikahan
          : statusPernikahan // ignore: cast_nullable_to_non_nullable
              as String?,
      pendidikanTerakhir: freezed == pendidikanTerakhir
          ? _value.pendidikanTerakhir
          : pendidikanTerakhir // ignore: cast_nullable_to_non_nullable
              as String?,
      pekerjaan: freezed == pekerjaan
          ? _value.pekerjaan
          : pekerjaan // ignore: cast_nullable_to_non_nullable
              as String?,
      alamatLengkap: freezed == alamatLengkap
          ? _value.alamatLengkap
          : alamatLengkap // ignore: cast_nullable_to_non_nullable
              as String?,
      rt: freezed == rt
          ? _value.rt
          : rt // ignore: cast_nullable_to_non_nullable
              as String?,
      rw: freezed == rw
          ? _value.rw
          : rw // ignore: cast_nullable_to_non_nullable
              as String?,
      kelurahanDesa: freezed == kelurahanDesa
          ? _value.kelurahanDesa
          : kelurahanDesa // ignore: cast_nullable_to_non_nullable
              as String?,
      kecamatan: freezed == kecamatan
          ? _value.kecamatan
          : kecamatan // ignore: cast_nullable_to_non_nullable
              as String?,
      kotaKabupaten: freezed == kotaKabupaten
          ? _value.kotaKabupaten
          : kotaKabupaten // ignore: cast_nullable_to_non_nullable
              as String?,
      provinsi: freezed == provinsi
          ? _value.provinsi
          : provinsi // ignore: cast_nullable_to_non_nullable
              as String?,
      tempatLahir: freezed == tempatLahir
          ? _value.tempatLahir
          : tempatLahir // ignore: cast_nullable_to_non_nullable
              as String?,
      jenisOperasi: freezed == jenisOperasi
          ? _value.jenisOperasi
          : jenisOperasi // ignore: cast_nullable_to_non_nullable
              as String?,
      jenisAnestesi: freezed == jenisAnestesi
          ? _value.jenisAnestesi
          : jenisAnestesi // ignore: cast_nullable_to_non_nullable
              as String?,
      klasifikasiAsa: freezed == klasifikasiAsa
          ? _value.klasifikasiAsa
          : klasifikasiAsa // ignore: cast_nullable_to_non_nullable
              as String?,
      tinggiBadan: freezed == tinggiBadan
          ? _value.tinggiBadan
          : tinggiBadan // ignore: cast_nullable_to_non_nullable
              as double?,
      beratBadan: freezed == beratBadan
          ? _value.beratBadan
          : beratBadan // ignore: cast_nullable_to_non_nullable
              as double?,
      namaWali: freezed == namaWali
          ? _value.namaWali
          : namaWali // ignore: cast_nullable_to_non_nullable
              as String?,
      hubunganWali: freezed == hubunganWali
          ? _value.hubunganWali
          : hubunganWali // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorHpWali: freezed == nomorHpWali
          ? _value.nomorHpWali
          : nomorHpWali // ignore: cast_nullable_to_non_nullable
              as String?,
      alamatWali: freezed == alamatWali
          ? _value.alamatWali
          : alamatWali // ignore: cast_nullable_to_non_nullable
              as String?,
      kontenFavoritIds: freezed == kontenFavoritIds
          ? _value.kontenFavoritIds
          : kontenFavoritIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      aiKeywords: freezed == aiKeywords
          ? _value.aiKeywords
          : aiKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      assessmentCompleted: null == assessmentCompleted
          ? _value.assessmentCompleted
          : assessmentCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      preOperativeAssessment: freezed == preOperativeAssessment
          ? _value.preOperativeAssessment
          : preOperativeAssessment // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      preOperativeAssessmentUpdatedAt: freezed ==
              preOperativeAssessmentUpdatedAt
          ? _value.preOperativeAssessmentUpdatedAt
          : preOperativeAssessmentUpdatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasienProfileModelImplCopyWith<$Res>
    implements $PasienProfileModelCopyWith<$Res> {
  factory _$$PasienProfileModelImplCopyWith(_$PasienProfileModelImpl value,
          $Res Function(_$PasienProfileModelImpl) then) =
      __$$PasienProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "uid") String? uid,
      @JsonKey(name: "dokterId") String? dokterId,
      @JsonKey(name: "namaLengkap") String? namaLengkap,
      @JsonKey(name: "nomorTelepon") String? nomorTelepon,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "fotoProfilUrl") String? fotoProfilUrl,
      @JsonKey(name: "noRekamMedis") String? noRekamMedis,
      @JsonKey(name: "nik") String? nik,
      @JsonKey(
          name: "tanggalLahir",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
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
      @JsonKey(name: "assessmentCompleted") bool assessmentCompleted,
      @JsonKey(name: "preOperativeAssessment")
      Map<String, dynamic>? preOperativeAssessment,
      @JsonKey(
          name: "preOperativeAssessmentUpdatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      Timestamp? preOperativeAssessmentUpdatedAt,
      @JsonKey(
          name: "createdAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      Timestamp? createdAt,
      @JsonKey(
          name: "updatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      Timestamp? updatedAt});
}

/// @nodoc
class __$$PasienProfileModelImplCopyWithImpl<$Res>
    extends _$PasienProfileModelCopyWithImpl<$Res, _$PasienProfileModelImpl>
    implements _$$PasienProfileModelImplCopyWith<$Res> {
  __$$PasienProfileModelImplCopyWithImpl(_$PasienProfileModelImpl _value,
      $Res Function(_$PasienProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasienProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? dokterId = freezed,
    Object? namaLengkap = freezed,
    Object? nomorTelepon = freezed,
    Object? email = freezed,
    Object? fotoProfilUrl = freezed,
    Object? noRekamMedis = freezed,
    Object? nik = freezed,
    Object? tanggalLahir = freezed,
    Object? jenisKelamin = freezed,
    Object? agama = freezed,
    Object? statusPernikahan = freezed,
    Object? pendidikanTerakhir = freezed,
    Object? pekerjaan = freezed,
    Object? alamatLengkap = freezed,
    Object? rt = freezed,
    Object? rw = freezed,
    Object? kelurahanDesa = freezed,
    Object? kecamatan = freezed,
    Object? kotaKabupaten = freezed,
    Object? provinsi = freezed,
    Object? tempatLahir = freezed,
    Object? jenisOperasi = freezed,
    Object? jenisAnestesi = freezed,
    Object? klasifikasiAsa = freezed,
    Object? tinggiBadan = freezed,
    Object? beratBadan = freezed,
    Object? namaWali = freezed,
    Object? hubunganWali = freezed,
    Object? nomorHpWali = freezed,
    Object? alamatWali = freezed,
    Object? kontenFavoritIds = freezed,
    Object? aiKeywords = freezed,
    Object? assessmentCompleted = null,
    Object? preOperativeAssessment = freezed,
    Object? preOperativeAssessmentUpdatedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PasienProfileModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      dokterId: freezed == dokterId
          ? _value.dokterId
          : dokterId // ignore: cast_nullable_to_non_nullable
              as String?,
      namaLengkap: freezed == namaLengkap
          ? _value.namaLengkap
          : namaLengkap // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorTelepon: freezed == nomorTelepon
          ? _value.nomorTelepon
          : nomorTelepon // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      fotoProfilUrl: freezed == fotoProfilUrl
          ? _value.fotoProfilUrl
          : fotoProfilUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      noRekamMedis: freezed == noRekamMedis
          ? _value.noRekamMedis
          : noRekamMedis // ignore: cast_nullable_to_non_nullable
              as String?,
      nik: freezed == nik
          ? _value.nik
          : nik // ignore: cast_nullable_to_non_nullable
              as String?,
      tanggalLahir: freezed == tanggalLahir
          ? _value.tanggalLahir
          : tanggalLahir // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      jenisKelamin: freezed == jenisKelamin
          ? _value.jenisKelamin
          : jenisKelamin // ignore: cast_nullable_to_non_nullable
              as String?,
      agama: freezed == agama
          ? _value.agama
          : agama // ignore: cast_nullable_to_non_nullable
              as String?,
      statusPernikahan: freezed == statusPernikahan
          ? _value.statusPernikahan
          : statusPernikahan // ignore: cast_nullable_to_non_nullable
              as String?,
      pendidikanTerakhir: freezed == pendidikanTerakhir
          ? _value.pendidikanTerakhir
          : pendidikanTerakhir // ignore: cast_nullable_to_non_nullable
              as String?,
      pekerjaan: freezed == pekerjaan
          ? _value.pekerjaan
          : pekerjaan // ignore: cast_nullable_to_non_nullable
              as String?,
      alamatLengkap: freezed == alamatLengkap
          ? _value.alamatLengkap
          : alamatLengkap // ignore: cast_nullable_to_non_nullable
              as String?,
      rt: freezed == rt
          ? _value.rt
          : rt // ignore: cast_nullable_to_non_nullable
              as String?,
      rw: freezed == rw
          ? _value.rw
          : rw // ignore: cast_nullable_to_non_nullable
              as String?,
      kelurahanDesa: freezed == kelurahanDesa
          ? _value.kelurahanDesa
          : kelurahanDesa // ignore: cast_nullable_to_non_nullable
              as String?,
      kecamatan: freezed == kecamatan
          ? _value.kecamatan
          : kecamatan // ignore: cast_nullable_to_non_nullable
              as String?,
      kotaKabupaten: freezed == kotaKabupaten
          ? _value.kotaKabupaten
          : kotaKabupaten // ignore: cast_nullable_to_non_nullable
              as String?,
      provinsi: freezed == provinsi
          ? _value.provinsi
          : provinsi // ignore: cast_nullable_to_non_nullable
              as String?,
      tempatLahir: freezed == tempatLahir
          ? _value.tempatLahir
          : tempatLahir // ignore: cast_nullable_to_non_nullable
              as String?,
      jenisOperasi: freezed == jenisOperasi
          ? _value.jenisOperasi
          : jenisOperasi // ignore: cast_nullable_to_non_nullable
              as String?,
      jenisAnestesi: freezed == jenisAnestesi
          ? _value.jenisAnestesi
          : jenisAnestesi // ignore: cast_nullable_to_non_nullable
              as String?,
      klasifikasiAsa: freezed == klasifikasiAsa
          ? _value.klasifikasiAsa
          : klasifikasiAsa // ignore: cast_nullable_to_non_nullable
              as String?,
      tinggiBadan: freezed == tinggiBadan
          ? _value.tinggiBadan
          : tinggiBadan // ignore: cast_nullable_to_non_nullable
              as double?,
      beratBadan: freezed == beratBadan
          ? _value.beratBadan
          : beratBadan // ignore: cast_nullable_to_non_nullable
              as double?,
      namaWali: freezed == namaWali
          ? _value.namaWali
          : namaWali // ignore: cast_nullable_to_non_nullable
              as String?,
      hubunganWali: freezed == hubunganWali
          ? _value.hubunganWali
          : hubunganWali // ignore: cast_nullable_to_non_nullable
              as String?,
      nomorHpWali: freezed == nomorHpWali
          ? _value.nomorHpWali
          : nomorHpWali // ignore: cast_nullable_to_non_nullable
              as String?,
      alamatWali: freezed == alamatWali
          ? _value.alamatWali
          : alamatWali // ignore: cast_nullable_to_non_nullable
              as String?,
      kontenFavoritIds: freezed == kontenFavoritIds
          ? _value._kontenFavoritIds
          : kontenFavoritIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      aiKeywords: freezed == aiKeywords
          ? _value._aiKeywords
          : aiKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      assessmentCompleted: null == assessmentCompleted
          ? _value.assessmentCompleted
          : assessmentCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      preOperativeAssessment: freezed == preOperativeAssessment
          ? _value._preOperativeAssessment
          : preOperativeAssessment // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      preOperativeAssessmentUpdatedAt: freezed ==
              preOperativeAssessmentUpdatedAt
          ? _value.preOperativeAssessmentUpdatedAt
          : preOperativeAssessmentUpdatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasienProfileModelImpl implements _PasienProfileModel {
  const _$PasienProfileModelImpl(
      {@JsonKey(name: "uid") this.uid,
      @JsonKey(name: "dokterId") this.dokterId,
      @JsonKey(name: "namaLengkap") this.namaLengkap,
      @JsonKey(name: "nomorTelepon") this.nomorTelepon,
      @JsonKey(name: "email") this.email,
      @JsonKey(name: "fotoProfilUrl") this.fotoProfilUrl,
      @JsonKey(name: "noRekamMedis") this.noRekamMedis,
      @JsonKey(name: "nik") this.nik,
      @JsonKey(
          name: "tanggalLahir",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      this.tanggalLahir,
      @JsonKey(name: "jenisKelamin") this.jenisKelamin,
      @JsonKey(name: "agama") this.agama,
      @JsonKey(name: "statusPernikahan") this.statusPernikahan,
      @JsonKey(name: "pendidikanTerakhir") this.pendidikanTerakhir,
      @JsonKey(name: "pekerjaan") this.pekerjaan,
      @JsonKey(name: "alamatLengkap") this.alamatLengkap,
      @JsonKey(name: "rt") this.rt,
      @JsonKey(name: "rw") this.rw,
      @JsonKey(name: "kelurahanDesa") this.kelurahanDesa,
      @JsonKey(name: "kecamatan") this.kecamatan,
      @JsonKey(name: "kotaKabupaten") this.kotaKabupaten,
      @JsonKey(name: "provinsi") this.provinsi,
      @JsonKey(name: "tempatLahir") this.tempatLahir,
      @JsonKey(name: "jenisOperasi") this.jenisOperasi,
      @JsonKey(name: "jenisAnestesi") this.jenisAnestesi,
      @JsonKey(name: "klasifikasiASA") this.klasifikasiAsa,
      @JsonKey(name: "tinggiBadan") this.tinggiBadan,
      @JsonKey(name: "beratBadan") this.beratBadan,
      @JsonKey(name: "namaWali") this.namaWali,
      @JsonKey(name: "hubunganWali") this.hubunganWali,
      @JsonKey(name: "nomorHpWali") this.nomorHpWali,
      @JsonKey(name: "alamatWali") this.alamatWali,
      @JsonKey(name: "kontenFavoritIds") final List<String>? kontenFavoritIds,
      @JsonKey(name: "aiKeywords") final List<String>? aiKeywords,
      @JsonKey(name: "assessmentCompleted") this.assessmentCompleted = false,
      @JsonKey(name: "preOperativeAssessment")
      final Map<String, dynamic>? preOperativeAssessment,
      @JsonKey(
          name: "preOperativeAssessmentUpdatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      this.preOperativeAssessmentUpdatedAt,
      @JsonKey(
          name: "createdAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      this.createdAt,
      @JsonKey(
          name: "updatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      this.updatedAt})
      : _kontenFavoritIds = kontenFavoritIds,
        _aiKeywords = aiKeywords,
        _preOperativeAssessment = preOperativeAssessment;

  factory _$PasienProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasienProfileModelImplFromJson(json);

  @override
  @JsonKey(name: "uid")
  final String? uid;
  @override
  @JsonKey(name: "dokterId")
  final String? dokterId;
  @override
  @JsonKey(name: "namaLengkap")
  final String? namaLengkap;
  @override
  @JsonKey(name: "nomorTelepon")
  final String? nomorTelepon;
  @override
  @JsonKey(name: "email")
  final String? email;
  @override
  @JsonKey(name: "fotoProfilUrl")
  final String? fotoProfilUrl;
  @override
  @JsonKey(name: "noRekamMedis")
  final String? noRekamMedis;
  @override
  @JsonKey(name: "nik")
  final String? nik;
// 🔹 Gunakan converter kamu di sini
  @override
  @JsonKey(
      name: "tanggalLahir",
      fromJson: timestampFromJson,
      toJson: timestampToJson)
  final Timestamp? tanggalLahir;
  @override
  @JsonKey(name: "jenisKelamin")
  final String? jenisKelamin;
  @override
  @JsonKey(name: "agama")
  final String? agama;
  @override
  @JsonKey(name: "statusPernikahan")
  final String? statusPernikahan;
  @override
  @JsonKey(name: "pendidikanTerakhir")
  final String? pendidikanTerakhir;
  @override
  @JsonKey(name: "pekerjaan")
  final String? pekerjaan;
  @override
  @JsonKey(name: "alamatLengkap")
  final String? alamatLengkap;
  @override
  @JsonKey(name: "rt")
  final String? rt;
  @override
  @JsonKey(name: "rw")
  final String? rw;
  @override
  @JsonKey(name: "kelurahanDesa")
  final String? kelurahanDesa;
  @override
  @JsonKey(name: "kecamatan")
  final String? kecamatan;
  @override
  @JsonKey(name: "kotaKabupaten")
  final String? kotaKabupaten;
  @override
  @JsonKey(name: "provinsi")
  final String? provinsi;
  @override
  @JsonKey(name: "tempatLahir")
  final String? tempatLahir;
  @override
  @JsonKey(name: "jenisOperasi")
  final String? jenisOperasi;
  @override
  @JsonKey(name: "jenisAnestesi")
  final String? jenisAnestesi;
  @override
  @JsonKey(name: "klasifikasiASA")
  final String? klasifikasiAsa;
  @override
  @JsonKey(name: "tinggiBadan")
  final double? tinggiBadan;
  @override
  @JsonKey(name: "beratBadan")
  final double? beratBadan;
  @override
  @JsonKey(name: "namaWali")
  final String? namaWali;
  @override
  @JsonKey(name: "hubunganWali")
  final String? hubunganWali;
  @override
  @JsonKey(name: "nomorHpWali")
  final String? nomorHpWali;
  @override
  @JsonKey(name: "alamatWali")
  final String? alamatWali;
  final List<String>? _kontenFavoritIds;
  @override
  @JsonKey(name: "kontenFavoritIds")
  List<String>? get kontenFavoritIds {
    final value = _kontenFavoritIds;
    if (value == null) return null;
    if (_kontenFavoritIds is EqualUnmodifiableListView)
      return _kontenFavoritIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _aiKeywords;
  @override
  @JsonKey(name: "aiKeywords")
  List<String>? get aiKeywords {
    final value = _aiKeywords;
    if (value == null) return null;
    if (_aiKeywords is EqualUnmodifiableListView) return _aiKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: "assessmentCompleted")
  final bool assessmentCompleted;
  final Map<String, dynamic>? _preOperativeAssessment;
  @override
  @JsonKey(name: "preOperativeAssessment")
  Map<String, dynamic>? get preOperativeAssessment {
    final value = _preOperativeAssessment;
    if (value == null) return null;
    if (_preOperativeAssessment is EqualUnmodifiableMapView)
      return _preOperativeAssessment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(
      name: "preOperativeAssessmentUpdatedAt",
      fromJson: timestampFromJson,
      toJson: timestampToJson)
  final Timestamp? preOperativeAssessmentUpdatedAt;
// 🔹 Gunakan converter juga di timestamp lain
  @override
  @JsonKey(
      name: "createdAt", fromJson: timestampFromJson, toJson: timestampToJson)
  final Timestamp? createdAt;
  @override
  @JsonKey(
      name: "updatedAt", fromJson: timestampFromJson, toJson: timestampToJson)
  final Timestamp? updatedAt;

  @override
  String toString() {
    return 'PasienProfileModel(uid: $uid, dokterId: $dokterId, namaLengkap: $namaLengkap, nomorTelepon: $nomorTelepon, email: $email, fotoProfilUrl: $fotoProfilUrl, noRekamMedis: $noRekamMedis, nik: $nik, tanggalLahir: $tanggalLahir, jenisKelamin: $jenisKelamin, agama: $agama, statusPernikahan: $statusPernikahan, pendidikanTerakhir: $pendidikanTerakhir, pekerjaan: $pekerjaan, alamatLengkap: $alamatLengkap, rt: $rt, rw: $rw, kelurahanDesa: $kelurahanDesa, kecamatan: $kecamatan, kotaKabupaten: $kotaKabupaten, provinsi: $provinsi, tempatLahir: $tempatLahir, jenisOperasi: $jenisOperasi, jenisAnestesi: $jenisAnestesi, klasifikasiAsa: $klasifikasiAsa, tinggiBadan: $tinggiBadan, beratBadan: $beratBadan, namaWali: $namaWali, hubunganWali: $hubunganWali, nomorHpWali: $nomorHpWali, alamatWali: $alamatWali, kontenFavoritIds: $kontenFavoritIds, aiKeywords: $aiKeywords, assessmentCompleted: $assessmentCompleted, preOperativeAssessment: $preOperativeAssessment, preOperativeAssessmentUpdatedAt: $preOperativeAssessmentUpdatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasienProfileModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.dokterId, dokterId) ||
                other.dokterId == dokterId) &&
            (identical(other.namaLengkap, namaLengkap) ||
                other.namaLengkap == namaLengkap) &&
            (identical(other.nomorTelepon, nomorTelepon) ||
                other.nomorTelepon == nomorTelepon) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fotoProfilUrl, fotoProfilUrl) ||
                other.fotoProfilUrl == fotoProfilUrl) &&
            (identical(other.noRekamMedis, noRekamMedis) ||
                other.noRekamMedis == noRekamMedis) &&
            (identical(other.nik, nik) || other.nik == nik) &&
            (identical(other.tanggalLahir, tanggalLahir) ||
                other.tanggalLahir == tanggalLahir) &&
            (identical(other.jenisKelamin, jenisKelamin) ||
                other.jenisKelamin == jenisKelamin) &&
            (identical(other.agama, agama) || other.agama == agama) &&
            (identical(other.statusPernikahan, statusPernikahan) ||
                other.statusPernikahan == statusPernikahan) &&
            (identical(other.pendidikanTerakhir, pendidikanTerakhir) ||
                other.pendidikanTerakhir == pendidikanTerakhir) &&
            (identical(other.pekerjaan, pekerjaan) ||
                other.pekerjaan == pekerjaan) &&
            (identical(other.alamatLengkap, alamatLengkap) ||
                other.alamatLengkap == alamatLengkap) &&
            (identical(other.rt, rt) || other.rt == rt) &&
            (identical(other.rw, rw) || other.rw == rw) &&
            (identical(other.kelurahanDesa, kelurahanDesa) ||
                other.kelurahanDesa == kelurahanDesa) &&
            (identical(other.kecamatan, kecamatan) ||
                other.kecamatan == kecamatan) &&
            (identical(other.kotaKabupaten, kotaKabupaten) ||
                other.kotaKabupaten == kotaKabupaten) &&
            (identical(other.provinsi, provinsi) ||
                other.provinsi == provinsi) &&
            (identical(other.tempatLahir, tempatLahir) ||
                other.tempatLahir == tempatLahir) &&
            (identical(other.jenisOperasi, jenisOperasi) ||
                other.jenisOperasi == jenisOperasi) &&
            (identical(other.jenisAnestesi, jenisAnestesi) ||
                other.jenisAnestesi == jenisAnestesi) &&
            (identical(other.klasifikasiAsa, klasifikasiAsa) ||
                other.klasifikasiAsa == klasifikasiAsa) &&
            (identical(other.tinggiBadan, tinggiBadan) ||
                other.tinggiBadan == tinggiBadan) &&
            (identical(other.beratBadan, beratBadan) ||
                other.beratBadan == beratBadan) &&
            (identical(other.namaWali, namaWali) ||
                other.namaWali == namaWali) &&
            (identical(other.hubunganWali, hubunganWali) ||
                other.hubunganWali == hubunganWali) &&
            (identical(other.nomorHpWali, nomorHpWali) ||
                other.nomorHpWali == nomorHpWali) &&
            (identical(other.alamatWali, alamatWali) ||
                other.alamatWali == alamatWali) &&
            const DeepCollectionEquality()
                .equals(other._kontenFavoritIds, _kontenFavoritIds) &&
            const DeepCollectionEquality()
                .equals(other._aiKeywords, _aiKeywords) &&
            (identical(other.assessmentCompleted, assessmentCompleted) ||
                other.assessmentCompleted == assessmentCompleted) &&
            const DeepCollectionEquality().equals(
                other._preOperativeAssessment, _preOperativeAssessment) &&
            (identical(other.preOperativeAssessmentUpdatedAt,
                    preOperativeAssessmentUpdatedAt) ||
                other.preOperativeAssessmentUpdatedAt ==
                    preOperativeAssessmentUpdatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uid,
        dokterId,
        namaLengkap,
        nomorTelepon,
        email,
        fotoProfilUrl,
        noRekamMedis,
        nik,
        tanggalLahir,
        jenisKelamin,
        agama,
        statusPernikahan,
        pendidikanTerakhir,
        pekerjaan,
        alamatLengkap,
        rt,
        rw,
        kelurahanDesa,
        kecamatan,
        kotaKabupaten,
        provinsi,
        tempatLahir,
        jenisOperasi,
        jenisAnestesi,
        klasifikasiAsa,
        tinggiBadan,
        beratBadan,
        namaWali,
        hubunganWali,
        nomorHpWali,
        alamatWali,
        const DeepCollectionEquality().hash(_kontenFavoritIds),
        const DeepCollectionEquality().hash(_aiKeywords),
        assessmentCompleted,
        const DeepCollectionEquality().hash(_preOperativeAssessment),
        preOperativeAssessmentUpdatedAt,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of PasienProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasienProfileModelImplCopyWith<_$PasienProfileModelImpl> get copyWith =>
      __$$PasienProfileModelImplCopyWithImpl<_$PasienProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasienProfileModelImplToJson(
      this,
    );
  }
}

abstract class _PasienProfileModel implements PasienProfileModel {
  const factory _PasienProfileModel(
      {@JsonKey(name: "uid") final String? uid,
      @JsonKey(name: "dokterId") final String? dokterId,
      @JsonKey(name: "namaLengkap") final String? namaLengkap,
      @JsonKey(name: "nomorTelepon") final String? nomorTelepon,
      @JsonKey(name: "email") final String? email,
      @JsonKey(name: "fotoProfilUrl") final String? fotoProfilUrl,
      @JsonKey(name: "noRekamMedis") final String? noRekamMedis,
      @JsonKey(name: "nik") final String? nik,
      @JsonKey(
          name: "tanggalLahir",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      final Timestamp? tanggalLahir,
      @JsonKey(name: "jenisKelamin") final String? jenisKelamin,
      @JsonKey(name: "agama") final String? agama,
      @JsonKey(name: "statusPernikahan") final String? statusPernikahan,
      @JsonKey(name: "pendidikanTerakhir") final String? pendidikanTerakhir,
      @JsonKey(name: "pekerjaan") final String? pekerjaan,
      @JsonKey(name: "alamatLengkap") final String? alamatLengkap,
      @JsonKey(name: "rt") final String? rt,
      @JsonKey(name: "rw") final String? rw,
      @JsonKey(name: "kelurahanDesa") final String? kelurahanDesa,
      @JsonKey(name: "kecamatan") final String? kecamatan,
      @JsonKey(name: "kotaKabupaten") final String? kotaKabupaten,
      @JsonKey(name: "provinsi") final String? provinsi,
      @JsonKey(name: "tempatLahir") final String? tempatLahir,
      @JsonKey(name: "jenisOperasi") final String? jenisOperasi,
      @JsonKey(name: "jenisAnestesi") final String? jenisAnestesi,
      @JsonKey(name: "klasifikasiASA") final String? klasifikasiAsa,
      @JsonKey(name: "tinggiBadan") final double? tinggiBadan,
      @JsonKey(name: "beratBadan") final double? beratBadan,
      @JsonKey(name: "namaWali") final String? namaWali,
      @JsonKey(name: "hubunganWali") final String? hubunganWali,
      @JsonKey(name: "nomorHpWali") final String? nomorHpWali,
      @JsonKey(name: "alamatWali") final String? alamatWali,
      @JsonKey(name: "kontenFavoritIds") final List<String>? kontenFavoritIds,
      @JsonKey(name: "aiKeywords") final List<String>? aiKeywords,
      @JsonKey(name: "assessmentCompleted") final bool assessmentCompleted,
      @JsonKey(name: "preOperativeAssessment")
      final Map<String, dynamic>? preOperativeAssessment,
      @JsonKey(
          name: "preOperativeAssessmentUpdatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      final Timestamp? preOperativeAssessmentUpdatedAt,
      @JsonKey(
          name: "createdAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      final Timestamp? createdAt,
      @JsonKey(
          name: "updatedAt",
          fromJson: timestampFromJson,
          toJson: timestampToJson)
      final Timestamp? updatedAt}) = _$PasienProfileModelImpl;

  factory _PasienProfileModel.fromJson(Map<String, dynamic> json) =
      _$PasienProfileModelImpl.fromJson;

  @override
  @JsonKey(name: "uid")
  String? get uid;
  @override
  @JsonKey(name: "dokterId")
  String? get dokterId;
  @override
  @JsonKey(name: "namaLengkap")
  String? get namaLengkap;
  @override
  @JsonKey(name: "nomorTelepon")
  String? get nomorTelepon;
  @override
  @JsonKey(name: "email")
  String? get email;
  @override
  @JsonKey(name: "fotoProfilUrl")
  String? get fotoProfilUrl;
  @override
  @JsonKey(name: "noRekamMedis")
  String? get noRekamMedis;
  @override
  @JsonKey(name: "nik")
  String? get nik; // 🔹 Gunakan converter kamu di sini
  @override
  @JsonKey(
      name: "tanggalLahir",
      fromJson: timestampFromJson,
      toJson: timestampToJson)
  Timestamp? get tanggalLahir;
  @override
  @JsonKey(name: "jenisKelamin")
  String? get jenisKelamin;
  @override
  @JsonKey(name: "agama")
  String? get agama;
  @override
  @JsonKey(name: "statusPernikahan")
  String? get statusPernikahan;
  @override
  @JsonKey(name: "pendidikanTerakhir")
  String? get pendidikanTerakhir;
  @override
  @JsonKey(name: "pekerjaan")
  String? get pekerjaan;
  @override
  @JsonKey(name: "alamatLengkap")
  String? get alamatLengkap;
  @override
  @JsonKey(name: "rt")
  String? get rt;
  @override
  @JsonKey(name: "rw")
  String? get rw;
  @override
  @JsonKey(name: "kelurahanDesa")
  String? get kelurahanDesa;
  @override
  @JsonKey(name: "kecamatan")
  String? get kecamatan;
  @override
  @JsonKey(name: "kotaKabupaten")
  String? get kotaKabupaten;
  @override
  @JsonKey(name: "provinsi")
  String? get provinsi;
  @override
  @JsonKey(name: "tempatLahir")
  String? get tempatLahir;
  @override
  @JsonKey(name: "jenisOperasi")
  String? get jenisOperasi;
  @override
  @JsonKey(name: "jenisAnestesi")
  String? get jenisAnestesi;
  @override
  @JsonKey(name: "klasifikasiASA")
  String? get klasifikasiAsa;
  @override
  @JsonKey(name: "tinggiBadan")
  double? get tinggiBadan;
  @override
  @JsonKey(name: "beratBadan")
  double? get beratBadan;
  @override
  @JsonKey(name: "namaWali")
  String? get namaWali;
  @override
  @JsonKey(name: "hubunganWali")
  String? get hubunganWali;
  @override
  @JsonKey(name: "nomorHpWali")
  String? get nomorHpWali;
  @override
  @JsonKey(name: "alamatWali")
  String? get alamatWali;
  @override
  @JsonKey(name: "kontenFavoritIds")
  List<String>? get kontenFavoritIds;
  @override
  @JsonKey(name: "aiKeywords")
  List<String>? get aiKeywords;
  @override
  @JsonKey(name: "assessmentCompleted")
  bool get assessmentCompleted;
  @override
  @JsonKey(name: "preOperativeAssessment")
  Map<String, dynamic>? get preOperativeAssessment;
  @override
  @JsonKey(
      name: "preOperativeAssessmentUpdatedAt",
      fromJson: timestampFromJson,
      toJson: timestampToJson)
  Timestamp?
      get preOperativeAssessmentUpdatedAt; // 🔹 Gunakan converter juga di timestamp lain
  @override
  @JsonKey(
      name: "createdAt", fromJson: timestampFromJson, toJson: timestampToJson)
  Timestamp? get createdAt;
  @override
  @JsonKey(
      name: "updatedAt", fromJson: timestampFromJson, toJson: timestampToJson)
  Timestamp? get updatedAt;

  /// Create a copy of PasienProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasienProfileModelImplCopyWith<_$PasienProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
