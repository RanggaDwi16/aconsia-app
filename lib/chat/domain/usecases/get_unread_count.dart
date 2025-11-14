import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class GetUnreadCount implements UseCase<int, GetUnreadCountParams> {
  final ChatRepository repository;

  GetUnreadCount({required this.repository});

  @override
  Future<Either<String, int>> call(GetUnreadCountParams params) {
    return repository.getUnreadCount(
      sessionId: params.sessionId,
      userId: params.userId,
    );
  }
}

class GetUnreadCountParams {
  final String sessionId;
  final String userId;

  GetUnreadCountParams({
    required this.sessionId,
    required this.userId,
  });
}
