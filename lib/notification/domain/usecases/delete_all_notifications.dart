import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAllNotifications implements UseCase<String, DeleteAllNotificationsParams> {
  final NotificationRepository repository;

  DeleteAllNotifications({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteAllNotificationsParams params) {
    return repository.deleteAllNotifications(userId: params.userId);
  }
}

class DeleteAllNotificationsParams {
  final String userId;

  DeleteAllNotificationsParams({required this.userId});
}