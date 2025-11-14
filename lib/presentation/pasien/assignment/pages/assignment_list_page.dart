import 'package:aconsia_app/assignment/controllers/get_assignments_by_pasien/fetch_assignments_by_pasien_provider.dart';
import 'package:aconsia_app/assignment/controllers/get_incomplete_assignments/fetch_incomplete_assignments_provider.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
      appBar: CustomAppBar(
        title: 'Tugas Pembelajaran',
        centertitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColor.primaryColor,
              unselectedLabelColor: AppColor.textGrayColor,
              indicatorColor: AppColor.primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Belum Selesai'),
                Tab(text: 'Selesai'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllAssignments(uid),
          _buildIncompleteAssignments(uid),
          _buildCompletedAssignments(uid),
        ],
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
            message: 'Dokter Anda belum memberikan tugas pembelajaran',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchAssignmentsByPasienProvider(pasienId: uid));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              return AssignmentCardWidget(
                assignment: assignments[index],
              );
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
            icon: Icons.check_circle_outline,
            title: 'Semua Tugas Selesai!',
            message: 'Mantap! Semua tugas pembelajaran sudah diselesaikan 🎉',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchIncompleteAssignmentsProvider(pasienId: uid));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              return AssignmentCardWidget(
                assignment: assignments[index],
              );
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
            message: 'Dokter Anda belum memberikan tugas pembelajaran',
          );
        }

        // Filter only completed assignments
        final completedAssignments =
            assignments.where((assignment) => assignment.isCompleted).toList();

        if (completedAssignments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.pending_actions,
            title: 'Belum Ada yang Selesai',
            message: 'Ayo semangat menyelesaikan tugas pembelajaran!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchAssignmentsByPasienProvider(pasienId: uid));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: completedAssignments.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              return AssignmentCardWidget(
                assignment: completedAssignments[index],
              );
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const Gap(24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              message,
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
