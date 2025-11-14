import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateSession implements UseCase<String, UpdateSessionParams> {
  final ChatRepository repository;

  UpdateSession({required this.repository});

  @override
  Future<Either<String, String>> call(UpdateSessionParams params) {
    return repository.updateSession(
      sessionId: params.sessionId,
      lastMessage: params.lastMessage,
      senderRole: params.senderRole,
    );
  }
}

class UpdateSessionParams {
  final String sessionId;
  final String lastMessage;
  final String senderRole;

  UpdateSessionParams({
    required this.sessionId,
    required this.lastMessage,
    required this.senderRole,
  });
}
