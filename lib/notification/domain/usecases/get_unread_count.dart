import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetUnreadCount implements UseCase<int, GetUnreadCountParams> {
  final NotificationRepository repository;

  GetUnreadCount({required this.repository});

  @override
  Future<Either<String, int>> call(GetUnreadCountParams params) {
    return repository.getUnreadCount(userId: params.userId);
  }
}

class GetUnreadCountParams {
  final String userId;

  GetUnreadCountParams({required this.userId});
}
