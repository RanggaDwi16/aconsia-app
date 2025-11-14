import 'package:aconsia_app/chat/controllers/reset_unread_count/reset_unread_count_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/reset_unread_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_reset_unread_count_provider.g.dart';

@Riverpod(keepAlive: true)
class PostResetUnreadCount extends _$PostResetUnreadCount {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postResetUnreadCount({
    required ResetUnreadCountParams params,
    required Function(String message) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    state = const AsyncLoading();

    // Assuming ResetUnreadCount use case is provided elsewhere
    final resetUnreadCountUseCase = ref.read(resetUnreadCountProvider);

    final result = await resetUnreadCountUseCase(
      ResetUnreadCountParams(role: params.role, sessionId: params.sessionId),
    );

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);

        onError(error.toString());
        return null;
      },
      (data) {
        state = AsyncData(data);

        onSuccess(data);
        return data;
      },
    );
  }
}
