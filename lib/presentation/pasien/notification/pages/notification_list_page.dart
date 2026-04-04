import 'package:aconsia_app/core/main/data/models/notification_model.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
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
      fetchUserNotificationsProvider(
        params: GetUserNotificationsParams(userId: uid),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: AconsiaPageBackground(
        colors: const [UiPalette.blue50, UiPalette.white],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(UiSpacing.md, UiSpacing.sm,
                  UiSpacing.md, UiSpacing.xs),
              child: AconsiaTopActionRow(
                title: 'Notifikasi',
                subtitle: 'Pembaruan aktivitas akun Anda',
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) {
                  if (notifications == null || notifications.isEmpty) {
                    return _buildEmptyState();
                  }

                  final groupedNotifications =
                      _groupNotificationsByDate(notifications);

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(
                        fetchUserNotificationsProvider(
                          params: GetUserNotificationsParams(userId: uid),
                        ),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(UiSpacing.md),
                      itemCount: groupedNotifications.length,
                      itemBuilder: (context, index) {
                        final group = groupedNotifications[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: UiSpacing.sm,
                                top: index == 0 ? 0 : UiSpacing.md,
                              ),
                              child: Text(
                                group['label'] as String,
                                style: UiTypography.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: UiPalette.slate600,
                                ),
                              ),
                            ),
                            ...((group['notifications']
                                    as List<NotificationModel>)
                                .map((notification) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: UiSpacing.sm),
                                child: NotificationCardWidget(
                                    notification: notification),
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
            ),
          ],
        ),
      ),
      ),
    );
  }

  List<Map<String, dynamic>> _groupNotificationsByDate(
    List<NotificationModel> notifications,
  ) {
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

    for (final notification in notifications) {
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

    return groups.entries
        .where((entry) => entry.value.isNotEmpty)
        .map(
          (entry) => {
            'label': entry.key,
            'notifications': entry.value,
          },
        )
        .toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.xl),
        child: AconsiaCardSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_none,
                  size: 64, color: UiPalette.slate300),
              const Gap(UiSpacing.md),
              const Text(
                'Belum Ada Notifikasi',
                style: UiTypography.title,
                textAlign: TextAlign.center,
              ),
              const Gap(UiSpacing.sm),
              const Text(
                'Notifikasi akan muncul di sini saat ada pembaruan baru.',
                style: UiTypography.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.xl),
        child: AconsiaCardSurface(
          borderColor: UiPalette.red600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: UiPalette.red600),
              const Gap(UiSpacing.md),
              const Text(
                'Terjadi Kesalahan',
                style: UiTypography.title,
                textAlign: TextAlign.center,
              ),
              const Gap(UiSpacing.sm),
              Text(
                error,
                style: UiTypography.body.copyWith(color: UiPalette.red600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
