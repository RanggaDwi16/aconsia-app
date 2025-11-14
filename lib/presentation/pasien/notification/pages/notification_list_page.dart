import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/notification/controllers/get_user_notifications/fetch_user_notifications_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/get_user_notifications.dart';
import 'package:aconsia_app/presentation/pasien/notification/widgets/notification_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class NotificationListPage extends ConsumerWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final notificationsAsync = ref.watch(
      fetchUserNotificationsProvider(params: GetUserNotificationsParams(userId: uid))
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifikasi',
        centertitle: true,
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications == null || notifications.isEmpty) {
            return _buildEmptyState();
          }

          // Group notifications by date
          final groupedNotifications = _groupNotificationsByDate(notifications);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fetchUserNotificationsProvider(params: GetUserNotificationsParams(userId: uid)));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedNotifications.length,
              itemBuilder: (context, index) {
                final group = groupedNotifications[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding:  EdgeInsets.only(
                          bottom: 12, top: index == 0 ? 0 : 16),
                      child: Text(
                        group['label'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textGrayColor,
                        ),
                      ),
                    ),
                    // Notifications in this group
                    ...((group['notifications'] as List<NotificationModel>)
                        .map((notification) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: NotificationCardWidget(
                          notification: notification,
                        ),
                      );
                    }).toList()),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  List<Map<String, dynamic>> _groupNotificationsByDate(
      List<NotificationModel> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));

    final Map<String, List<NotificationModel>> groups = {
      'Hari Ini': [],
      'Kemarin': [],
      'Minggu Ini': [],
      'Sebelumnya': [],
    };

    for (var notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      if (notificationDate.isAtSameMomentAs(today)) {
        groups['Hari Ini']!.add(notification);
      } else if (notificationDate.isAtSameMomentAs(yesterday)) {
        groups['Kemarin']!.add(notification);
      } else if (notificationDate.isAfter(thisWeekStart) &&
          notificationDate.isBefore(yesterday)) {
        groups['Minggu Ini']!.add(notification);
      } else {
        groups['Sebelumnya']!.add(notification);
      }
    }

    // Convert to list and filter empty groups
    return groups.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => {
              'label': entry.key,
              'notifications': entry.value,
            })
        .toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const Gap(24),
            const Text(
              'Belum Ada Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'Notifikasi akan muncul di sini saat ada pembaruan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade300,
            ),
            const Gap(24),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
