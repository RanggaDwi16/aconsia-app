import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/controllers/stream_user_notifications/stream_user_notifications_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_stream_user_notification_provider.g.dart';

@riverpod
Stream<List<NotificationModel>> postStreamUserNotifications(
    PostStreamUserNotificationsRef ref,
    {required String userId}) {
  final streamUserNotifications = ref.read(streamUserNotificationsProvider);
  return streamUserNotifications(userId: userId);
}
