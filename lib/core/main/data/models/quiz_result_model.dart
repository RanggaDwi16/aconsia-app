import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_result_model.freezed.dart';
part 'quiz_result_model.g.dart';

@freezed
class QuizResultModel with _$QuizResultModel {
  const factory QuizResultModel({
    required String id,
    required String pasienId, // Reference to pasien_profiles
    required String kontenId, // Reference to konten
    required String sessionId, // Reference to reading_sessions
    required int overallScore, // Average score 0-100
    required String status, // 'excellent', 'good', 'fair', 'needs_improvement'
    @Default([]) List<String> strengths,
    @Default([]) List<String> areasToImprove,
    required String summary,
    @Default([]) List<String> recommendations,
    String? motivationalMessage,
    @Default([])
    List<Map<String, dynamic>> questionResults, // Individual Q&A results
    required DateTime completedAt,
  }) = _QuizResultModel;

  factory QuizResultModel.fromJson(Map<String, dynamic> json) =>
      _$QuizResultModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory QuizResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizResultModel(
      id: doc.id,
      pasienId: data['pasienId'] ?? '',
      kontenId: data['kontenId'] ?? '',
      sessionId: data['sessionId'] ?? '',
      overallScore: data['overallScore'] ?? 0,
      status: data['status'] ?? 'fair',
      strengths: List<String>.from(data['strengths'] ?? []),
      areasToImprove: List<String>.from(data['areasToImprove'] ?? []),
      summary: data['summary'] ?? '',
      recommendations: List<String>.from(data['recommendations'] ?? []),
      motivationalMessage: data['motivationalMessage'],
      questionResults: List<Map<String, dynamic>>.from(
        data['questionResults'] ?? [],
      ),
      completedAt: (data['completedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(QuizResultModel result) {
    return {
      'pasienId': result.pasienId,
      'kontenId': result.kontenId,
      'sessionId': result.sessionId,
      'overallScore': result.overallScore,
      'status': result.status,
      'strengths': result.strengths,
      'areasToImprove': result.areasToImprove,
      'summary': result.summary,
      'recommendations': result.recommendations,
      'motivationalMessage': result.motivationalMessage,
      'questionResults': result.questionResults,
      'completedAt': Timestamp.fromDate(result.completedAt),
    };
  }
}
