import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/notification/controllers/mark_as_read/post_mark_as_read_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/mark_as_read.dart';
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
        padding: const EdgeInsets.all(UiSpacing.md),
        decoration: BoxDecoration(
          color: notification.isRead ? UiPalette.white : UiPalette.blue50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead ? UiPalette.slate200 : UiPalette.blue100,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationIcon(),
            const Gap(UiSpacing.md),
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
                                : FontWeight.w700,
                            color: UiPalette.slate900,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead) ...[
                        const Gap(UiSpacing.xs),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: UiPalette.blue600,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(UiSpacing.xs),
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: UiPalette.slate700,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(UiSpacing.sm),
                  Text(
                    _formatTimestamp(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: UiPalette.slate500,
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
        iconData = Icons.assignment_outlined;
        iconColor = UiPalette.blue600;
        backgroundColor = UiPalette.blue50;
        break;
      case 'chat':
        iconData = Icons.chat_bubble_outline;
        iconColor = UiPalette.emerald600;
        backgroundColor = UiPalette.emerald50;
        break;
      case 'quiz_result':
        iconData = Icons.smart_toy_outlined;
        iconColor = UiPalette.amber600;
        backgroundColor = UiPalette.amber50;
        break;
      case 'recommendation':
        iconData = Icons.lightbulb_outline;
        iconColor = UiPalette.blue600;
        backgroundColor = UiPalette.blue50;
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = UiPalette.slate600;
        backgroundColor = UiPalette.slate100;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
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
    }
    return DateFormat('dd MMM yyyy, HH:mm').format(timestamp);
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!notification.isRead) {
      await ref.read(postMarkAsReadProvider.notifier).postMarkAsRead(
            params: MarkAsReadParams(notificationId: notification.id),
            onSuccess: (message) {},
            onError: (error) {},
          );
    }

    switch (notification.type) {
      case 'assignment':
      case 'quiz_result':
      case 'recommendation':
        if (notification.relatedId != null) {
          context.pushNamed(RouteName.detailKonten,
              extra: notification.relatedId);
        }
        break;
      case 'chat':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fitur Chat akan segera hadir!'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      default:
        break;
    }
  }
}
