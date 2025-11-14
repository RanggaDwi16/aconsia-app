// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuizResultModel _$QuizResultModelFromJson(Map<String, dynamic> json) {
  return _QuizResultModel.fromJson(json);
}

/// @nodoc
mixin _$QuizResultModel {
  String get id => throw _privateConstructorUsedError;
  String get pasienId =>
      throw _privateConstructorUsedError; // Reference to pasien_profiles
  String get kontenId =>
      throw _privateConstructorUsedError; // Reference to konten
  String get sessionId =>
      throw _privateConstructorUsedError; // Reference to reading_sessions
  int get overallScore =>
      throw _privateConstructorUsedError; // Average score 0-100
  String get status =>
      throw _privateConstructorUsedError; // 'excellent', 'good', 'fair', 'needs_improvement'
  List<String> get strengths => throw _privateConstructorUsedError;
  List<String> get areasToImprove => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  String? get motivationalMessage => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get questionResults =>
      throw _privateConstructorUsedError; // Individual Q&A results
  DateTime get completedAt => throw _privateConstructorUsedError;

  /// Serializes this QuizResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResultModelCopyWith<QuizResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResultModelCopyWith<$Res> {
  factory $QuizResultModelCopyWith(
          QuizResultModel value, $Res Function(QuizResultModel) then) =
      _$QuizResultModelCopyWithImpl<$Res, QuizResultModel>;
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      String sessionId,
      int overallScore,
      String status,
      List<String> strengths,
      List<String> areasToImprove,
      String summary,
      List<String> recommendations,
      String? motivationalMessage,
      List<Map<String, dynamic>> questionResults,
      DateTime completedAt});
}

/// @nodoc
class _$QuizResultModelCopyWithImpl<$Res, $Val extends QuizResultModel>
    implements $QuizResultModelCopyWith<$Res> {
  _$QuizResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? sessionId = null,
    Object? overallScore = null,
    Object? status = null,
    Object? strengths = null,
    Object? areasToImprove = null,
    Object? summary = null,
    Object? recommendations = null,
    Object? motivationalMessage = freezed,
    Object? questionResults = null,
    Object? completedAt = null,
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
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      strengths: null == strengths
          ? _value.strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areasToImprove: null == areasToImprove
          ? _value.areasToImprove
          : areasToImprove // ignore: cast_nullable_to_non_nullable
              as List<String>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      motivationalMessage: freezed == motivationalMessage
          ? _value.motivationalMessage
          : motivationalMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      questionResults: null == questionResults
          ? _value.questionResults
          : questionResults // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizResultModelImplCopyWith<$Res>
    implements $QuizResultModelCopyWith<$Res> {
  factory _$$QuizResultModelImplCopyWith(_$QuizResultModelImpl value,
          $Res Function(_$QuizResultModelImpl) then) =
      __$$QuizResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pasienId,
      String kontenId,
      String sessionId,
      int overallScore,
      String status,
      List<String> strengths,
      List<String> areasToImprove,
      String summary,
      List<String> recommendations,
      String? motivationalMessage,
      List<Map<String, dynamic>> questionResults,
      DateTime completedAt});
}

/// @nodoc
class __$$QuizResultModelImplCopyWithImpl<$Res>
    extends _$QuizResultModelCopyWithImpl<$Res, _$QuizResultModelImpl>
    implements _$$QuizResultModelImplCopyWith<$Res> {
  __$$QuizResultModelImplCopyWithImpl(
      _$QuizResultModelImpl _value, $Res Function(_$QuizResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pasienId = null,
    Object? kontenId = null,
    Object? sessionId = null,
    Object? overallScore = null,
    Object? status = null,
    Object? strengths = null,
    Object? areasToImprove = null,
    Object? summary = null,
    Object? recommendations = null,
    Object? motivationalMessage = freezed,
    Object? questionResults = null,
    Object? completedAt = null,
  }) {
    return _then(_$QuizResultModelImpl(
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
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      overallScore: null == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      strengths: null == strengths
          ? _value._strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      areasToImprove: null == areasToImprove
          ? _value._areasToImprove
          : areasToImprove // ignore: cast_nullable_to_non_nullable
              as List<String>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      motivationalMessage: freezed == motivationalMessage
          ? _value.motivationalMessage
          : motivationalMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      questionResults: null == questionResults
          ? _value._questionResults
          : questionResults // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizResultModelImpl implements _QuizResultModel {
  const _$QuizResultModelImpl(
      {required this.id,
      required this.pasienId,
      required this.kontenId,
      required this.sessionId,
      required this.overallScore,
      required this.status,
      final List<String> strengths = const [],
      final List<String> areasToImprove = const [],
      required this.summary,
      final List<String> recommendations = const [],
      this.motivationalMessage,
      final List<Map<String, dynamic>> questionResults = const [],
      required this.completedAt})
      : _strengths = strengths,
        _areasToImprove = areasToImprove,
        _recommendations = recommendations,
        _questionResults = questionResults;

  factory _$QuizResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizResultModelImplFromJson(json);

  @override
  final String id;
  @override
  final String pasienId;
// Reference to pasien_profiles
  @override
  final String kontenId;
// Reference to konten
  @override
  final String sessionId;
// Reference to reading_sessions
  @override
  final int overallScore;
// Average score 0-100
  @override
  final String status;
// 'excellent', 'good', 'fair', 'needs_improvement'
  final List<String> _strengths;
// 'excellent', 'good', 'fair', 'needs_improvement'
  @override
  @JsonKey()
  List<String> get strengths {
    if (_strengths is EqualUnmodifiableListView) return _strengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strengths);
  }

  final List<String> _areasToImprove;
  @override
  @JsonKey()
  List<String> get areasToImprove {
    if (_areasToImprove is EqualUnmodifiableListView) return _areasToImprove;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areasToImprove);
  }

  @override
  final String summary;
  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final String? motivationalMessage;
  final List<Map<String, dynamic>> _questionResults;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get questionResults {
    if (_questionResults is EqualUnmodifiableListView) return _questionResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questionResults);
  }

// Individual Q&A results
  @override
  final DateTime completedAt;

  @override
  String toString() {
    return 'QuizResultModel(id: $id, pasienId: $pasienId, kontenId: $kontenId, sessionId: $sessionId, overallScore: $overallScore, status: $status, strengths: $strengths, areasToImprove: $areasToImprove, summary: $summary, recommendations: $recommendations, motivationalMessage: $motivationalMessage, questionResults: $questionResults, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResultModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pasienId, pasienId) ||
                other.pasienId == pasienId) &&
            (identical(other.kontenId, kontenId) ||
                other.kontenId == kontenId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._strengths, _strengths) &&
            const DeepCollectionEquality()
                .equals(other._areasToImprove, _areasToImprove) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.motivationalMessage, motivationalMessage) ||
                other.motivationalMessage == motivationalMessage) &&
            const DeepCollectionEquality()
                .equals(other._questionResults, _questionResults) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pasienId,
      kontenId,
      sessionId,
      overallScore,
      status,
      const DeepCollectionEquality().hash(_strengths),
      const DeepCollectionEquality().hash(_areasToImprove),
      summary,
      const DeepCollectionEquality().hash(_recommendations),
      motivationalMessage,
      const DeepCollectionEquality().hash(_questionResults),
      completedAt);

  /// Create a copy of QuizResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResultModelImplCopyWith<_$QuizResultModelImpl> get copyWith =>
      __$$QuizResultModelImplCopyWithImpl<_$QuizResultModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizResultModelImplToJson(
      this,
    );
  }
}

abstract class _QuizResultModel implements QuizResultModel {
  const factory _QuizResultModel(
      {required final String id,
      required final String pasienId,
      required final String kontenId,
      required final String sessionId,
      required final int overallScore,
      required final String status,
      final List<String> strengths,
      final List<String> areasToImprove,
      required final String summary,
      final List<String> recommendations,
      final String? motivationalMessage,
      final List<Map<String, dynamic>> questionResults,
      required final DateTime completedAt}) = _$QuizResultModelImpl;

  factory _QuizResultModel.fromJson(Map<String, dynamic> json) =
      _$QuizResultModelImpl.fromJson;

  @override
  String get id;
  @override
  String get pasienId; // Reference to pasien_profiles
  @override
  String get kontenId; // Reference to konten
  @override
  String get sessionId; // Reference to reading_sessions
  @override
  int get overallScore; // Average score 0-100
  @override
  String get status; // 'excellent', 'good', 'fair', 'needs_improvement'
  @override
  List<String> get strengths;
  @override
  List<String> get areasToImprove;
  @override
  String get summary;
  @override
  List<String> get recommendations;
  @override
  String? get motivationalMessage;
  @override
  List<Map<String, dynamic>> get questionResults; // Individual Q&A results
  @override
  DateTime get completedAt;

  /// Create a copy of QuizResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResultModelImplCopyWith<_$QuizResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
