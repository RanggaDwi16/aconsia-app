import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/get_user_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_notifications_provider.g.dart';

@riverpod
GetUserNotifications getUserNotifications (GetUserNotificationsRef ref) {
  return GetUserNotifications(
    repository: ref.read(notificationRepositoryProvider),
  );
}