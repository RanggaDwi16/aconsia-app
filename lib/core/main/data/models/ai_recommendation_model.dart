import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_recommendation_model.freezed.dart';
part 'ai_recommendation_model.g.dart';

@freezed
class AIRecommendationModel with _$AIRecommendationModel {
  const factory AIRecommendationModel({
    required String id,
    required String pasienId, // Reference to pasien_profiles collection
    required String kontenId, // Recommended konten ID
    @Default([]) List<String> matchedKeywords, // Keywords that matched
    required double relevanceScore, // 0.0 to 1.0 (AI confidence score)
    @Default(false) bool isViewed, // Has pasien viewed this recommendation?
    DateTime? viewedAt,
    required DateTime createdAt,
  }) = _AIRecommendationModel;

  factory AIRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$AIRecommendationModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory AIRecommendationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AIRecommendationModel(
      id: doc.id,
      pasienId: data['pasienId'] ?? '',
      kontenId: data['kontenId'] ?? '',
      matchedKeywords: List<String>.from(data['matchedKeywords'] ?? []),
      relevanceScore: (data['relevanceScore'] ?? 0.0).toDouble(),
      isViewed: data['isViewed'] ?? false,
      viewedAt: data['viewedAt'] != null
          ? (data['viewedAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(
      AIRecommendationModel recommendation) {
    return {
      'pasienId': recommendation.pasienId,
      'kontenId': recommendation.kontenId,
      'matchedKeywords': recommendation.matchedKeywords,
      'relevanceScore': recommendation.relevanceScore,
      'isViewed': recommendation.isViewed,
      'viewedAt': recommendation.viewedAt != null
          ? Timestamp.fromDate(recommendation.viewedAt!)
          : null,
      'createdAt': Timestamp.fromDate(recommendation.createdAt),
    };
  }
}
