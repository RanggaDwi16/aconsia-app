import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId, // Recipient user ID (dokter or pasien)
    required String type, // 'chat', 'assignment', 'quiz_result', etc.
    required String title,
    required String body,
    String? relatedId, // Related document ID (kontenId, sessionId, etc.)
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Create from Firestore DocumentSnapshot
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      relatedId: data['relatedId'],
      isRead: data['isRead'] ?? false,
      readAt: data['readAt'] != null
          ? (data['readAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore format
  static Map<String, dynamic> toFirestore(NotificationModel notification) {
    return {
      'userId': notification.userId,
      'type': notification.type,
      'title': notification.title,
      'body': notification.body,
      'relatedId': notification.relatedId,
      'isRead': notification.isRead,
      'readAt': notification.readAt != null
          ? Timestamp.fromDate(notification.readAt!)
          : null,
      'createdAt': Timestamp.fromDate(notification.createdAt),
    };
  }
}
