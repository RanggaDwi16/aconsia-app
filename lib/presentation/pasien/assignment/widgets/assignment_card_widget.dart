import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
    // Fetch konten details
    final kontenAsync = ref.watch(
      fetchKontenByIdProvider(kontenId: assignment.kontenId),
    );

    return kontenAsync.when(
      data: (konten) {
        if (konten == null) {
          return const SizedBox.shrink();
        }

        // Calculate progress percentage
        final totalSections = konten.jumlahBagian ?? 1;
        final currentSection = assignment.currentBagian;
        final progressPercentage =
            (currentSection / totalSections).clamp(0.0, 1.0);

        return InkWell(
          onTap: () {
            // Navigate to assignment detail
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: assignment.isCompleted
                    ? Colors.green.shade200
                    : AppColor.primaryColor.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image preview
                if (konten.gambarUrl != null && konten.gambarUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      konten.gambarUrl!,
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.article,
                        size: 64,
                        color: AppColor.primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),

                // Content section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge + Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusBadge(),
                          Text(
                            _formatDate(assignment.assignedAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),

                      // Title
                      Text(
                        konten.judul ?? 'Judul tidak tersedia',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(8),

                      // Description
                      Text(
                        konten.jenisAnestesi ?? 'Konten pembelajaran',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(16),

                      // Progress section
                      Row(
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const Gap(6),
                          Text(
                            'Bagian $currentSection dari $totalSections',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressPercentage,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            assignment.isCompleted
                                ? Colors.green
                                : AppColor.primaryColor,
                          ),
                        ),
                      ),
                      const Gap(6),

                      // Percentage text
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${(progressPercentage * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: assignment.isCompleted
                                ? Colors.green
                                : AppColor.primaryColor,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: assignment.isCompleted
            ? Colors.green.shade50
            : AppColor.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: assignment.isCompleted
              ? Colors.green.shade300
              : AppColor.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            assignment.isCompleted ? Icons.check_circle : Icons.pending_actions,
            size: 14,
            color:
                assignment.isCompleted ? Colors.green : AppColor.primaryColor,
          ),
          const Gap(4),
          Text(
            assignment.isCompleted ? 'Selesai' : 'Dalam Progress',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: assignment.isCompleted
                  ? Colors.green.shade700
                  : AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
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
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }
}
