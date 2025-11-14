import 'package:aconsia_app/ai/controllers/delete_recommendation/delete_recommendation_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/delete_recommendation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_recommendation_provider.g.dart';

@Riverpod(keepAlive: true)
class PutRecommendation extends _$PutRecommendation {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> putRecommendation({
    required String recommendationId,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    DeleteRecommendation deleteRecommendation =
        ref.read(deleteRecommendationProvider);

    final result = await deleteRecommendation(
      DeleteRecommendationParams(recommendationId: recommendationId),
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
