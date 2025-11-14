import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkAllAsRead implements UseCase<String, MarkAllAsReadParams> {
  final NotificationRepository repository;

  MarkAllAsRead({required this.repository});

  @override
  Future<Either<String, String>> call(MarkAllAsReadParams params) {
    return repository.markAllAsRead(userId: params.userId);
  }
}

class MarkAllAsReadParams {
  final String userId;

  MarkAllAsReadParams({required this.userId});
}
