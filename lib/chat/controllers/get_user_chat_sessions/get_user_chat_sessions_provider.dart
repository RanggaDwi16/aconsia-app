import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/get_user_chat_sessions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_chat_sessions_provider.g.dart';

@riverpod
GetUserChatSessions getUserChatSessions(GetUserChatSessionsRef ref) {
  return GetUserChatSessions(
    repository: ref.read(chatRepositoryProvider),
  );
}
