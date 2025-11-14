import 'package:aconsia_app/notification/controllers/delete_all_notifications/delete_all_notifications_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/delete_all_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_all_notifications_provider.g.dart';

@Riverpod(keepAlive: true)
class PutAllNotifications extends _$PutAllNotifications {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> putAllNotifications({
    required DeleteAllNotificationsParams params,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    DeleteAllNotifications deleteAllNotifications =
        ref.read(deleteAllNotificationsProvider);

    final result = await deleteAllNotifications(params);

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
