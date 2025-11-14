import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class MarkMessageAsRead implements UseCase<String, MarkMessageAsReadParams> {
  final ChatRepository repository;

  MarkMessageAsRead({required this.repository});

  @override
  Future<Either<String, String>> call(MarkMessageAsReadParams params) {
    return repository.markMessageAsRead(messageId: params.messageId);
  }
}

class MarkMessageAsReadParams {
  final String messageId;

  MarkMessageAsReadParams({required this.messageId});
}