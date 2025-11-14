import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/controllers/get_user_notifications/get_user_notifications_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/get_user_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_user_notifications_provider.g.dart';

@riverpod
class FetchUserNotifications extends _$FetchUserNotifications {
  @override
  FutureOr<List<NotificationModel>?> build(
      {required GetUserNotificationsParams params}) async {
    state = const AsyncLoading();
    GetUserNotifications getUserNotifications =
        ref.read(getUserNotificationsProvider);

    final result = await getUserNotifications(params);

    return result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        return null;
      },
      (notifications) {
        state = AsyncData(notifications);
        return notifications;
      },
    );
  }
}
