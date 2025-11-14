import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_stream_user_chat_sessions_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<ChatSessionModel>> postStreamUserChatSessions(
  PostStreamUserChatSessionsRef ref, {
  required String userId,
  required String role,
}) {
  final repository = ref.read(chatRepositoryProvider);
  return repository.streamUserChatSessions(userId: userId, role: role);
}
