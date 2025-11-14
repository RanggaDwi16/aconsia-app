import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/controllers/get_unread_notifications/get_unread_notifications_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/get_unread_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_unread_notifications_provider.g.dart';

@riverpod
class FetchUnreadNotifications extends _$FetchUnreadNotifications {
  @override
  FutureOr<List<NotificationModel>?> build(
      {required GetUnreadNotificationsParams params}) async {
    state = const AsyncLoading();
    GetUnreadNotifications getUnreadNotifications =
        ref.read(getUnreadNotificationsProvider);

    final result = await getUnreadNotifications(params);

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
