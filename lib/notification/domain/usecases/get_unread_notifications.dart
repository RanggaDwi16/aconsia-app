import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetUnreadNotifications
    implements UseCase<List<NotificationModel>, GetUnreadNotificationsParams> {
  final NotificationRepository repository;

  GetUnreadNotifications({required this.repository});
  
  @override
  Future<Either<String, List<NotificationModel>>> call(GetUnreadNotificationsParams params) {
    return repository.getUnreadNotifications(userId: params.userId);
  }
}

class GetUnreadNotificationsParams {
  final String userId;

  GetUnreadNotificationsParams({required this.userId});
}
