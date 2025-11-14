import 'package:aconsia_app/ai/controllers/batch_create_recommendations/batch_create_recommendations_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/batch_create_recommendations.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_batch_create_recommendations_provider.g.dart';

@Riverpod(keepAlive: true)
class PostBatchCreateRecommendations extends _$PostBatchCreateRecommendations {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postBatchCreateRecommendations({
    required List<AIRecommendationModel> recommendationsData,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    BatchCreateRecommendations batchCreateRecommendations =
        ref.read(batchCreateRecommendationsProvider);
    final result = await batchCreateRecommendations(
      BatchCreateRecommendationsParams(recommendations: recommendationsData),
    );
    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        onError(failure);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
