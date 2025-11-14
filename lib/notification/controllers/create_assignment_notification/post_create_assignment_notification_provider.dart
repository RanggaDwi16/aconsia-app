import 'package:aconsia_app/notification/controllers/create_assignment_notification/create_assignment_notification_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/create_assignment_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_assignment_notification_provider.g.dart';

@Riverpod(keepAlive: true)
class PostCreateAssignmentNotification
    extends _$PostCreateAssignmentNotification {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postCreateAssignmentNotification({
    required CreateAssignmentNotificationParams assignment,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    CreateAssignmentNotification createAssignmentNotification =
        ref.read(createAssignmentNotificationProvider);

    final result = await createAssignmentNotification(assignment);

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
