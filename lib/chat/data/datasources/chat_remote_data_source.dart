import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class ChatRemoteDataSource {
  Future<Either<String, ChatSessionModel>> createOrGetSession({
    required String pasienId,
    required String dokterId,
  });

  Future<Either<String, List<ChatSessionModel>>> getUserChatSessions({
    required String userId,
    required String role, // 'dokter' or 'pasien'
  });

  Future<Either<String, String>> updateSession({
    required String sessionId,
    required String lastMessage,
    required String senderRole, // 'dokter' or 'pasien'
  });

  Future<Either<String, String>> resetUnreadCount({
    required String sessionId,
    required String role, // 'dokter' or 'pasien'
  });

  Stream<List<ChatSessionModel>> streamUserChatSessions({
    required String userId,
    required String role,
  });

  Future<Either<String, ChatMessageModel>> sendMessage({
    required String sessionId,
    required String senderId,
    required String senderRole,
    required String message,
  });

  Future<Either<String, List<ChatMessageModel>>> getMessages({
    required String sessionId,
    int limit = 50,
    DocumentSnapshot? lastDocument,
  });

  Future<Either<String, String>> markMessageAsRead({
    required String messageId,
  });

  Future<Either<String, String>> markAllMessagesAsRead({
    required String sessionId,
    required String receiverId,
  });

  Stream<List<ChatMessageModel>> streamMessages({required String sessionId});

  Future<Either<String, String>> deleteMessage({required String messageId});

  Future<Either<String, int>> getUnreadCount({
    required String sessionId,
    required String userId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, ChatSessionModel>> createOrGetSession(
      {required String pasienId, required String dokterId,}) async {
    try {
      // Check if session already exists
      final existingSession = await firestore
          .collection('chat_sessions')
          .where('pasienId', isEqualTo: pasienId)
          .where('dokterId', isEqualTo: dokterId)
          .limit(1)
          .get();

      if (existingSession.docs.isNotEmpty) {
        return Right(
          ChatSessionModel.fromFirestore(existingSession.docs.first),
        );
      }

      // Create new session
      final ref = firestore.collection('chat_sessions').doc();
      final now = DateTime.now();
      final session = ChatSessionModel(
        id: ref.id,
        pasienId: pasienId,
        dokterId: dokterId,
        createdAt: now,
        updatedAt: now,
      );

      await ref.set(ChatSessionModel.toFirestore(session));
      return Right(session);
    } catch (e) {
      return Left('Gagal membuat sesi chat: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteMessage(
      {required String messageId}) async {
    try {
      await firestore.collection('chat_messages').doc(messageId).delete();
      return const Right('Pesan berhasil dihapus');
    } catch (e) {
      return Left('Gagal menghapus pesan: $e');
    }
  }

  @override
  Future<Either<String, List<ChatMessageModel>>> getMessages(
      {required String sessionId,
      int limit = 50,
      DocumentSnapshot<Object?>? lastDocument}) async {
    try {
      Query query = firestore
          .collection('chat_messages')
          .where('sessionId', isEqualTo: sessionId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      final messages = snapshot.docs
          .map((doc) => ChatMessageModel.fromFirestore(doc))
          .toList();

      return Right(messages);
    } catch (e) {
      return Left('Gagal mengambil pesan: $e');
    }
  }

  @override
  Future<Either<String, int>> getUnreadCount(
      {required String sessionId, required String userId}) async {
    try {
      final snapshot = await firestore
          .collection('chat_messages')
          .where('sessionId', isEqualTo: sessionId)
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .count()
          .get();

      return Right(snapshot.count ?? 0);
    } catch (e) {
      return Left('Gagal mengambil jumlah pesan belum dibaca: $e');
    }
  }

  @override
  Future<Either<String, List<ChatSessionModel>>> getUserChatSessions(
      {required String userId, required String role}) async {
    try {
      final field = role == 'dokter' ? 'dokterId' : 'pasienId';
      final snapshot = await firestore
          .collection('chat_sessions')
          .where(field, isEqualTo: userId)
          .orderBy('lastMessageAt', descending: true)
          .get();

      final sessions = snapshot.docs
          .map((doc) => ChatSessionModel.fromFirestore(doc))
          .toList();

      return Right(sessions);
    } catch (e) {
      return Left('Gagal mengambil sesi chat: $e');
    }
  }

  @override
  Future<Either<String, String>> markAllMessagesAsRead(
      {required String sessionId, required String receiverId}) async {
    try {
      final unreadMessages = await firestore
          .collection('chat_messages')
          .where('sessionId', isEqualTo: sessionId)
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: receiverId)
          .get();

      final batch = firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      return const Right('Semua pesan telah ditandai sebagai dibaca');
    } catch (e) {
      return Left('Gagal menandai semua pesan sebagai dibaca: $e');
    }
  }

  @override
  Future<Either<String, String>> markMessageAsRead(
      {required String messageId}) async {
    try {
      await firestore.collection('chat_messages').doc(messageId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
      return const Right('Pesan telah ditandai sebagai dibaca');
    } catch (e) {
      return Left('Gagal menandai pesan sebagai dibaca: $e');
    }
  }

  @override
  Future<Either<String, String>> resetUnreadCount(
      {required String sessionId, required String role}) async {
    try {
      final field =
          role == 'dokter' ? 'unreadCountDokter' : 'unreadCountPasien';
      await firestore.collection('chat_sessions').doc(sessionId).update({
        field: 0,
      });
      return const Right('Jumlah pesan belum dibaca telah direset');
    } catch (e) {
      return Left('Gagal mereset jumlah pesan belum dibaca: $e');
    }
  }

  @override
  Future<Either<String, ChatMessageModel>> sendMessage(
      {required String sessionId,
      required String senderId,
      required String senderRole,
      required String message}) async {
    try {
      final ref = firestore.collection('chat_messages').doc();
      final now = DateTime.now();

      final chatMessage = ChatMessageModel(
        id: ref.id,
        sessionId: sessionId,
        senderId: senderId,
        senderRole: senderRole,
        message: message,
        createdAt: now,
      );

      await ref.set(ChatMessageModel.toFirestore(chatMessage));

      // Update session
      await updateSession(
        sessionId: sessionId,
        lastMessage: message,
        senderRole: senderRole,
      );

      return Right(chatMessage);
    } catch (e) {
      return Left('Gagal mengirim pesan: $e');
    }
  }

  @override
  Stream<List<ChatMessageModel>> streamMessages({required String sessionId}) {
    return firestore
        .collection('chat_messages')
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<ChatSessionModel>> streamUserChatSessions(
      {required String userId, required String role}) {
    final field = role == 'dokter' ? 'dokterId' : 'pasienId';
    return firestore
        .collection('chat_sessions')
        .where(field, isEqualTo: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatSessionModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<Either<String, String>> updateSession(
      {required String sessionId,
      required String lastMessage,
      required String senderRole}) async {
    try {
      final Map<String, dynamic> updates = {
        'lastMessage': lastMessage,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Increment unread count for receiver
      if (senderRole == 'dokter') {
        updates['unreadCountPasien'] = FieldValue.increment(1);
      } else {
        updates['unreadCountDokter'] = FieldValue.increment(1);
      }

      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .update(updates);
      return const Right('Sesi berhasil diperbarui');
    } catch (e) {
      return Left('Gagal update sesi: $e');
    }
  }
}
