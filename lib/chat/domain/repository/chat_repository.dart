import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
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
