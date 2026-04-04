import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AssignmentCardWidget extends ConsumerWidget {
  final KontenAssignmentModel assignment;

  const AssignmentCardWidget({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kontenAsync = ref.watch(
      fetchKontenByIdProvider(kontenId: assignment.kontenId),
    );

    return kontenAsync.when(
      data: (konten) {
        if (konten == null) {
          return const SizedBox.shrink();
        }

        final totalSections = konten.jumlahBagian ?? 1;
        final currentSection = assignment.currentBagian;
        final progressPercentage =
            (currentSection / totalSections).clamp(0.0, 1.0);

        return InkWell(
          onTap: () {
            context.pushNamed(
              RouteName.assignmentDetail,
              extra: {
                'assignment': assignment,
                'konten': konten,
              },
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: UiPalette.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: assignment.isCompleted
                    ? UiPalette.emerald100
                    : UiPalette.blue100,
                width: 1.25,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (konten.gambarUrl != null && konten.gambarUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      konten.gambarUrl!,
                      width: double.infinity,
                      height: 132,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 132,
                          color: UiPalette.slate100,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 42,
                            color: UiPalette.slate400,
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 132,
                    decoration: const BoxDecoration(
                      color: UiPalette.blue50,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.article_outlined,
                        size: 52,
                        color: UiPalette.blue500,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(UiSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildStatusBadge(),
                          const Spacer(),
                          Text(
                            _formatDate(assignment.assignedAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: UiPalette.slate500,
                            ),
                          ),
                        ],
                      ),
                      const Gap(UiSpacing.sm),
                      Text(
                        konten.judul ?? 'Judul tidak tersedia',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: UiPalette.slate900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(UiSpacing.xs),
                      Text(
                        konten.jenisAnestesi ?? 'Konten pembelajaran',
                        style: const TextStyle(
                          fontSize: 13,
                          color: UiPalette.slate600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(UiSpacing.md),
                      Row(
                        children: [
                          const Icon(
                            Icons.book_outlined,
                            size: 15,
                            color: UiPalette.slate500,
                          ),
                          const Gap(UiSpacing.xs),
                          Text(
                            'Bagian $currentSection dari $totalSections',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: UiPalette.slate600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Gap(UiSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: progressPercentage,
                          minHeight: 7,
                          backgroundColor: UiPalette.slate200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            assignment.isCompleted
                                ? UiPalette.emerald600
                                : UiPalette.blue600,
                          ),
                        ),
                      ),
                      const Gap(UiSpacing.xs),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${(progressPercentage * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: assignment.isCompleted
                                ? UiPalette.emerald700
                                : UiPalette.blue600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatusBadge() {
    final isDone = assignment.isCompleted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? UiPalette.emerald50 : UiPalette.blue50,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
            color: isDone ? UiPalette.emerald100 : UiPalette.blue100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.pending_actions,
            size: 13,
            color: isDone ? UiPalette.emerald700 : UiPalette.blue600,
          ),
          const Gap(UiSpacing.xs),
          Text(
            isDone ? 'Selesai' : 'Dalam Progress',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDone ? UiPalette.emerald700 : UiPalette.blue600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: UiPalette.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UiPalette.slate200),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }
}
