import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class MarkAllMessagesAsRead implements UseCase<String, MarkAllMessagesAsReadParams> {
  final ChatRepository repository;

  MarkAllMessagesAsRead({required this.repository});

  @override
  Future<Either<String, String>> call(MarkAllMessagesAsReadParams params) {
    return repository.markAllMessagesAsRead(
        sessionId: params.sessionId, receiverId: params.receiverId);
  }
}

class MarkAllMessagesAsReadParams {
  final String sessionId;
  final String receiverId;

  MarkAllMessagesAsReadParams({
    required this.sessionId,
    required this.receiverId,
  });
}