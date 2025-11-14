import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/stream_user_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_user_notifications_provider.g.dart';

@riverpod
StreamUserNotifications streamUserNotifications (StreamUserNotificationsRef ref) {
  return StreamUserNotifications(
    repository: ref.read(notificationRepositoryProvider),
  );
}