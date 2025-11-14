import 'package:aconsia_app/ai/controllers/mark_as_viewed/mark_as_viewed_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/mark_as_viewed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_mark_as_viewed_provider.g.dart';

@Riverpod(keepAlive: true)
class PostMarkAsViewed extends _$PostMarkAsViewed {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postMarkAsViewed({
    required String recommendationId,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    // Assuming MarkAsViewed use case is already defined and imported
    final markAsViewed = ref.read(markAsViewedProvider);

    final result = await markAsViewed(
      MarkAsViewedParams(recommendationId: recommendationId),
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
