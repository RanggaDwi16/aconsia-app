import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_session_model.freezed.dart';
part 'chat_session_model.g.dart';

@freezed
class ChatSessionModel with _$ChatSessionModel {
  const factory ChatSessionModel({
    required String id,
    required String pasienId, // Reference to pasien_profiles collection
    required String dokterId, // Reference to dokter_profiles collection
    String? lastMessage,
    DateTime? lastMessageAt,
    @Default(0) int unreadCountPasien, // Unread count for pasien
    @Default(0) int unreadCountDokter, // Unread count for dokter
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChatSessionModel;

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory ChatSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatSessionModel(
      id: doc.id,
      pasienId: data['pasienId'] ?? '',
      dokterId: data['dokterId'] ?? '',
      lastMessage: data['lastMessage'],
      lastMessageAt: data['lastMessageAt'] != null
          ? (data['lastMessageAt'] as Timestamp).toDate()
          : null,
      unreadCountPasien: data['unreadCountPasien'] ?? 0,
      unreadCountDokter: data['unreadCountDokter'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(ChatSessionModel session) {
    return {
      'pasienId': session.pasienId,
      'dokterId': session.dokterId,
      'lastMessage': session.lastMessage,
      'lastMessageAt': session.lastMessageAt != null
          ? Timestamp.fromDate(session.lastMessageAt!)
          : null,
      'unreadCountPasien': session.unreadCountPasien,
      'unreadCountDokter': session.unreadCountDokter,
      'createdAt': Timestamp.fromDate(session.createdAt),
      'updatedAt': Timestamp.fromDate(session.updatedAt),
    };
  }
}
