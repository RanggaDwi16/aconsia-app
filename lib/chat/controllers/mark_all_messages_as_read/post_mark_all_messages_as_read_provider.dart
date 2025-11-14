import 'package:aconsia_app/chat/controllers/mark_all_messages_as_read/mark_all_messages_as_read_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/mark_all_messages_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_mark_all_messages_as_read_provider.g.dart';

@Riverpod(keepAlive: true)
class PostMarkAllMessagesAsRead extends _$PostMarkAllMessagesAsRead {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postMarkAllMessagesAsRead({
    required MarkAllMessagesAsReadParams params,
    required Function(String message) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    state = const AsyncLoading();

    // Assuming MarkAllMessagesAsRead is defined elsewhere and injected properly
    final markAllMessagesAsReadUseCase =
        ref.read(markAllMessagesAsReadProvider);

    final result = await markAllMessagesAsReadUseCase(
      MarkAllMessagesAsReadParams(
          receiverId: params.receiverId, sessionId: params.sessionId),
    );

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error.toString());
      },
      (data) {
        state = AsyncData(data);
        onSuccess(data);
      },
    );
  }
}
