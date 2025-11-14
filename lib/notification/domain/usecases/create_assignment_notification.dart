import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class CreateAssignmentNotification implements UseCase<String, CreateAssignmentNotificationParams> {
  final NotificationRepository repository;

  CreateAssignmentNotification({required this.repository});

  @override
  Future<Either<String, String>> call(CreateAssignmentNotificationParams params) {
    return repository.createAssignmentNotification(
      pasienId: params.pasienId,
      dokterName: params.dokterName,
      kontenTitle: params.kontenTitle,
      kontenId: params.kontenId,
    );
  }
}

class CreateAssignmentNotificationParams {
  final String pasienId;
  final String dokterName;
  final String kontenTitle;
  final String kontenId;

  CreateAssignmentNotificationParams({
    required this.pasienId,
    required this.dokterName,
    required this.kontenTitle,
    required this.kontenId,
  });
}