import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkAsRead implements UseCase<String, MarkAsReadParams> {
  final NotificationRepository repository;

  MarkAsRead({required this.repository});

  @override
  Future<Either<String, String>> call(params) {
    return repository.markAsRead(notificationId: params.notificationId);
  }
}

class MarkAsReadParams {
  final String notificationId;

  MarkAsReadParams({required this.notificationId});
}
