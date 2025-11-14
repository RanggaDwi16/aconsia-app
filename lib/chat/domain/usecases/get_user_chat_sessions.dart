import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:dartz/dartz.dart';

class GetUserChatSessions
    implements UseCase<List<ChatSessionModel>, GetUserChatSessionsParams> {
  final ChatRepository repository;

  GetUserChatSessions({required this.repository});

  @override
  Future<Either<String, List<ChatSessionModel>>> call(
      GetUserChatSessionsParams params) {
    return repository.getUserChatSessions(
        userId: params.userId, role: params.role);
  }
}

class GetUserChatSessionsParams {
  final String userId;
  final String role;

  GetUserChatSessionsParams({required this.userId, required this.role});
}
