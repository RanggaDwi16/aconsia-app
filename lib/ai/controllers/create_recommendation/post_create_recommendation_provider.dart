import 'package:aconsia_app/ai/controllers/create_recommendation/create_recommendation_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/create_recommendation.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_recommendation_provider.g.dart';

@Riverpod(keepAlive: true)
class PostCreateRecommendation extends _$PostCreateRecommendation {
  @override
  FutureOr<AIRecommendationModel?> build() {
    return null;
  }

  Future<void> postCreateRecommendation({
    required AIRecommendationModel recommendationData,
    required Function(AIRecommendationModel recommendation) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    CreateRecommendation createRecommendation =
        ref.read(createRecommendationProvider);
    final result = await createRecommendation(
      CreateRecommendationParams(recommendation: recommendationData),
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        onError(failure);
      },
      (recommendation) {
        state = AsyncData(recommendation);
        onSuccess(recommendation);
      },
    );
  }
}
