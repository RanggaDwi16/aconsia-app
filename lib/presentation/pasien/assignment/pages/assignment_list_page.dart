import 'package:aconsia_app/assignment/controllers/get_assignments_by_pasien/fetch_assignments_by_pasien_provider.dart';
import 'package:aconsia_app/assignment/controllers/get_incomplete_assignments/fetch_incomplete_assignments_provider.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/pasien/assignment/widgets/assignment_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AssignmentListPage extends ConsumerStatefulWidget {
  const AssignmentListPage({super.key});

  @override
  ConsumerState<AssignmentListPage> createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends ConsumerState<AssignmentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

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
                title: 'Tugas Pembelajaran',
                subtitle: 'Pantau tugas dari dokter Anda',
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllAssignments(uid),
                  _buildIncompleteAssignments(uid),
                  _buildCompletedAssignments(uid),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildAllAssignments(String uid) {
    final assignmentsAsync = ref.watch(
      fetchAssignmentsByPasienProvider(pasienId: uid),
    );

    return assignmentsAsync.when(
      data: (assignments) {
        if (assignments == null || assignments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.assignment_outlined,
            title: 'Belum Ada Tugas',
            message: 'Dokter Anda belum memberikan tugas pembelajaran.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchAssignmentsByPasienProvider(pasienId: uid));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(UiSpacing.md),
            itemCount: assignments.length,
            separatorBuilder: (_, __) => const Gap(UiSpacing.md),
            itemBuilder: (context, index) {
              return AssignmentCardWidget(assignment: assignments[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildIncompleteAssignments(String uid) {
    final assignmentsAsync = ref.watch(
      fetchIncompleteAssignmentsProvider(pasienId: uid),
    );

    return assignmentsAsync.when(
      data: (assignments) {
        if (assignments == null || assignments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.task_alt,
            title: 'Semua Tugas Selesai',
            message: 'Mantap, seluruh tugas pembelajaran sudah selesai.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchIncompleteAssignmentsProvider(pasienId: uid));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(UiSpacing.md),
            itemCount: assignments.length,
            separatorBuilder: (_, __) => const Gap(UiSpacing.md),
            itemBuilder: (context, index) {
              return AssignmentCardWidget(assignment: assignments[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildCompletedAssignments(String uid) {
    final assignmentsAsync = ref.watch(
      fetchAssignmentsByPasienProvider(pasienId: uid),
    );

    return assignmentsAsync.when(
      data: (assignments) {
        if (assignments == null || assignments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.assignment_outlined,
            title: 'Belum Ada Tugas',
            message: 'Dokter Anda belum memberikan tugas pembelajaran.',
          );
        }

        final completedAssignments =
            assignments.where((assignment) => assignment.isCompleted).toList();

        if (completedAssignments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.pending_actions,
            title: 'Belum Ada yang Selesai',
            message: 'Ayo lanjutkan belajar sampai semua tugas selesai.',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchAssignmentsByPasienProvider(pasienId: uid));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(UiSpacing.md),
            itemCount: completedAssignments.length,
            separatorBuilder: (_, __) => const Gap(UiSpacing.md),
            itemBuilder: (context, index) {
              return AssignmentCardWidget(
                  assignment: completedAssignments[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.xl),
        child: AconsiaCardSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: UiPalette.slate300),
              const Gap(UiSpacing.md),
              Text(
                title,
                style: UiTypography.title,
                textAlign: TextAlign.center,
              ),
              const Gap(UiSpacing.sm),
              Text(
                message,
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
