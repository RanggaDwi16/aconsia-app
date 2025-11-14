import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteNotification implements UseCase<String, DeleteNotificationParams> {
  final NotificationRepository repository;

  DeleteNotification({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteNotificationParams params) {
    return repository.deleteNotification(notificationId: params.notificationId);
  }
}

class DeleteNotificationParams {
  final String notificationId;

  DeleteNotificationParams({required this.notificationId});
}
