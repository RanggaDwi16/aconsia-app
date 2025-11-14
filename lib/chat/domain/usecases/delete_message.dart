import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class DeleteMessage implements UseCase<String, DeleteMessageParams> {
  final ChatRepository repository;

  DeleteMessage({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteMessageParams params) {
    return repository.deleteMessage(messageId: params.messageId);
  }
}

class DeleteMessageParams {
  final String messageId;

  DeleteMessageParams({required this.messageId});
}