import 'package:aconsia_app/ai/controllers/clear_old_recommendations/clear_old_recommendations_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/clear_old_recommendations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_clear_old_recommendations_provider.g.dart';

@Riverpod(keepAlive: true)
class PostClearOldRecommendations extends _$PostClearOldRecommendations {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postClearOldRecommendations({
    required int daysOld,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    ClearOldRecommendations clearOldRecommendations =
        ref.read(clearOldRecommendationsProvider);
    final result = await clearOldRecommendations(
      ClearOldRecommendationsParams(daysOld: daysOld),
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
