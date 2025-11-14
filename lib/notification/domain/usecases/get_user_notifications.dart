import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserNotifications
    implements UseCase<List<NotificationModel>, GetUserNotificationsParams> {
  final NotificationRepository repository;

  GetUserNotifications({required this.repository});

  @override
  Future<Either<String, List<NotificationModel>>> call(
      GetUserNotificationsParams params) {
    return repository.getUserNotifications(
      userId: params.userId,
      limit: params.limit,
    );
  }
}

class GetUserNotificationsParams {
  final String userId;
  final int limit;

  GetUserNotificationsParams({required this.userId, this.limit = 50});
}
