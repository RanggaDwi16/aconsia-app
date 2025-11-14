import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/controllers/delete_message/delete_mesage_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/delete_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_message_provider.g.dart';

@Riverpod(keepAlive: true)
class PutMessage extends _$PutMessage {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> putMessage({
    required String messageId,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    DeleteMessage usecase = ref.read(deleteMessageProvider);

    final result =
        await usecase.call(DeleteMessageParams(messageId: messageId));

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (data) {
        state = AsyncData(data);
        onSuccess(data);
      },
    );
  }
}
