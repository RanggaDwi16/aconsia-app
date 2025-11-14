import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class CreateChatNotification implements UseCase<String, CreateChatNotificationParams> {
  final NotificationRepository repository;

  CreateChatNotification({required this.repository});

  @override
  Future<Either<String, String>> call(CreateChatNotificationParams params) {
    return repository.createChatNotification(
      recipientId: params.recipientId,
      senderName: params.senderName,
      message: params.message,
      sessionId: params.sessionId,
    );
  }
}

class CreateChatNotificationParams {
  final String recipientId;
  final String senderName;
  final String message;
  final String sessionId;

  CreateChatNotificationParams({
    required this.recipientId,
    required this.senderName,
    required this.message,
    required this.sessionId,
  });
}