import 'package:aconsia_app/chat/data/datasources/chat_remote_data_source.dart';
import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, ChatSessionModel>> createOrGetSession({
    required String pasienId,
    required String dokterId,
  }) async {
    try {
      final result = await remoteDataSource.createOrGetSession(
          pasienId: pasienId, dokterId: dokterId);
      return result.fold(
        (failure) => Left(failure),
        (session) => Right(session),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteMessage(
      {required String messageId}) async {
    try {
      final result = await remoteDataSource.deleteMessage(messageId: messageId);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<ChatMessageModel>>> getMessages(
      {required String sessionId,
      int limit = 50,
      DocumentSnapshot<Object?>? lastDocument}) async {
    try {
      final result = await remoteDataSource.getMessages(
          sessionId: sessionId, limit: limit, lastDocument: lastDocument);
      return result.fold(
        (failure) => Left(failure),
        (messages) => Right(messages),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, int>> getUnreadCount({
    required String sessionId,
    required String userId,
  }) async {
    try {
      final result = await remoteDataSource.getUnreadCount(
          sessionId: sessionId, userId: userId);
      return result.fold(
        (failure) => Left(failure),
        (count) => Right(count),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<ChatSessionModel>>> getUserChatSessions(
      {required String userId, required String role}) async {
    try {
      final result = await remoteDataSource.getUserChatSessions(
          userId: userId, role: role);
      return result.fold(
        (failure) => Left(failure),
        (sessions) => Right(sessions),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> markAllMessagesAsRead(
      {required String sessionId, required String receiverId}) async {
    try {
      final result = await remoteDataSource.markAllMessagesAsRead(
          sessionId: sessionId, receiverId: receiverId);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> markMessageAsRead(
      {required String messageId}) async {
    try {
      final result =
          await remoteDataSource.markMessageAsRead(messageId: messageId);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> resetUnreadCount(
      {required String sessionId, required String role}) async {
    try {
      final result = await remoteDataSource.resetUnreadCount(
          sessionId: sessionId, role: role);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ChatMessageModel>> sendMessage(
      {required String sessionId,
      required String senderId,
      required String senderRole,
      required String message}) async {
    try {
      final result = await remoteDataSource.sendMessage(
          sessionId: sessionId,
          senderId: senderId,
          senderRole: senderRole,
          message: message);
      return result.fold(
        (failure) => Left(failure),
        (chatMessage) => Right(chatMessage),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<List<ChatMessageModel>> streamMessages({required String sessionId}) {
    return remoteDataSource.streamMessages(sessionId: sessionId);
  }

  @override
  Stream<List<ChatSessionModel>> streamUserChatSessions(
      {required String userId, required String role}) {
    return remoteDataSource.streamUserChatSessions(userId: userId, role: role);
  }

  @override
  Future<Either<String, String>> updateSession(
      {required String sessionId,
      required String lastMessage,
      required String senderRole}) async {
    try {
      final result = await remoteDataSource.updateSession(
          sessionId: sessionId,
          lastMessage: lastMessage,
          senderRole: senderRole);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
