import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/create_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_notification_provider.g.dart';

@riverpod
CreateNotification createNotification (CreateNotificationRef ref) {
  return CreateNotification(
    repository: ref.read(notificationRepositoryProvider),
  );
}