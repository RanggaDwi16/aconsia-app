// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatSessionModel _$ChatSessionModelFromJson(Map<String, dynamic> json) {
  return _ChatSessionModel.fromJson(json);
}

/// @nodoc
mixin _$ChatSessionModel {
  String get id => throw _privateConstructorUsedError;
  String get pasienId =>
      throw _privateConstructorUsedError; // Reference to pasien_profiles collection
  String get dokterId =>
      throw _privateConstructorUsedError; // Reference to dokter_profiles collection
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  int get unreadCountPasien =>
      throw _privateConstructorUsedError; // Unread count for pasien
  int get unreadCountDokter =>
      throw _privateConstructorUsedError; // Unread count for dokter
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChatSessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatSessionModelCopyWith<ChatSessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSessionModelCopyWith<$Res> {
  factory $ChatSessionModelCopyWith(
          ChatSessionModel value, $Res Function(ChatSessionModel) then) =
      _$ChatSessionModelCopyWithImpl<$Res, ChatSessionModel>;
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String dokterId,
      String? lastMessage,
      DateTime? lastMessageAt,
      int unreadCountPasien,
      int unreadCountDokter,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ChatSessionModelCopyWithImpl<$Res, $Val extends ChatSessionModel>
    implements $ChatSessionModelCopyWith<$Res> {
  _$ChatSessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? dokterId = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCountPasien = null,
    Object? unreadCountDokter = null,
    Object? createdAt = null,
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
      dokterId: null == dokterId
          ? _value.dokterId
          : dokterId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadCountPasien: null == unreadCountPasien
          ? _value.unreadCountPasien
          : unreadCountPasien // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCountDokter: null == unreadCountDokter
          ? _value.unreadCountDokter
          : unreadCountDokter // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatSessionModelImplCopyWith<$Res>
    implements $ChatSessionModelCopyWith<$Res> {
  factory _$$ChatSessionModelImplCopyWith(_$ChatSessionModelImpl value,
          $Res Function(_$ChatSessionModelImpl) then) =
      __$$ChatSessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String dokterId,
      String? lastMessage,
      DateTime? lastMessageAt,
      int unreadCountPasien,
      int unreadCountDokter,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ChatSessionModelImplCopyWithImpl<$Res>
    extends _$ChatSessionModelCopyWithImpl<$Res, _$ChatSessionModelImpl>
    implements _$$ChatSessionModelImplCopyWith<$Res> {
  __$$ChatSessionModelImplCopyWithImpl(_$ChatSessionModelImpl _value,
      $Res Function(_$ChatSessionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? dokterId = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCountPasien = null,
    Object? unreadCountDokter = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ChatSessionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pasienId: null == pasienId
          ? _value.pasienId
          : pasienId // ignore: cast_nullable_to_non_nullable
              as String,
      dokterId: null == dokterId
          ? _value.dokterId
          : dokterId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadCountPasien: null == unreadCountPasien
          ? _value.unreadCountPasien
          : unreadCountPasien // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCountDokter: null == unreadCountDokter
          ? _value.unreadCountDokter
          : unreadCountDokter // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatSessionModelImpl implements _ChatSessionModel {
  const _$ChatSessionModelImpl(
      {required this.id,
      required this.pasienId,
      required this.dokterId,
      this.lastMessage,
      this.lastMessageAt,
      this.unreadCountPasien = 0,
      this.unreadCountDokter = 0,
      required this.createdAt,
      required this.updatedAt});

  factory _$ChatSessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatSessionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String pasienId;
// Reference to pasien_profiles collection
  @override
  final String dokterId;
// Reference to dokter_profiles collection
  @override
  final String? lastMessage;
  @override
  final DateTime? lastMessageAt;
  @override
  @JsonKey()
  final int unreadCountPasien;
// Unread count for pasien
  @override
  @JsonKey()
  final int unreadCountDokter;
// Unread count for dokter
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChatSessionModel(id: $id, pasienId: $pasienId, dokterId: $dokterId, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, unreadCountPasien: $unreadCountPasien, unreadCountDokter: $unreadCountDokter, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pasienId, pasienId) ||
                other.pasienId == pasienId) &&
            (identical(other.dokterId, dokterId) ||
                other.dokterId == dokterId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.unreadCountPasien, unreadCountPasien) ||
                other.unreadCountPasien == unreadCountPasien) &&
            (identical(other.unreadCountDokter, unreadCountDokter) ||
                other.unreadCountDokter == unreadCountDokter) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pasienId,
      dokterId,
      lastMessage,
      lastMessageAt,
      unreadCountPasien,
      unreadCountDokter,
      createdAt,
      updatedAt);

  /// Create a copy of ChatSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSessionModelImplCopyWith<_$ChatSessionModelImpl> get copyWith =>
      __$$ChatSessionModelImplCopyWithImpl<_$ChatSessionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatSessionModelImplToJson(
      this,
    );
  }
}

abstract class _ChatSessionModel implements ChatSessionModel {
  const factory _ChatSessionModel(
      {required final String id,
      required final String pasienId,
      required final String dokterId,
      final String? lastMessage,
      final DateTime? lastMessageAt,
      final int unreadCountPasien,
      final int unreadCountDokter,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ChatSessionModelImpl;

  factory _ChatSessionModel.fromJson(Map<String, dynamic> json) =
      _$ChatSessionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get pasienId; // Reference to pasien_profiles collection
  @override
  String get dokterId; // Reference to dokter_profiles collection
  @override
  String? get lastMessage;
  @override
  DateTime? get lastMessageAt;
  @override
  int get unreadCountPasien; // Unread count for pasien
  @override
  int get unreadCountDokter; // Unread count for dokter
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ChatSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatSessionModelImplCopyWith<_$ChatSessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
