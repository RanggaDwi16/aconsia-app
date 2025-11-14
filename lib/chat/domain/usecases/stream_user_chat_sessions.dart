import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';

class StreamUserChatSessions {
  final ChatRepository repository;

  StreamUserChatSessions({required this.repository});

  Stream<List<ChatSessionModel>> call({
    required String userId,
    required String role,
  }) {
    return repository.streamUserChatSessions(userId: userId, role: role);
  }
}
