import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';

class StreamUnreadCount {
  final NotificationRepository repository;

  StreamUnreadCount({required this.repository});

  Stream<int> call({required String userId}) {
    return repository.streamUnreadCount(userId: userId);
  }
}