import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:dartz/dartz.dart';

class SendMessage implements UseCase<ChatMessageModel, SendMessageParams> {
  final ChatRepository repository;

  SendMessage({required this.repository});

  @override
  Future<Either<String, ChatMessageModel>> call(SendMessageParams params) {
    return repository.sendMessage(
      sessionId: params.sessionId,
      senderId: params.senderId,
      senderRole: params.senderRole,
      message: params.message,
    );
  }
}

class SendMessageParams {
  final String sessionId;
  final String senderId;
  final String senderRole;
  final String message;

  SendMessageParams({
    required this.sessionId,
    required this.senderId,
    required this.senderRole,
    required this.message,
  });
}
