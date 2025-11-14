// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizResultModelImpl _$$QuizResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuizResultModelImpl(
      id: json['id'] as String,
      pasienId: json['pasienId'] as String,
      kontenId: json['kontenId'] as String,
      sessionId: json['sessionId'] as String,
      overallScore: (json['overallScore'] as num).toInt(),
      status: json['status'] as String,
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      areasToImprove: (json['areasToImprove'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      summary: json['summary'] as String,
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      motivationalMessage: json['motivationalMessage'] as String?,
      questionResults: (json['questionResults'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$QuizResultModelImplToJson(
        _$QuizResultModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pasienId': instance.pasienId,
      'kontenId': instance.kontenId,
      'sessionId': instance.sessionId,
      'overallScore': instance.overallScore,
      'status': instance.status,
      'strengths': instance.strengths,
      'areasToImprove': instance.areasToImprove,
      'summary': instance.summary,
      'recommendations': instance.recommendations,
      'motivationalMessage': instance.motivationalMessage,
      'questionResults': instance.questionResults,
      'completedAt': instance.completedAt.toIso8601String(),
    };
