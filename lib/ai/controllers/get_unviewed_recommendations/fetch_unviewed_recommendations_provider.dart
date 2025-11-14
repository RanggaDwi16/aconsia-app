import 'package:aconsia_app/ai/controllers/get_unviewed_recommendations/get_unviewed_recommendations_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_unviewed_recommendations.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_unviewed_recommendations_provider.g.dart';

@riverpod
class FetchUnviewedRecommendations extends _$FetchUnviewedRecommendations {
  @override
  FutureOr<List<AIRecommendationModel>?> build({
    required String pasienId,
  }) async {
    state = const AsyncLoading();

    GetUnviewedRecommendations getUnviewedRecommendations =
        ref.read(getUnviewedRecommendationsProvider);

    final result = await getUnviewedRecommendations(
      GetUnviewedRecommendationsParams(pasienId: pasienId),
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
