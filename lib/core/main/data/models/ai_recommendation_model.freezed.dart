// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_recommendation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIRecommendationModel _$AIRecommendationModelFromJson(
    Map<String, dynamic> json) {
  return _AIRecommendationModel.fromJson(json);
}

/// @nodoc
mixin _$AIRecommendationModel {
  String get id => throw _privateConstructorUsedError;
  String get pasienId =>
      throw _privateConstructorUsedError; // Reference to pasien_profiles collection
  String get kontenId =>
      throw _privateConstructorUsedError; // Recommended konten ID
  List<String> get matchedKeywords =>
      throw _privateConstructorUsedError; // Keywords that matched
  double get relevanceScore =>
      throw _privateConstructorUsedError; // 0.0 to 1.0 (AI confidence score)
  bool get isViewed =>
      throw _privateConstructorUsedError; // Has pasien viewed this recommendation?
  DateTime? get viewedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AIRecommendationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIRecommendationModelCopyWith<AIRecommendationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIRecommendationModelCopyWith<$Res> {
  factory $AIRecommendationModelCopyWith(AIRecommendationModel value,
          $Res Function(AIRecommendationModel) then) =
      _$AIRecommendationModelCopyWithImpl<$Res, AIRecommendationModel>;
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      List<String> matchedKeywords,
      double relevanceScore,
      bool isViewed,
      DateTime? viewedAt,
      DateTime createdAt});
}

/// @nodoc
class _$AIRecommendationModelCopyWithImpl<$Res,
        $Val extends AIRecommendationModel>
    implements $AIRecommendationModelCopyWith<$Res> {
  _$AIRecommendationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? matchedKeywords = null,
    Object? relevanceScore = null,
    Object? isViewed = null,
    Object? viewedAt = freezed,
    Object? createdAt = null,
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
      matchedKeywords: null == matchedKeywords
          ? _value.matchedKeywords
          : matchedKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relevanceScore: null == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
      viewedAt: freezed == viewedAt
          ? _value.viewedAt
          : viewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIRecommendationModelImplCopyWith<$Res>
    implements $AIRecommendationModelCopyWith<$Res> {
  factory _$$AIRecommendationModelImplCopyWith(
          _$AIRecommendationModelImpl value,
          $Res Function(_$AIRecommendationModelImpl) then) =
      __$$AIRecommendationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      List<String> matchedKeywords,
      double relevanceScore,
      bool isViewed,
      DateTime? viewedAt,
      DateTime createdAt});
}

/// @nodoc
class __$$AIRecommendationModelImplCopyWithImpl<$Res>
    extends _$AIRecommendationModelCopyWithImpl<$Res,
        _$AIRecommendationModelImpl>
    implements _$$AIRecommendationModelImplCopyWith<$Res> {
  __$$AIRecommendationModelImplCopyWithImpl(_$AIRecommendationModelImpl _value,
      $Res Function(_$AIRecommendationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? matchedKeywords = null,
    Object? relevanceScore = null,
    Object? isViewed = null,
    Object? viewedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$AIRecommendationModelImpl(
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
      matchedKeywords: null == matchedKeywords
          ? _value._matchedKeywords
          : matchedKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relevanceScore: null == relevanceScore
          ? _value.relevanceScore
          : relevanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      isViewed: null == isViewed
          ? _value.isViewed
          : isViewed // ignore: cast_nullable_to_non_nullable
              as bool,
      viewedAt: freezed == viewedAt
          ? _value.viewedAt
          : viewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIRecommendationModelImpl implements _AIRecommendationModel {
  const _$AIRecommendationModelImpl(
      {required this.id,
      required this.pasienId,
      required this.kontenId,
      final List<String> matchedKeywords = const [],
      required this.relevanceScore,
      this.isViewed = false,
      this.viewedAt,
      required this.createdAt})
      : _matchedKeywords = matchedKeywords;

  factory _$AIRecommendationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIRecommendationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String pasienId;
// Reference to pasien_profiles collection
  @override
  final String kontenId;
// Recommended konten ID
  final List<String> _matchedKeywords;
// Recommended konten ID
  @override
  @JsonKey()
  List<String> get matchedKeywords {
    if (_matchedKeywords is EqualUnmodifiableListView) return _matchedKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchedKeywords);
  }

// Keywords that matched
  @override
  final double relevanceScore;
// 0.0 to 1.0 (AI confidence score)
  @override
  @JsonKey()
  final bool isViewed;
// Has pasien viewed this recommendation?
  @override
  final DateTime? viewedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AIRecommendationModel(id: $id, pasienId: $pasienId, kontenId: $kontenId, matchedKeywords: $matchedKeywords, relevanceScore: $relevanceScore, isViewed: $isViewed, viewedAt: $viewedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIRecommendationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pasienId, pasienId) ||
                other.pasienId == pasienId) &&
            (identical(other.kontenId, kontenId) ||
                other.kontenId == kontenId) &&
            const DeepCollectionEquality()
                .equals(other._matchedKeywords, _matchedKeywords) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            (identical(other.isViewed, isViewed) ||
                other.isViewed == isViewed) &&
            (identical(other.viewedAt, viewedAt) ||
                other.viewedAt == viewedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pasienId,
      kontenId,
      const DeepCollectionEquality().hash(_matchedKeywords),
      relevanceScore,
      isViewed,
      viewedAt,
      createdAt);

  /// Create a copy of AIRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIRecommendationModelImplCopyWith<_$AIRecommendationModelImpl>
      get copyWith => __$$AIRecommendationModelImplCopyWithImpl<
          _$AIRecommendationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIRecommendationModelImplToJson(
      this,
    );
  }
}

abstract class _AIRecommendationModel implements AIRecommendationModel {
  const factory _AIRecommendationModel(
      {required final String id,
      required final String pasienId,
      required final String kontenId,
      final List<String> matchedKeywords,
      required final double relevanceScore,
      final bool isViewed,
      final DateTime? viewedAt,
      required final DateTime createdAt}) = _$AIRecommendationModelImpl;

  factory _AIRecommendationModel.fromJson(Map<String, dynamic> json) =
      _$AIRecommendationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get pasienId; // Reference to pasien_profiles collection
  @override
  String get kontenId; // Recommended konten ID
  @override
  List<String> get matchedKeywords; // Keywords that matched
  @override
  double get relevanceScore; // 0.0 to 1.0 (AI confidence score)
  @override
  bool get isViewed; // Has pasien viewed this recommendation?
  @override
  DateTime? get viewedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of AIRecommendationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIRecommendationModelImplCopyWith<_$AIRecommendationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
