import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class CreateNotification
    implements UseCase<NotificationModel, CreateNotificationParams> {
  final NotificationRepository repository;

  CreateNotification({required this.repository});

  @override
  Future<Either<String, NotificationModel>> call(
      CreateNotificationParams params) {
    return repository.createNotification(notification: params.notification);
  }
}

class CreateNotificationParams {
  final NotificationModel notification;

  CreateNotificationParams({required this.notification});
}
