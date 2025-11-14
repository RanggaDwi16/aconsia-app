import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/create_chat_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_chat_notification_provider.g.dart';

@riverpod
CreateChatNotification createChatNotification (CreateChatNotificationRef ref) {
  return CreateChatNotification(
    repository: ref.read(notificationRepositoryProvider),
  );
}