import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';

class StreamUserNotifications {
  final NotificationRepository repository;

  StreamUserNotifications({required this.repository});

  Stream<List<NotificationModel>> call({required String userId}) {
    return repository.streamUserNotifications(userId: userId);
  }
}
