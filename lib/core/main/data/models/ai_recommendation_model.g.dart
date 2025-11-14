// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIRecommendationModelImpl _$$AIRecommendationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AIRecommendationModelImpl(
      id: json['id'] as String,
      pasienId: json['pasienId'] as String,
      kontenId: json['kontenId'] as String,
      matchedKeywords: (json['matchedKeywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      isViewed: json['isViewed'] as bool? ?? false,
      viewedAt: json['viewedAt'] == null
          ? null
          : DateTime.parse(json['viewedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AIRecommendationModelImplToJson(
        _$AIRecommendationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pasienId': instance.pasienId,
      'kontenId': instance.kontenId,
      'matchedKeywords': instance.matchedKeywords,
      'relevanceScore': instance.relevanceScore,
      'isViewed': instance.isViewed,
      'viewedAt': instance.viewedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
