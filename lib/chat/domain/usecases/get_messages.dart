import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class GetMessages implements UseCase<List<ChatMessageModel>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessages({required this.repository});

  @override
  Future<Either<String, List<ChatMessageModel>>> call(GetMessagesParams params) {
    return repository.getMessages(sessionId: params.sessionId);
  }
}

class GetMessagesParams {
  final String sessionId;
  final int limit;
  final DocumentSnapshot? lastDocument;

  GetMessagesParams({
    required this.sessionId,
    this.limit = 50,
    this.lastDocument,
  });

}