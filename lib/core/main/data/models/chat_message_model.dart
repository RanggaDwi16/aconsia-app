import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    required String id,
    required String sessionId, // Reference to chat_sessions collection
    required String senderId, // User ID (dokter or pasien)
    required String senderRole, // 'dokter' or 'pasien'
    required String message,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      sessionId: data['sessionId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderRole: data['senderRole'] ?? '',
      message: data['message'] ?? '',
      isRead: data['isRead'] ?? false,
      readAt: data['readAt'] != null
          ? (data['readAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(ChatMessageModel message) {
    return {
      'sessionId': message.sessionId,
      'senderId': message.senderId,
      'senderRole': message.senderRole,
      'message': message.message,
      'isRead': message.isRead,
      'readAt':
          message.readAt != null ? Timestamp.fromDate(message.readAt!) : null,
      'createdAt': Timestamp.fromDate(message.createdAt),
    };
  }
}
