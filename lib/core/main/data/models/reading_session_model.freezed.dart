// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReadingSessionModel _$ReadingSessionModelFromJson(Map<String, dynamic> json) {
  return _ReadingSessionModel.fromJson(json);
}

/// @nodoc
mixin _$ReadingSessionModel {
  String get id => throw _privateConstructorUsedError;
  String get pasienId =>
      throw _privateConstructorUsedError; // Reference to pasien_profiles
  String get kontenId =>
      throw _privateConstructorUsedError; // Reference to konten
  String get sectionId =>
      throw _privateConstructorUsedError; // Current section being read
  String get dokterId =>
      throw _privateConstructorUsedError; // Reference to dokter_profiles
  DateTime get startedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError; // Still reading?
  DateTime? get endedAt => throw _privateConstructorUsedError;

  /// Serializes this ReadingSessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingSessionModelCopyWith<ReadingSessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingSessionModelCopyWith<$Res> {
  factory $ReadingSessionModelCopyWith(
          ReadingSessionModel value, $Res Function(ReadingSessionModel) then) =
      _$ReadingSessionModelCopyWithImpl<$Res, ReadingSessionModel>;
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      String sectionId,
      String dokterId,
      DateTime startedAt,
      bool isActive,
      DateTime? endedAt});
}

/// @nodoc
class _$ReadingSessionModelCopyWithImpl<$Res, $Val extends ReadingSessionModel>
    implements $ReadingSessionModelCopyWith<$Res> {
  _$ReadingSessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? sectionId = null,
    Object? dokterId = null,
    Object? startedAt = null,
    Object? isActive = null,
    Object? endedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pasienId: null == pasienId
          ? _value.pasienId
          : pasienId // ignore: cast_nullable_to_non_nullable
              as String,
      kontenId: null == kontenId
          ? _value.kontenId
          : kontenId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      dokterId: null == dokterId
          ? _value.dokterId
          : dokterId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadingSessionModelImplCopyWith<$Res>
    implements $ReadingSessionModelCopyWith<$Res> {
  factory _$$ReadingSessionModelImplCopyWith(_$ReadingSessionModelImpl value,
          $Res Function(_$ReadingSessionModelImpl) then) =
      __$$ReadingSessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      String sectionId,
      String dokterId,
      DateTime startedAt,
      bool isActive,
      DateTime? endedAt});
}

/// @nodoc
class __$$ReadingSessionModelImplCopyWithImpl<$Res>
    extends _$ReadingSessionModelCopyWithImpl<$Res, _$ReadingSessionModelImpl>
    implements _$$ReadingSessionModelImplCopyWith<$Res> {
  __$$ReadingSessionModelImplCopyWithImpl(_$ReadingSessionModelImpl _value,
      $Res Function(_$ReadingSessionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReadingSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? sectionId = null,
    Object? dokterId = null,
    Object? startedAt = null,
    Object? isActive = null,
    Object? endedAt = freezed,
  }) {
    return _then(_$ReadingSessionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pasienId: null == pasienId
          ? _value.pasienId
          : pasienId // ignore: cast_nullable_to_non_nullable
              as String,
      kontenId: null == kontenId
          ? _value.kontenId
          : kontenId // ignore: cast_nullable_to_non_nullable
              as String,
      sectionId: null == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String,
      dokterId: null == dokterId
          ? _value.dokterId
          : dokterId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingSessionModelImpl implements _ReadingSessionModel {
  const _$ReadingSessionModelImpl(
      {required this.id,
      required this.pasienId,
      required this.kontenId,
      required this.sectionId,
      required this.dokterId,
      required this.startedAt,
      this.isActive = true,
      this.endedAt});

  factory _$ReadingSessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingSessionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String pasienId;
// Reference to pasien_profiles
  @override
  final String kontenId;
// Reference to konten
  @override
  final String sectionId;
// Current section being read
  @override
  final String dokterId;
// Reference to dokter_profiles
  @override
  final DateTime startedAt;
  @override
  @JsonKey()
  final bool isActive;
// Still reading?
  @override
  final DateTime? endedAt;

  @override
  String toString() {
    return 'ReadingSessionModel(id: $id, pasienId: $pasienId, kontenId: $kontenId, sectionId: $sectionId, dokterId: $dokterId, startedAt: $startedAt, isActive: $isActive, endedAt: $endedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingSessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pasienId, pasienId) ||
                other.pasienId == pasienId) &&
            (identical(other.kontenId, kontenId) ||
                other.kontenId == kontenId) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.dokterId, dokterId) ||
                other.dokterId == dokterId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, pasienId, kontenId,
      sectionId, dokterId, startedAt, isActive, endedAt);

  /// Create a copy of ReadingSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingSessionModelImplCopyWith<_$ReadingSessionModelImpl> get copyWith =>
      __$$ReadingSessionModelImplCopyWithImpl<_$ReadingSessionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingSessionModelImplToJson(
      this,
    );
  }
}

abstract class _ReadingSessionModel implements ReadingSessionModel {
  const factory _ReadingSessionModel(
      {required final String id,
      required final String pasienId,
      required final String kontenId,
      required final String sectionId,
      required final String dokterId,
      required final DateTime startedAt,
      final bool isActive,
      final DateTime? endedAt}) = _$ReadingSessionModelImpl;

  factory _ReadingSessionModel.fromJson(Map<String, dynamic> json) =
      _$ReadingSessionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get pasienId; // Reference to pasien_profiles
  @override
  String get kontenId; // Reference to konten
  @override
  String get sectionId; // Current section being read
  @override
  String get dokterId; // Reference to dokter_profiles
  @override
  DateTime get startedAt;
  @override
  bool get isActive; // Still reading?
  @override
  DateTime? get endedAt;

  /// Create a copy of ReadingSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingSessionModelImplCopyWith<_$ReadingSessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
