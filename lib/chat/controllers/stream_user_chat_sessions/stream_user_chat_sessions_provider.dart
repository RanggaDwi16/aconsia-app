import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/stream_user_chat_sessions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_user_chat_sessions_provider.g.dart';

@riverpod
StreamUserChatSessions streamUserChatSessions (StreamUserChatSessionsRef ref) {
  return StreamUserChatSessions(repository: ref.read(chatRepositoryProvider));
}