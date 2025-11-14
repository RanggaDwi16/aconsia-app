import 'package:aconsia_app/ai/controllers/get_recommendations_by_keywords/get_recommendations_by_keywords_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_recommendations_by_keywords.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_recommendations_by_keywords_provider.g.dart';

@riverpod
class FetchRecommendationsByKeywords extends _$FetchRecommendationsByKeywords {
  @override
  FutureOr<List<AIRecommendationModel>?> build({
    required String pasienId,
    required List<String> keywords,
  }) async {
    state = const AsyncLoading();

    GetRecommendationsByKeywords getRecommendationsByKeywords =
        ref.read(getRecommendationsByKeywordsProvider);

    final result = await getRecommendationsByKeywords(
      GetRecommendationsByKeywordsParams(
        pasienId: pasienId,
        keywords: keywords,
      ),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (recommendations) {
        state = AsyncData(recommendations);
        return recommendations;
      },
    );
  }
}
