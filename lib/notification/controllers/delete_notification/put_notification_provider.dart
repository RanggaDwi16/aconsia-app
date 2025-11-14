import 'package:aconsia_app/notification/controllers/delete_notification/delete_notification_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/delete_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_notification_provider.g.dart';

@Riverpod(keepAlive: true)
class PutNotification extends _$PutNotification {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> putNotification({
    required DeleteNotificationParams params,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    DeleteNotification deleteNotification =
        ref.read(deleteNotificationProvider);

    final result = await deleteNotification(params);

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
