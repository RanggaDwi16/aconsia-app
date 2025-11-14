import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/notification/controllers/mark_as_read/post_mark_as_read_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/mark_as_read.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationCardWidget extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationCardWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _handleNotificationTap(context, ref),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppColor.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey.shade200
                : AppColor.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon based on notification type
            _buildNotificationIcon(),
            const Gap(12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: AppColor.textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead) ...[
                        const Gap(8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(6),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  Text(
                    _formatTimestamp(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;
    Color backgroundColor;

    switch (notification.type) {
      case 'assignment':
        iconData = Icons.assignment;
        iconColor = Colors.blue;
        backgroundColor = Colors.blue.shade50;
        break;
      case 'chat':
        iconData = Icons.chat_bubble;
        iconColor = Colors.green;
        backgroundColor = Colors.green.shade50;
        break;
      case 'quiz_result':
        iconData = Icons.quiz;
        iconColor = Colors.purple;
        backgroundColor = Colors.purple.shade50;
        break;
      case 'recommendation':
        iconData = Icons.lightbulb;
        iconColor = Colors.orange;
        backgroundColor = Colors.orange.shade50;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppColor.primaryColor;
        backgroundColor = AppColor.primaryColor.withOpacity(0.1);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy, HH:mm').format(timestamp);
    }
  }

  Future<void> _handleNotificationTap(
      BuildContext context, WidgetRef ref) async {
    // Mark as read if not already
    if (!notification.isRead) {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      await ref.read(postMarkAsReadProvider.notifier).postMarkAsRead(
            params: MarkAsReadParams(
              notificationId: notification.id,
            ),
            onSuccess: (message) {
              // Notification marked as read
            },
            onError: (error) {
              // Handle error silently
            },
          );
    }

    // Navigate based on notification type
    switch (notification.type) {
      case 'assignment':
        if (notification.relatedId != null) {
          // Navigate to assignment detail or konten detail
          context.pushNamed(
            RouteName.detailKonten,
            extra: notification.relatedId,
          );
        }
        break;

      case 'chat':
        if (notification.relatedId != null) {
          // Navigate to chat room
          // context.pushNamed(
          //   RouteName.chatRoom,
          //   extra: notification.relatedId,
          // );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur Chat akan segera hadir!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        break;

      case 'quiz_result':
        if (notification.relatedId != null) {
          // Navigate to quiz result page
          // Need konten and quiz data
          context.pushNamed(
            RouteName.detailKonten,
            extra: notification.relatedId,
          );
        }
        break;

      case 'recommendation':
        if (notification.relatedId != null) {
          // Navigate to konten detail
          context.pushNamed(
            RouteName.detailKonten,
            extra: notification.relatedId,
          );
        }
        break;

      default:
        // Default action
        break;
    }
  }
}
