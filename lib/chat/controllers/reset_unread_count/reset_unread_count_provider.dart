import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/reset_unread_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_unread_count_provider.g.dart';

@riverpod
ResetUnreadCount resetUnreadCount (ResetUnreadCountRef ref) {
  return ResetUnreadCount(repository: ref.read(chatRepositoryProvider));
}