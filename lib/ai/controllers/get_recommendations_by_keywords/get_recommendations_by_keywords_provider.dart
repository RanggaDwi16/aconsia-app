import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_recommendations_by_keywords.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_recommendations_by_keywords_provider.g.dart';

@riverpod
GetRecommendationsByKeywords getRecommendationsByKeywords (GetRecommendationsByKeywordsRef ref) {
  return GetRecommendationsByKeywords(
    repository: ref.read(aiRepositoryProvider),
  );
}