import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/mark_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_as_read_provider.g.dart';

@riverpod
MarkAsRead markAsRead (MarkAsReadRef ref) {
  return MarkAsRead(
    repository: ref.read(notificationRepositoryProvider),
  );
}