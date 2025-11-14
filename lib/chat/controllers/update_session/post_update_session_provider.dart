import 'package:aconsia_app/chat/controllers/update_session/update_session_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/update_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_update_session_provider.g.dart';

@Riverpod(keepAlive: true)
class PostUpdateSession extends _$PostUpdateSession {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postUpdateSession({
    required UpdateSessionParams params,
    required Function(String message) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    state = const AsyncLoading();

    // Assuming there's an UpdateSession use case and provider
    final updateSessionUseCase = ref.read(updateSessionProvider);

    final result = await updateSessionUseCase(
      UpdateSessionParams(
        lastMessage: params.lastMessage,
        sessionId: params.sessionId,
        senderRole: params.senderRole,
      ),
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
