import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/get_unread_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_unread_notifications_provider.g.dart';

@riverpod
GetUnreadNotifications getUnreadNotifications (GetUnreadNotificationsRef ref) {
  return GetUnreadNotifications(
    repository: ref.read(notificationRepositoryProvider),
  );
}