import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';

class StreamMessages {
  final ChatRepository repository;

  StreamMessages({required this.repository});

  Stream<List<ChatMessageModel>> call({required String sessionId}) {
    return repository.streamMessages(sessionId: sessionId);
  }
}