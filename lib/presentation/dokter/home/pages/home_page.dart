import 'package:aconsia_app/core/helpers/widgets/empty_list_data.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/main/data/models/reading_session_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_count_by_dokter_id/fetch_pasien_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_list_by_dokter_id/fetch_pasien_list_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/dokter_performance_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/widgets/alert_pasien_read_widget.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_count_by_dokter_id/fetch_konten_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/widgets/item_konten_widget.dart';
import 'package:aconsia_app/presentation/dokter/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/fetch_dokter_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/presentation/dokter/home/widgets/dashboard_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Real-time active readers count
    final activeReaderCount = ref.watch(activeReadersCountProvider(uid ?? ''));

    final profileDokter = ref.watch(fetchDokterProfileProvider(uid: uid ?? ''));
    final allKonten =
        ref.watch(fetchKontenByDokterIdProvider(dokterId: uid ?? ''));

    final totalKonten =
        ref.watch(fetchKontenCountByDokterIdProvider(dokterId: uid ?? ''));

    final totalPasien =
        ref.watch(fetchPasienCountByDokterIdProvider(dokterId: uid ?? ''));
    final pasienList =
        ref.watch(fetchPasienListByDokterIdProvider(dokterId: uid ?? ''));
    final dokterPerformance = ref.watch(dokterPerformanceProvider(uid ?? ''));
    final activeSessions =
        ref.watch(activeReadingSessionsStreamProvider(uid ?? ''));

    return Scaffold(
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundImage: profileDokter.value?.fotoProfilUrl != null &&
                    profileDokter.value!.fotoProfilUrl!.isNotEmpty
                ? NetworkImage(profileDokter.value!.fotoProfilUrl!)
                : AssetImage(Assets.images.placeholderImg.path)
                    as ImageProvider,
          ),
        ),
        customTitleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profileDokter.value?.namaLengkap ?? 'Dokter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              profileDokter.value?.spesialisasi ?? 'Spesialisasi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.showLogoutDialog(ref);
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFFAF3),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            // Invalidate all providers to refresh data
            ref.invalidate(fetchDokterProfileProvider);
            ref.invalidate(fetchKontenByDokterIdProvider);
            ref.invalidate(fetchKontenCountByDokterIdProvider);
            ref.invalidate(fetchPasienCountByDokterIdProvider);
            ref.invalidate(fetchPasienListByDokterIdProvider);
            ref.invalidate(dokterPerformanceProvider(uid ?? ''));
            ref.invalidate(activeReadingSessionsStreamProvider(uid ?? ''));

            // Wait for providers to rebuild
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Dashboard Dokter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Kelola konten edukasi dan pantau pasien Anda',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.textGrayColor,
                ),
              ),
              Gap(20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4E7FF)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColor.primaryColor),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        activeReaderCount > 0
                            ? '$activeReaderCount pasien sedang membaca materi saat ini'
                            : 'Belum ada pasien yang sedang membaca materi',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF23415F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _quickActionCard(
                    icon: Icons.group_outlined,
                    label: 'Review Pasien Baru',
                    onTap: () => context.pushNamed(RouteName.listActivePasien),
                  ),
                  _quickActionCard(
                    icon: Icons.article_outlined,
                    label: 'Kelola Konten',
                    onTap: () => ref.read(selectedIndexProvider.notifier).state = 1,
                  ),
                ],
              ),
              Gap(16),
              pasienList.when(
                data: (list) {
                  final items = list ?? [];
                  final readyCount = items.where(_isMedicalReady).length;
                  final pendingCount = items.length - readyCount;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2EAF4)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _smallMetric(
                            title: 'Menunggu Review',
                            value: '$pendingCount',
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: _smallMetric(
                            title: 'Siap Edukasi',
                            value: '$readyCount',
                            color: const Color(0xFF22C35D),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              Gap(20),
              // Show alert only if there are active readers
              if (activeReaderCount > 0) ...[
                AlertPasienReadWidget(
                  activeReaderCount: activeReaderCount,
                  onTap: () => context.pushNamed(RouteName.listActivePasien),
                ),
                Gap(16),
              ],
              DashboardSummaryWidget(
                title: 'Total Konten',
                count: totalKonten.when(
                  data: (data) => data.toString(),
                  loading: () => '...',
                  error: (err, stack) => 'Error',
                ),
                iconPath: Assets.icons.icKonten.path,
                onPressed: () =>
                    ref.read(selectedIndexProvider.notifier).state = 1,
              ),
              Gap(16),
              DashboardSummaryWidget(
                title: 'Total Pasien',
                count: totalPasien.when(
                  data: (data) => data.toString(),
                  loading: () => '...',
                  error: (err, stack) => 'Error',
                ),
                iconPath: Assets.icons.icPeoples.path,
                onPressed: () => context.pushNamed(RouteName.listActivePasien),
              ),
              Gap(16),
              _buildDokterPerformanceSection(dokterPerformance),
              Gap(16),
              _buildRealtimePatientStatus(
                sessionsAsync: activeSessions,
                pasienListAsync: pasienList,
              ),
              Gap(32),
              Text(
                'Konten Terbaru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Konten edukasi yang telah Anda buat',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textGrayColor,
                ),
              ),
              Gap(16),
              allKonten.when(
                data: (kontens) {
                  if (kontens == null || kontens.isEmpty) {
                    return emptyListData(context);
                  }

                  if (kontens.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off,
                              size: 64, color: Colors.grey),
                          const Gap(8),
                          Text(
                            'Tidak ada konten sesuai pencarian',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.textGrayColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: kontens.length,
                    separatorBuilder: (_, __) => const Gap(16),
                    itemBuilder: (context, index) {
                      return ItemKontenWidget(
                        konten: kontens[index],
                        isHome: true,
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (err, _) =>
                    Center(child: Text('Gagal memuat konten: $err')),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDDE7F3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.primaryColor, size: 20),
            const Gap(8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDokterPerformanceSection(
    AsyncValue<DokterPerformanceSummary> performanceAsync,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EAF4)),
      ),
      child: performanceAsync.when(
        data: (summary) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performa Dokter',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF132A45),
              ),
            ),
            const Gap(8),
            Text(
              'Berdasarkan hasil quiz pasien dari konten Anda.',
              style: TextStyle(
                fontSize: 13,
                color: AppColor.textGrayColor,
              ),
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _smallMetric(
                    title: 'Rata-rata Nilai',
                    value: '${summary.avgScore.toStringAsFixed(0)}%',
                    color: const Color(0xFF0EA5E9),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _smallMetric(
                    title: 'Butuh Follow-up',
                    value: '${summary.needsAttentionCount}',
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Text(
              'Total quiz: ${summary.totalQuizResults} • Nilai baik: ${summary.excellentCount}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF5D728A),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Text(
          'Performa belum tersedia: $error',
          style: const TextStyle(
            fontSize: 12,
            color: AppColor.primaryRed,
          ),
        ),
      ),
    );
  }

  Widget _buildRealtimePatientStatus({
    required AsyncValue<List<ReadingSessionModel>> sessionsAsync,
    required AsyncValue<List<PasienProfileModel>?> pasienListAsync,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EAF4)),
      ),
      child: sessionsAsync.when(
        data: (sessions) {
          final pasienMap = {
            for (final pasien in (pasienListAsync.value ?? <PasienProfileModel>[]))
              (pasien.uid ?? ''): pasien
          };

          if (sessions.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Pasien Real-Time',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF132A45),
                  ),
                ),
                Gap(8),
                Text(
                  'Belum ada pasien yang sedang membaca saat ini.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D728A),
                  ),
                ),
              ],
            );
          }

          final previewSessions = sessions.take(5).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Pasien Real-Time',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF132A45),
                ),
              ),
              const Gap(8),
              Text(
                '${sessions.length} pasien sedang membaca materi sekarang.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5D728A),
                ),
              ),
              const Gap(12),
              ...previewSessions.map((session) {
                final pasien = pasienMap[session.pasienId];
                final name = (pasien?.namaLengkap ?? 'Pasien').trim();
                final time = _formatTime(session.startedAt);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(0xFFEAF4FF),
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: Color(0xFF22C35D),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          name.isEmpty ? 'Pasien' : name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F3A58),
                          ),
                        ),
                      ),
                      Text(
                        'Mulai $time',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6F8094),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Text(
          'Status real-time belum tersedia: $error',
          style: const TextStyle(
            fontSize: 12,
            color: AppColor.primaryRed,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Widget _smallMetric({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF42566F),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  bool _isMedicalReady(PasienProfileModel pasien) {
    final operasi = (pasien.jenisOperasi ?? '').trim();
    final anestesi = (pasien.jenisAnestesi ?? '').trim();
    final asa = (pasien.klasifikasiAsa ?? '').trim();
    return operasi.isNotEmpty && anestesi.isNotEmpty && asa.isNotEmpty;
  }
}
