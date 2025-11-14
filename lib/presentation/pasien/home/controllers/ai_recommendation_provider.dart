import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_recommendation_provider.g.dart';

/// Model for recommendation with relevance score
class RecommendationItem {
  final KontenModel konten;
  final double relevanceScore;
  final List<String> matchedKeywords;
  final String reason;

  RecommendationItem({
    required this.konten,
    required this.relevanceScore,
    required this.matchedKeywords,
    required this.reason,
  });
}

/// Provider to get AI recommendations based on:
/// 1. Unread konten (belum ada quiz result)
/// 2. Keyword matching (pasien AI keywords vs konten AI keywords)
/// 3. Sorted by relevance score
@riverpod
class FetchAiRecommendations extends _$FetchAiRecommendations {
  @override
  Future<List<RecommendationItem>> build({
    required String pasienId,
    int limit = 3,
  }) async {
    // Get pasien profile to access AI keywords
    final pasienProfile = await ref.read(
      fetchPasienProfileProvider(pasienId: pasienId).future,
    );

    if (pasienProfile == null || pasienProfile.dokterId == null) {
      return [];
    }

    // Get all konten from dokter
    final allKonten = await ref.read(
      fetchKontenByDokterIdProvider(dokterId: pasienProfile.dokterId!).future,
    );

    if (allKonten == null || allKonten.isEmpty) {
      return [];
    }

    // Filter unread konten (konten yang belum ada quiz result)
    final recommendations = <RecommendationItem>[];

    for (var konten in allKonten) {
      // Check if konten has been completed (has quiz result)
      final quizResult = await ref.read(
        fetchQuizResultByKontenProvider(
          pasienId: pasienId,
          kontenId: konten.id ?? '',
        ).future,
      );

      // Only recommend unread konten
      if (quizResult == null && konten.id != null) {
        // Parse AI keywords from string to list
        final pasienKeywordList = (pasienProfile.aiKeywords ?? []);
        final kontenKeywordList = konten.aiKeywords != null
            ? konten.aiKeywords!
                .split(',')
                .map((k) => k.trim())
                .where((k) => k.isNotEmpty)
                .toList()
            : <String>[];

        // Calculate relevance score based on keyword matching
        final score = _calculateRelevanceScore(
          pasienKeywordList,
          kontenKeywordList,
        );

        final matchedKeywords = _getMatchedKeywords(
          pasienKeywordList,
          kontenKeywordList,
        );

        String reason;
        if (matchedKeywords.isNotEmpty) {
          reason = 'Cocok dengan kebutuhan: ${matchedKeywords.join(", ")}';
        } else {
          reason = 'Materi penting untuk dipelajari';
        }

        recommendations.add(RecommendationItem(
          konten: konten,
          relevanceScore: score,
          matchedKeywords: matchedKeywords,
          reason: reason,
        ));
      }
    }

    // Sort by relevance score (highest first)
    recommendations
        .sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    // Return top N recommendations
    return recommendations.take(limit).toList();
  }

  /// Calculate relevance score based on keyword matching
  double _calculateRelevanceScore(
    List<String> pasienKeywords,
    List<String> kontenKeywords,
  ) {
    if (pasienKeywords.isEmpty || kontenKeywords.isEmpty) {
      return 50.0; // Default score for konten without keywords
    }

    // Count matched keywords
    int matchCount = 0;
    for (var pasienKey in pasienKeywords) {
      for (var kontenKey in kontenKeywords) {
        if (pasienKey.toLowerCase() == kontenKey.toLowerCase()) {
          matchCount++;
        }
      }
    }

    // Calculate percentage match
    final maxPossibleMatches = pasienKeywords.length;
    final matchPercentage = (matchCount / maxPossibleMatches) * 100;

    // Base score 50 + match percentage (max 100)
    return 50.0 + (matchPercentage / 2);
  }

  /// Get list of matched keywords between pasien and konten
  List<String> _getMatchedKeywords(
    List<String> pasienKeywords,
    List<String> kontenKeywords,
  ) {
    final matched = <String>[];

    for (var pasienKey in pasienKeywords) {
      for (var kontenKey in kontenKeywords) {
        if (pasienKey.toLowerCase() == kontenKey.toLowerCase() &&
            !matched.contains(pasienKey)) {
          matched.add(pasienKey);
        }
      }
    }

    return matched;
  }
}

/// Provider to get all unread konten (for All Recommendations page)
@riverpod
class FetchAllUnreadKonten extends _$FetchAllUnreadKonten {
  @override
  Future<List<RecommendationItem>> build({required String pasienId}) async {
    // Get pasien profile
    final pasienProfile = await ref.read(
      fetchPasienProfileProvider(pasienId: pasienId).future,
    );

    if (pasienProfile == null || pasienProfile.dokterId == null) {
      return [];
    }

    // Get all konten from dokter
    final allKonten = await ref.read(
      fetchKontenByDokterIdProvider(dokterId: pasienProfile.dokterId!).future,
    );

    if (allKonten == null || allKonten.isEmpty) {
      return [];
    }

    // Filter unread konten and create RecommendationItems
    final recommendations = <RecommendationItem>[];

    for (var konten in allKonten) {
      final quizResult = await ref.read(
        fetchQuizResultByKontenProvider(
          pasienId: pasienId,
          kontenId: konten.id ?? '',
        ).future,
      );

      // Only recommend unread konten
      if (quizResult == null && konten.id != null) {
        // Parse AI keywords from string to list
        final pasienKeywordList = (pasienProfile.aiKeywords ?? []);
        final kontenKeywordList = konten.aiKeywords != null
            ? konten.aiKeywords!
                .split(',')
                .map((k) => k.trim())
                .where((k) => k.isNotEmpty)
                .toList()
            : <String>[];

        // Calculate relevance score based on keyword matching
        final score = _calculateRelevanceScore(
          pasienKeywordList,
          kontenKeywordList,
        );

        final matchedKeywords = _getMatchedKeywords(
          pasienKeywordList,
          kontenKeywordList,
        );

        String reason;
        if (matchedKeywords.isNotEmpty) {
          reason = 'Cocok dengan kebutuhan: ${matchedKeywords.join(", ")}';
        } else {
          reason = 'Materi penting untuk dipelajari';
        }

        recommendations.add(RecommendationItem(
          konten: konten,
          relevanceScore: score,
          matchedKeywords: matchedKeywords,
          reason: reason,
        ));
      }
    }

    // Sort by relevance score (highest first)
    recommendations
        .sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    return recommendations;
  }

  /// Calculate relevance score based on keyword matching
  double _calculateRelevanceScore(
    List<String> pasienKeywords,
    List<String> kontenKeywords,
  ) {
    if (pasienKeywords.isEmpty || kontenKeywords.isEmpty) {
      return 50.0; // Default score for konten without keywords
    }

    // Count matched keywords
    int matchCount = 0;
    for (var pasienKey in pasienKeywords) {
      for (var kontenKey in kontenKeywords) {
        if (pasienKey.toLowerCase() == kontenKey.toLowerCase()) {
          matchCount++;
        }
      }
    }

    // Calculate percentage match
    final maxPossibleMatches = pasienKeywords.length;
    final matchPercentage = (matchCount / maxPossibleMatches) * 100;

    // Base score 50 + match percentage (max 100)
    return 50.0 + (matchPercentage / 2);
  }

  /// Get list of matched keywords between pasien and konten
  List<String> _getMatchedKeywords(
    List<String> pasienKeywords,
    List<String> kontenKeywords,
  ) {
    final matched = <String>[];

    for (var pasienKey in pasienKeywords) {
      for (var kontenKey in kontenKeywords) {
        if (pasienKey.toLowerCase() == kontenKey.toLowerCase() &&
            !matched.contains(pasienKey)) {
          matched.add(pasienKey);
        }
      }
    }

    return matched;
  }
}
