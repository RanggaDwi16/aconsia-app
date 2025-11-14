import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/delete_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_notification_provider.g.dart';

@riverpod
DeleteNotification deleteNotification (DeleteNotificationRef ref) {
  return DeleteNotification(
    repository: ref.read(notificationRepositoryProvider),
  );
}