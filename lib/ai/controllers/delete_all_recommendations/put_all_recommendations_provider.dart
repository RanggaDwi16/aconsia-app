import 'package:aconsia_app/ai/controllers/delete_all_recommendations/delete_all_recommendations_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/delete_all_recommendations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_all_recommendations_provider.g.dart';

@Riverpod(keepAlive: true)
class PutAllRecommendations extends _$PutAllRecommendations {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> putAllRecommendations({
    required String pasienId,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    DeleteAllRecommendations deleteAllRecommendations =
        ref.read(deleteAllRecommendationsProvider);

    final result = await deleteAllRecommendations(
      DeleteAllRecommendationsParams(pasienId: pasienId),
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
