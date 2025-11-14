import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/mark_message_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_message_as_read_provider.g.dart';

@riverpod
MarkMessageAsRead markMessageAsRead (MarkMessageAsReadRef ref) {
  return MarkMessageAsRead(repository: ref.read(chatRepositoryProvider));
}