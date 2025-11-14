import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/delete_all_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_all_notifications_provider.g.dart';

@riverpod
DeleteAllNotifications deleteAllNotifications (DeleteAllNotificationsRef ref) {
  return DeleteAllNotifications(repository: ref.read(notificationRepositoryProvider));
}