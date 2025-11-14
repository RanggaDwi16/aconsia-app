import 'package:aconsia_app/chat/controllers/mark_message_as_read/mark_message_as_read_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/mark_message_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_mark_message_as_read_provider.g.dart';

@Riverpod(keepAlive: true)
class PostMarkMessageAsRead extends _$PostMarkMessageAsRead {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postMarkMessageAsRead({
    required MarkMessageAsReadParams params,
    required Function(String message) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    state = const AsyncLoading();

    final markMessageAsReadUseCase = ref.read(markMessageAsReadProvider);

    final result = await markMessageAsReadUseCase(MarkMessageAsReadParams(
      messageId: params.messageId,
    ));

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
