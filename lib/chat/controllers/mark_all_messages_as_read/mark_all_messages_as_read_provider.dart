import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/mark_all_messages_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_all_messages_as_read_provider.g.dart';

@riverpod
MarkAllMessagesAsRead markAllMessagesAsRead (MarkAllMessagesAsReadRef ref) {
  return MarkAllMessagesAsRead(repository: ref.read(chatRepositoryProvider));
}