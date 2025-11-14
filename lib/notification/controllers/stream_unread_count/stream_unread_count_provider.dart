import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/stream_unread_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_unread_count_provider.g.dart';

@riverpod
StreamUnreadCount streamUnreadCount (StreamUnreadCountRef ref) {
  return StreamUnreadCount(
    repository: ref.read(notificationRepositoryProvider),
  );
}