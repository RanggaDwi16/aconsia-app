import 'package:aconsia_app/chat/controllers/send_message/send_message_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/send_message.dart';
import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_send_message_provider.g.dart';

@Riverpod(keepAlive: true)
class PostSendMessage extends _$PostSendMessage {
  @override
  FutureOr<ChatMessageModel?> build() {
    return null;
  }

  Future<void> postSendMessage({
    required ChatMessageModel params,
    required Function(ChatMessageModel message) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    state = const AsyncLoading();

    final sendMessageUseCase = ref.read(sendMessageProvider);

    final result = await sendMessageUseCase(
      SendMessageParams(
        message: params.message,
        sessionId: params.sessionId,
        senderRole: params.senderRole,
        senderId: params.senderId,
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
