import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/create_assignment_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_assignment_notification_provider.g.dart';

@riverpod
CreateAssignmentNotification createAssignmentNotification(
    CreateAssignmentNotificationRef ref) {
  return CreateAssignmentNotification(
    repository: ref.read(notificationRepositoryProvider),
  );
}
