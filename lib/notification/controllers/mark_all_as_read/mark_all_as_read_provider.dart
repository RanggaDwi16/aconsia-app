import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/mark_all_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_all_as_read_provider.g.dart';

@riverpod
MarkAllAsRead markAllAsRead (MarkAllAsReadRef ref) {
  return MarkAllAsRead(
    repository: ref.read(notificationRepositoryProvider),
  );
}