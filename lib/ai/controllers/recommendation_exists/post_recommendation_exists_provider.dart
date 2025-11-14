import 'package:aconsia_app/ai/controllers/recommendation_exists/recommendation_exists_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/recommendation_exists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_recommendation_exists_provider.g.dart';

@Riverpod(keepAlive: true)
class PostRecommendationExists extends _$PostRecommendationExists {
  @override
  FutureOr<bool?> build() {
    return null;
  }

  Future<void> postRecommendationExists({
    required String pasienId,
    required String kontenId,
    required Function(bool exists) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    // Assuming RecommendationExists use case is already defined and imported
    final recommendationExists = ref.read(recommendationExistsProvider);

    final result = await recommendationExists(
      RecommendationExistsParams(
        pasienId: pasienId,
        kontenId: kontenId,
      ),
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        onError(failure);
      },
      (exists) {
        state = AsyncData(exists);
        onSuccess(exists);
      },
    );
  }
}
