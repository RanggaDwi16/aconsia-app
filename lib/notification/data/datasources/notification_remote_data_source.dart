import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRemoteDataSource {
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

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, String>> createAssignmentNotification(
      {required String pasienId,
      required String dokterName,
      required String kontenTitle,
      required String kontenId}) async {
    try {
      final notification = NotificationModel(
        id: '', // Will be set in createNotification
        userId: pasienId,
        type: 'assignment',
        title: 'Konten baru ditugaskan',
        body: '$dokterName telah menugaskan "$kontenTitle" untuk Anda',
        relatedId: kontenId,
        createdAt: DateTime.now(),
      );

      await createNotification(notification: notification);
      return const Right('Sukses membuat notifikasi assignment');
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
      final notification = NotificationModel(
        id: '', // Will be set in createNotification
        userId: recipientId,
        type: 'chat',
        title: 'Pesan baru dari $senderName',
        body: message,
        relatedId: sessionId,
        createdAt: DateTime.now(),
      );

      await createNotification(notification: notification);
      return const Right('Sukses membuat notifikasi chat');
    } catch (e) {
      return Left('Gagal membuat notifikasi chat: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, NotificationModel>> createNotification(
      {required NotificationModel notification}) async {
    try {
      final ref = firestore.collection('notifications').doc();
      final notifWithId = notification.copyWith(id: ref.id);

      await ref.set(NotificationModel.toFirestore(notifWithId));
      return Right(notifWithId);
    } catch (e) {
      return Left('Gagal membuat notifikasi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> deleteAllNotifications(
      {required String userId}) async {
    try {
      final notifs = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      final batch = firestore.batch();
      for (var doc in notifs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return const Right('Sukses menghapus semua notifikasi pengguna');
    } catch (e) {
      return Left('Gagal menghapus semua notifikasi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> deleteNotification(
      {required String notificationId}) async {
    try {
      await firestore.collection('notifications').doc(notificationId).delete();
      return const Right('Sukses menghapus notifikasi');
    } catch (e) {
      return Left('Gagal menghapus notifikasi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, int>> getUnreadCount({required String userId}) async {
    try {
      final snapshot = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return Right(snapshot.count ?? 0);
    } catch (e) {
      return Left(
          'Gagal mendapatkan jumlah notifikasi belum dibaca: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<NotificationModel>>> getUnreadNotifications(
      {required String userId}) async {
    try {
      final snapshot = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();

      return Right(notifications);
    } catch (e) {
      return Left('Gagal mendapatkan notifikasi belum dibaca: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<NotificationModel>>> getUserNotifications(
      {required String userId, int limit = 50}) async {
    try {
      final snapshot = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();

      return Right(notifications);
    } catch (e) {
      return Left('Gagal mendapatkan notifikasi pengguna: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> markAllAsRead({required String userId}) async {
    try {
      final unreadNotifs = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = firestore.batch();
      for (var doc in unreadNotifs.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      return const Right('Sukses menandai semua notifikasi sebagai dibaca');
    } catch (e) {
      return Left(
          'Gagal menandai semua notifikasi sebagai dibaca: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> markAsRead(
      {required String notificationId}) async {
    try {
      await firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
      return const Right('Sukses menandai notifikasi sebagai dibaca');
    } catch (e) {
      return Left('Gagal mark as read: ${e.toString()}');
    }
  }

  @override
  Stream<int> streamUnreadCount({required String userId}) {
    return firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Stream<List<NotificationModel>> streamUserNotifications(
      {required String userId}) {
    return firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }
}
