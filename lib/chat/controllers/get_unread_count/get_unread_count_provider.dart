import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/get_unread_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_unread_count_provider.g.dart';

@riverpod
GetUnreadCount getUnreadCount(GetUnreadCountRef ref) {
  return GetUnreadCount(
    repository: ref.read(chatRepositoryProvider),
  );
}
