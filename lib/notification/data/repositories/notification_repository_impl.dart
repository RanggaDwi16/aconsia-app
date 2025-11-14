import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/notification/data/datasources/notification_remote_data_source.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, String>> createAssignmentNotification(
      {required String pasienId,
      required String dokterName,
      required String kontenTitle,
      required String kontenId}) async {
    try {
      final result = await remoteDataSource.createAssignmentNotification(
        pasienId: pasienId,
        dokterName: dokterName,
        kontenTitle: kontenTitle,
        kontenId: kontenId,
      );

      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal membuat notifikasi assignment: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> createChatNotification(
      {required String recipientId,
      required String senderName,
      required String message,
      required String sessionId}) async {
    try {
      final result = await remoteDataSource.createChatNotification(
        recipientId: recipientId,
        senderName: senderName,
        message: message,
        sessionId: sessionId,
      );
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal membuat notifikasi chat: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, NotificationModel>> createNotification(
      {required NotificationModel notification}) async {
    try {
      final result =
          await remoteDataSource.createNotification(notification: notification);
      return result.fold(
        (failure) => Left(failure),
        (notification) => Right(notification),
      );
    } catch (e) {
      return Left('Gagal membuat notifikasi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> deleteAllNotifications(
      {required String userId}) async {
    try {
      final result =
          await remoteDataSource.deleteAllNotifications(userId: userId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal menghapus semua notifikasi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> deleteNotification(
      {required String notificationId}) async {
    try {
      final result = await remoteDataSource.deleteNotification(
          notificationId: notificationId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal menghapus notifikasi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, int>> getUnreadCount({required String userId}) async {
    try {
      final result = await remoteDataSource.getUnreadCount(userId: userId);
      return result.fold(
        (failure) => Left(failure),
        (count) => Right(count),
      );
    } catch (e) {
      return Left(
          'Gagal mendapatkan jumlah notifikasi belum dibaca: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<NotificationModel>>> getUnreadNotifications(
      {required String userId}) async {
    try {
      final result =
          await remoteDataSource.getUnreadNotifications(userId: userId);
      return result.fold(
        (failure) => Left(failure),
        (notifications) => Right(notifications),
      );
    } catch (e) {
      return Left('Gagal mendapatkan notifikasi belum dibaca: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<NotificationModel>>> getUserNotifications(
      {required String userId, int limit = 50}) async {
    try {
      final result = await remoteDataSource.getUserNotifications(
          userId: userId, limit: limit);
      return result.fold(
        (failure) => Left(failure),
        (notifications) => Right(notifications),
      );
    } catch (e) {
      return Left('Gagal mendapatkan notifikasi pengguna: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> markAllAsRead({required String userId}) async {
    try {
      final result = await remoteDataSource.markAllAsRead(userId: userId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal mark all as read: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> markAsRead(
      {required String notificationId}) async {
    try {
      final result =
          await remoteDataSource.markAsRead(notificationId: notificationId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left('Gagal mark as read: ${e.toString()}');
    }
  }

  @override
  Stream<int> streamUnreadCount({required String userId}) {
    return remoteDataSource.streamUnreadCount(userId: userId);
  }

  @override
  Stream<List<NotificationModel>> streamUserNotifications(
      {required String userId}) {
    return remoteDataSource.streamUserNotifications(userId: userId);
  }
}
