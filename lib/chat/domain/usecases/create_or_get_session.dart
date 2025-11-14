import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:dartz/dartz.dart';

class CreateOrGetSession
    implements UseCase<ChatSessionModel, CreateOrGetSessionParams> {
  final ChatRepository repository;

  CreateOrGetSession({required this.repository});

  @override
  Future<Either<String, ChatSessionModel>> call(params) {
    return repository.createOrGetSession(
      dokterId: params.dokterId,
      pasienId: params.pasienId,
    );
  }
}

class CreateOrGetSessionParams {
  final String pasienId;
  final String dokterId;

  CreateOrGetSessionParams({required this.pasienId, required this.dokterId});
}
