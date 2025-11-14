// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'konten_assignment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KontenAssignmentModel _$KontenAssignmentModelFromJson(
    Map<String, dynamic> json) {
  return _KontenAssignmentModel.fromJson(json);
}

/// @nodoc
mixin _$KontenAssignmentModel {
  String get id => throw _privateConstructorUsedError;
  String get pasienId =>
      throw _privateConstructorUsedError; // Reference to pasien_profiles collection
  String get kontenId =>
      throw _privateConstructorUsedError; // Reference to konten collection
  String get assignedBy =>
      throw _privateConstructorUsedError; // Dokter ID who assigned
  DateTime get assignedAt => throw _privateConstructorUsedError;
  int get currentBagian =>
      throw _privateConstructorUsedError; // Current section being read (1, 2, 3...)
  bool get isCompleted =>
      throw _privateConstructorUsedError; // All sections read?
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this KontenAssignmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KontenAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KontenAssignmentModelCopyWith<KontenAssignmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KontenAssignmentModelCopyWith<$Res> {
  factory $KontenAssignmentModelCopyWith(KontenAssignmentModel value,
          $Res Function(KontenAssignmentModel) then) =
      _$KontenAssignmentModelCopyWithImpl<$Res, KontenAssignmentModel>;
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      String assignedBy,
      DateTime assignedAt,
      int currentBagian,
      bool isCompleted,
      DateTime? completedAt,
      DateTime updatedAt});
}

/// @nodoc
class _$KontenAssignmentModelCopyWithImpl<$Res,
        $Val extends KontenAssignmentModel>
    implements $KontenAssignmentModelCopyWith<$Res> {
  _$KontenAssignmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KontenAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? assignedBy = null,
    Object? assignedAt = null,
    Object? currentBagian = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? updatedAt = null,
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
      assignedBy: null == assignedBy
          ? _value.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as String,
      assignedAt: null == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentBagian: null == currentBagian
          ? _value.currentBagian
          : currentBagian // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KontenAssignmentModelImplCopyWith<$Res>
    implements $KontenAssignmentModelCopyWith<$Res> {
  factory _$$KontenAssignmentModelImplCopyWith(
          _$KontenAssignmentModelImpl value,
          $Res Function(_$KontenAssignmentModelImpl) then) =
      __$$KontenAssignmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      String assignedBy,
      DateTime assignedAt,
      int currentBagian,
      bool isCompleted,
      DateTime? completedAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$KontenAssignmentModelImplCopyWithImpl<$Res>
    extends _$KontenAssignmentModelCopyWithImpl<$Res,
        _$KontenAssignmentModelImpl>
    implements _$$KontenAssignmentModelImplCopyWith<$Res> {
  __$$KontenAssignmentModelImplCopyWithImpl(_$KontenAssignmentModelImpl _value,
      $Res Function(_$KontenAssignmentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of KontenAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? assignedBy = null,
    Object? assignedAt = null,
    Object? currentBagian = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$KontenAssignmentModelImpl(
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
      assignedBy: null == assignedBy
          ? _value.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as String,
      assignedAt: null == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentBagian: null == currentBagian
          ? _value.currentBagian
          : currentBagian // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KontenAssignmentModelImpl implements _KontenAssignmentModel {
  const _$KontenAssignmentModelImpl(
      {required this.id,
      required this.pasienId,
      required this.kontenId,
      required this.assignedBy,
      required this.assignedAt,
      this.currentBagian = 1,
      this.isCompleted = false,
      this.completedAt,
      required this.updatedAt});

  factory _$KontenAssignmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KontenAssignmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String pasienId;
// Reference to pasien_profiles collection
  @override
  final String kontenId;
// Reference to konten collection
  @override
  final String assignedBy;
// Dokter ID who assigned
  @override
  final DateTime assignedAt;
  @override
  @JsonKey()
  final int currentBagian;
// Current section being read (1, 2, 3...)
  @override
  @JsonKey()
  final bool isCompleted;
// All sections read?
  @override
  final DateTime? completedAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'KontenAssignmentModel(id: $id, pasienId: $pasienId, kontenId: $kontenId, assignedBy: $assignedBy, assignedAt: $assignedAt, currentBagian: $currentBagian, isCompleted: $isCompleted, completedAt: $completedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KontenAssignmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pasienId, pasienId) ||
                other.pasienId == pasienId) &&
            (identical(other.kontenId, kontenId) ||
                other.kontenId == kontenId) &&
            (identical(other.assignedBy, assignedBy) ||
                other.assignedBy == assignedBy) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.currentBagian, currentBagian) ||
                other.currentBagian == currentBagian) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pasienId,
      kontenId,
      assignedBy,
      assignedAt,
      currentBagian,
      isCompleted,
      completedAt,
      updatedAt);

  /// Create a copy of KontenAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KontenAssignmentModelImplCopyWith<_$KontenAssignmentModelImpl>
      get copyWith => __$$KontenAssignmentModelImplCopyWithImpl<
          _$KontenAssignmentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KontenAssignmentModelImplToJson(
      this,
    );
  }
}

abstract class _KontenAssignmentModel implements KontenAssignmentModel {
  const factory _KontenAssignmentModel(
      {required final String id,
      required final String pasienId,
      required final String kontenId,
      required final String assignedBy,
      required final DateTime assignedAt,
      final int currentBagian,
      final bool isCompleted,
      final DateTime? completedAt,
      required final DateTime updatedAt}) = _$KontenAssignmentModelImpl;

  factory _KontenAssignmentModel.fromJson(Map<String, dynamic> json) =
      _$KontenAssignmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get pasienId; // Reference to pasien_profiles collection
  @override
  String get kontenId; // Reference to konten collection
  @override
  String get assignedBy; // Dokter ID who assigned
  @override
  DateTime get assignedAt;
  @override
  int get currentBagian; // Current section being read (1, 2, 3...)
  @override
  bool get isCompleted; // All sections read?
  @override
  DateTime? get completedAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of KontenAssignmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KontenAssignmentModelImplCopyWith<_$KontenAssignmentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
