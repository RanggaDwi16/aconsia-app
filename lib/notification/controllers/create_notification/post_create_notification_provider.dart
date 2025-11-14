import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/controllers/create_notification/create_notification_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/create_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_notification_provider.g.dart';

@Riverpod(keepAlive: true)
class PostCreateNotification extends _$PostCreateNotification {
  @override
  FutureOr<NotificationModel?> build() {
    return null;
  }

  Future<void> postCreateNotification({
    required CreateNotificationParams params,
    required Function(NotificationModel notification) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    CreateNotification createNotification =
        ref.read(createNotificationProvider);

    final result = await createNotification(params);

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (notification) {
        state = AsyncData(notification);
        onSuccess(notification);
      },
    );
  }
}
