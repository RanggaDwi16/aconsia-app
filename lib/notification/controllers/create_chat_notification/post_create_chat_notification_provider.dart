import 'package:aconsia_app/notification/controllers/create_chat_notification/create_chat_notification_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/create_chat_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_chat_notification_provider.g.dart';

@Riverpod(keepAlive: true)
class PostCreateChatNotification extends _$PostCreateChatNotification {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postCreateChatNotification({
    required CreateChatNotificationParams chat,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    CreateChatNotification createChatNotification =
        ref.read(createChatNotificationProvider);

    final result = await createChatNotification(chat);

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
