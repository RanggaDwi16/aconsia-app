import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class ResetUnreadCount implements UseCase<String, ResetUnreadCountParams> {
  final ChatRepository repository;

  ResetUnreadCount({required this.repository});

  @override
  Future<Either<String, String>> call(ResetUnreadCountParams params) {
    return repository.resetUnreadCount(
        sessionId: params.sessionId, role: params.role);
  }
}

class ResetUnreadCountParams {
  final String sessionId;
  final String role;

  ResetUnreadCountParams({required this.sessionId, required this.role});
}
