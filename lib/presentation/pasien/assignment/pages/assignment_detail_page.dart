import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AssignmentDetailPage extends ConsumerWidget {
  final KontenAssignmentModel assignment;
  final KontenModel konten;

  const AssignmentDetailPage({
    super.key,
    required this.assignment,
    required this.konten,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch sections for progress tracking
    final sectionsAsync = ref.watch(
      fetchSectionsByKontenIdProvider(kontenId: konten.id!),
    );

    // Calculate progress
    final totalSections = konten.jumlahBagian ?? 1;
    final currentSection = assignment.currentBagian;
    final progressPercentage = (currentSection / totalSections).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: AconsiaPageBackground(
        colors: const [UiPalette.blue50, UiPalette.white],
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: AconsiaTopActionRow(
                title: 'Detail Tugas',
                subtitle: 'Pantau progres pembelajaran Anda',
                onBack: () => context.pop(),
              ),
            ),
            const Gap(12),
            // Konten image preview
            if (konten.gambarUrl != null && konten.gambarUrl!.isNotEmpty)
              Image.network(
                konten.gambarUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      UiPalette.blue600.withOpacity(0.7),
                      UiPalette.blue600,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.article,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AconsiaInfoBanner(
                    icon: Icons.menu_book_outlined,
                    message:
                        'Selesaikan bacaan sampai akhir. Evaluasi pemahaman dilakukan melalui menu Chat AI Assistant.',
                    backgroundColor: UiPalette.blue50,
                    borderColor: UiPalette.blue100,
                    iconColor: UiPalette.blue600,
                    textColor: UiPalette.slate700,
                  ),
                  const Gap(12),
                  // Status badge
                  _buildStatusBadge(),
                  const Gap(16),

                  // Title
                  Text(
                    konten.judul ?? 'Judul tidak tersedia',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(8),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (konten.jenisAnestesi != null)
                        JenisAnestesiTag(text: konten.jenisAnestesi!),
                      if (konten.tataCara != null)
                        TataCaraTag(text: konten.tataCara!),
                    ],
                  ),
                  const Gap(16),

                  // Description
                  Text(
                    konten.id ?? 'Tidak ada deskripsi',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const Gap(24),

                  // Assignment info card
                  _buildAssignmentInfoCard(),
                  const Gap(24),

                  // Progress section
                  _buildProgressSection(
                    totalSections,
                    currentSection,
                    progressPercentage,
                  ),
                  const Gap(24),

                  // Section checklist
                  sectionsAsync.when(
                    data: (sections) {
                      if (sections.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return _buildSectionChecklist(sections, currentSection);
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button.filled(
                onPressed: () {
                  context.pushNamed(
                    RouteName.detailKonten,
                    extra: konten.id,
                  );
                },
                label: assignment.isCompleted
                    ? 'Tugas Selesai ✓'
                    : 'Lanjutkan Baca Materi',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: assignment.isCompleted
            ? Colors.green.shade50
            : UiPalette.blue600.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: assignment.isCompleted
              ? Colors.green.shade300
              : UiPalette.blue600.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            assignment.isCompleted ? Icons.check_circle : Icons.pending_actions,
            size: 16,
            color:
                assignment.isCompleted ? Colors.green : UiPalette.blue600,
          ),
          const Gap(6),
          Text(
            assignment.isCompleted ? 'Tugas Selesai' : 'Dalam Progress',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: assignment.isCompleted
                  ? Colors.green.shade700
                  : UiPalette.blue600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UiPalette.blue600.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: UiPalette.blue600.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Ditugaskan',
            value: DateFormat('dd MMMM yyyy').format(assignment.assignedAt),
          ),
          if (assignment.isCompleted && assignment.completedAt != null) ...[
            const Gap(12),
            _buildInfoRow(
              icon: Icons.check_circle,
              label: 'Diselesaikan',
              value: DateFormat('dd MMMM yyyy').format(assignment.completedAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: UiPalette.blue600,
        ),
        const Gap(10),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: UiPalette.slate900,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
    int totalSections,
    int currentSection,
    double progressPercentage,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            assignment.isCompleted
                ? Colors.green.shade50
                : UiPalette.blue600.withOpacity(0.1),
            assignment.isCompleted
                ? Colors.green.shade100
                : UiPalette.blue600.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: assignment.isCompleted
              ? Colors.green.shade200
              : UiPalette.blue600.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Progress Pembelajaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: UiPalette.slate900,
            ),
          ),
          const Gap(20),

          // Circular progress indicator
          SizedBox(
            height: 140,
            width: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: CircularProgressIndicator(
                    value: progressPercentage,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      assignment.isCompleted
                          ? Colors.green
                          : UiPalette.blue600,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progressPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: assignment.isCompleted
                            ? Colors.green
                            : UiPalette.blue600,
                      ),
                    ),
                    Text(
                      '$currentSection / $totalSections',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),

          // Progress indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressIndicator(
                icon: Icons.book_outlined,
                label: 'Bagian Dibaca',
                value: '$currentSection/$totalSections',
                color: UiPalette.blue600,
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.shade300,
              ),
              _buildProgressIndicator(
                icon: assignment.isCompleted
                    ? Icons.check_circle_outline
                    : Icons.pending_actions_outlined,
                label: 'Status Tugas',
                value: assignment.isCompleted ? 'Selesai' : 'Berjalan',
                color: assignment.isCompleted ? Colors.green : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const Gap(6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionChecklist(List sections, int currentSection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Bagian',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: UiPalette.slate900,
          ),
        ),
        const Gap(12),
        ...List.generate(sections.length, (index) {
          final section = sections[index];
          final sectionNumber = index + 1;
          final isRead = sectionNumber <= currentSection;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isRead ? Colors.green.shade50 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isRead ? Colors.green.shade200 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isRead ? Colors.green : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isRead
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: Colors.white,
                          )
                        : Text(
                            '$sectionNumber',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.judul ?? 'Bagian $sectionNumber',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isRead
                              ? Colors.green.shade700
                              : UiPalette.slate900,
                        ),
                      ),
                      if (section.deskripsi != null) ...[
                        const Gap(4),
                        Text(
                          section.deskripsi!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
