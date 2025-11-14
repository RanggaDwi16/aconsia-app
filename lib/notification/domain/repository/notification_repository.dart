import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<String, NotificationModel>> createNotification({
    required NotificationModel notification,
  });

  Future<Either<String, List<NotificationModel>>> getUserNotifications({
    required String userId,
    int limit = 50,
  });

  Future<Either<String, List<NotificationModel>>> getUnreadNotifications({
    required String userId,
  });

  Future<Either<String, String>> markAsRead({required String notificationId});

  Future<Either<String, String>> markAllAsRead({required String userId});

  Future<Either<String, String>> deleteNotification(
      {required String notificationId});

  Future<Either<String, String>> deleteAllNotifications(
      {required String userId});

  Future<Either<String, int>> getUnreadCount({required String userId});

  Stream<List<NotificationModel>> streamUserNotifications(
      {required String userId});

  Stream<int> streamUnreadCount({required String userId});

  Future<Either<String, String>> createChatNotification({
    required String recipientId,
    required String senderName,
    required String message,
    required String sessionId,
  });

  Future<Either<String, String>> createAssignmentNotification({
    required String pasienId,
    required String dokterName,
    required String kontenTitle,
    required String kontenId,
  });
}
