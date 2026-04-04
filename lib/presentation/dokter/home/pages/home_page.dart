import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_count_by_dokter_id/fetch_pasien_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_list_by_dokter_id/fetch_pasien_list_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/fetch_dokter_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final activeReaderCount = ref.watch(activeReadersCountProvider(uid ?? ''));
    final profileDokter = ref.watch(fetchDokterProfileProvider(uid: uid ?? ''));
    final totalPasien =
        ref.watch(fetchPasienCountByDokterIdProvider(dokterId: uid ?? ''));
    final pasienList =
        ref.watch(fetchPasienListByDokterIdProvider(dokterId: uid ?? ''));

    final dokterName = (profileDokter.value?.namaLengkap ?? 'Dokter').trim();
    final pasienItems = pasienList.valueOrNull ?? <PasienProfileModel>[];
    final totalPasienCount = totalPasien.valueOrNull ?? pasienItems.length;
    final pendingPatients = pasienItems.where((p) => !_isMedicalReady(p)).toList();
    final approvedPatients = pasienItems.where(_isMedicalReady).toList();
    final needsAnesthesia = pasienItems
        .where((p) => (p.jenisAnestesi ?? '').trim().isEmpty)
        .toList();
    final comprehensionRate = 0;

    return Scaffold(
      body: SafeArea(
        child: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchDokterProfileProvider);
            ref.invalidate(fetchPasienCountByDokterIdProvider);
            ref.invalidate(fetchPasienListByDokterIdProvider);
            ref.invalidate(activeReadersCountProvider(uid ?? ''));
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard Dokter Anestesi',
                  style: UiTypography.h1,
                ),
                const Gap(UiSpacing.xs),
                Text(
                  'Selamat datang, $dokterName',
                  style: UiTypography.bodySmall,
                ),
                const Gap(UiSpacing.lg),
                AconsiaInfoBanner(
                  icon: Icons.bolt_rounded,
                  message: activeReaderCount > 0
                      ? '$activeReaderCount pasien sedang membaca materi saat ini'
                      : 'Belum ada pasien yang sedang membaca materi',
                  backgroundColor: UiPalette.blue50,
                  borderColor: UiPalette.blue100,
                  iconColor: UiPalette.blue600,
                  textColor: const Color(0xFF23415F),
                ),
                const Gap(UiSpacing.md),
                _quickActionCard(
                  icon: Icons.monitor_outlined,
                  title: 'Real-Time Monitoring',
                  subtitle: 'Pantau progress edukasi pasien secara real-time',
                  gradientColors: const [
                    Color(0xFFEFF6FF),
                    Color(0xFFE0F2FE),
                  ],
                  borderColor: const Color(0xFF93C5FD),
                  iconBackgroundColor: const Color(0xFF2563EB),
                  onTap: () => context.pushNamed(RouteName.listActivePasien),
                ),
                const Gap(UiSpacing.sm),
                _quickActionCard(
                  icon: Icons.fact_check_outlined,
                  title: 'Review Pasien Baru',
                  subtitle: 'Approve dan tentukan jenis anestesi pasien',
                  trailingBadge:
                      pendingPatients.isNotEmpty ? '${pendingPatients.length}' : null,
                  gradientColors: const [
                    Color(0xFFF5F3FF),
                    Color(0xFFFCE7F3),
                  ],
                  borderColor: const Color(0xFFD8B4FE),
                  iconBackgroundColor: const Color(0xFF7C3AED),
                  onTap: () => context.pushNamed(RouteName.listActivePasien),
                ),
                const Gap(UiSpacing.md),
                _buildStatsGrid(
                  totalPasienCount: totalPasienCount,
                  pendingCount: pendingPatients.length,
                  approvedCount: approvedPatients.length,
                  comprehensionRate: comprehensionRate,
                ),
                const Gap(UiSpacing.lg),
                if (pendingPatients.isNotEmpty)
                  _patientSectionCard(
                    title:
                        'Pasien Menunggu Review (${pendingPatients.length})',
                    icon: Icons.schedule,
                    titleColor: const Color(0xFF9A3412),
                    cardBg: const Color(0xFFFFF7ED),
                    cardBorder: const Color(0xFFFED7AA),
                    patients: pendingPatients,
                    type: _PatientSectionType.pending,
                  ),
                if (pendingPatients.isNotEmpty) const Gap(UiSpacing.md),
                _patientSectionCard(
                  title:
                      'Pasien yang Sudah Disetujui (${approvedPatients.length})',
                  icon: Icons.verified_outlined,
                  titleColor: const Color(0xFF166534),
                  cardBg: UiPalette.white,
                  cardBorder: const Color(0xFFE2E8F0),
                  patients: approvedPatients,
                  type: _PatientSectionType.approved,
                ),
                if (needsAnesthesia.isNotEmpty) const Gap(UiSpacing.md),
                if (needsAnesthesia.isNotEmpty)
                  _patientSectionCard(
                    title:
                        'Pasien yang Membutuhkan Anestesi (${needsAnesthesia.length})',
                    icon: Icons.warning_amber_rounded,
                    titleColor: const Color(0xFF1D4ED8),
                    cardBg: const Color(0xFFEFF6FF),
                    cardBorder: const Color(0xFFBFDBFE),
                    patients: needsAnesthesia,
                    type: _PatientSectionType.needAnesthesia,
                  ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _quickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required Color borderColor,
    required Color iconBackgroundColor,
    required VoidCallback onTap,
    String? trailingBadge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(UiSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: UiPalette.white, size: 24),
            ),
            const Gap(UiSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: UiTypography.label.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(UiSpacing.xxs),
                  Text(
                    subtitle,
                    style: UiTypography.bodySmall.copyWith(
                      color: UiPalette.slate600,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingBadge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiSpacing.sm,
                  vertical: UiSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA580C),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  trailingBadge,
                  style: UiTypography.caption.copyWith(
                    color: UiPalette.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const Gap(UiSpacing.xs),
            const Icon(Icons.chevron_right_rounded, color: UiPalette.slate400),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid({
    required int totalPasienCount,
    required int pendingCount,
    required int approvedCount,
    required int comprehensionRate,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: UiSpacing.md,
      mainAxisSpacing: UiSpacing.md,
      childAspectRatio: 1.25,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _dashboardStatCard(
          title: 'Total Pasien',
          value: '$totalPasienCount',
          valueColor: UiPalette.slate900,
          icon: Icons.group_outlined,
          iconBg: UiPalette.blue50,
          iconColor: UiPalette.blue600,
        ),
        _dashboardStatCard(
          title: 'Menunggu Review',
          value: '$pendingCount',
          valueColor: const Color(0xFFEA580C),
          icon: Icons.pending_actions_outlined,
          iconBg: const Color(0xFFFFEDD5),
          iconColor: const Color(0xFFEA580C),
        ),
        _dashboardStatCard(
          title: 'Sudah Disetujui',
          value: '$approvedCount',
          valueColor: const Color(0xFF16A34A),
          icon: Icons.verified_outlined,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF16A34A),
        ),
        _dashboardStatCard(
          title: 'Tingkat Pemahaman',
          value: '$comprehensionRate%',
          valueColor: const Color(0xFF0891B2),
          icon: Icons.trending_up_rounded,
          iconBg: const Color(0xFFCFFAFE),
          iconColor: const Color(0xFF0891B2),
        ),
      ],
    );
  }

  Widget _dashboardStatCard({
    required String title,
    required String value,
    required Color valueColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFE2E8F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: UiTypography.caption,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          Text(
            value,
            style: UiTypography.h1.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _patientSectionCard({
    required String title,
    required IconData icon,
    required Color titleColor,
    required Color cardBg,
    required Color cardBorder,
    required List<PasienProfileModel> patients,
    required _PatientSectionType type,
  }) {
    return AconsiaCardSurface(
      borderColor: cardBorder,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(UiSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: titleColor),
                const Gap(UiSpacing.xs),
                Expanded(
                  child: Text(
                    title,
                    style: UiTypography.label.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(UiSpacing.sm),
            if (patients.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: UiSpacing.sm),
                child: Text(
                  'Belum ada data pasien untuk kategori ini.',
                  style: UiTypography.bodySmall,
                ),
              ),
            ...patients.take(8).map((p) => _patientRow(p, type)),
          ],
        ),
      ),
    );
  }

  Widget _patientRow(PasienProfileModel pasien, _PatientSectionType type) {
    return Builder(
      builder: (context) {
        final nama = (pasien.namaLengkap ?? 'Pasien').trim();
        final noRm = (pasien.noRekamMedis ?? '-').trim();
        final nik = (pasien.nik ?? '-').trim();
        final phone = (pasien.nomorTelepon ?? '-').trim();
        final operasi = (pasien.jenisOperasi ?? '-').trim();
        final tgl = _formatTanggalLahir(pasien);
        final isPending = type == _PatientSectionType.pending;
        final isNeedAnes = type == _PatientSectionType.needAnesthesia;
        final comprehension = _estimatedComprehension(pasien);

        return Container(
          margin: const EdgeInsets.only(bottom: UiSpacing.sm),
          padding: const EdgeInsets.all(UiSpacing.sm),
          decoration: BoxDecoration(
            color: UiPalette.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isPending
                  ? const Color(0xFFFED7AA)
                  : isNeedAnes
                      ? const Color(0xFFBFDBFE)
                      : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isPending
                          ? const Color(0xFFFFEDD5)
                          : isNeedAnes
                              ? const Color(0xFFE0F2FE)
                              : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: isPending
                          ? const Color(0xFFEA580C)
                          : isNeedAnes
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF16A34A),
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama.isEmpty ? 'Pasien' : nama,
                          style: UiTypography.label.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: UiPalette.slate900,
                          ),
                        ),
                        const Gap(UiSpacing.xxs),
                        Text(
                          isPending
                              ? 'No. RM: $noRm • NIK: $nik • $phone'
                              : 'No. RM: $noRm • $operasi • $tgl',
                          style: UiTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  if (!isPending && !isNeedAnes)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$comprehension%',
                          style: UiTypography.title.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: UiPalette.blue600,
                          ),
                        ),
                        const Gap(UiSpacing.xxs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UiSpacing.xs,
                            vertical: UiSpacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: comprehension >= 80
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFDBEAFE),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            comprehension >= 80 ? 'Siap TTD' : 'Belajar',
                            style: UiTypography.caption.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: comprehension >= 80
                                  ? const Color(0xFF166534)
                                  : const Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (isPending || isNeedAnes) ...[
                const Gap(UiSpacing.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiSpacing.xs,
                        vertical: UiSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: isPending
                            ? const Color(0xFFFFEDD5)
                            : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isPending
                            ? 'Menunggu Review'
                            : 'Membutuhkan Anestesi',
                        style: UiTypography.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isPending
                              ? const Color(0xFF9A3412)
                              : const Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.pushNamed(
                        RouteName.detailPasien,
                        extra: pasien.uid,
                      ),
                      child: Text(
                        isPending ? 'Review Sekarang' : 'Assign Anestesi',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _formatTanggalLahir(PasienProfileModel pasien) {
    final ts = pasien.tanggalLahir;
    if (ts == null) return '-';
    return DateFormat('dd MMM yyyy', 'id_ID').format(ts.toDate());
  }

  int _estimatedComprehension(PasienProfileModel pasien) {
    final hasCore = _isMedicalReady(pasien);
    final hasPhone = (pasien.nomorTelepon ?? '').trim().isNotEmpty;
    if (hasCore && hasPhone) return 85;
    if (hasCore) return 70;
    return 0;
  }

  bool _isMedicalReady(PasienProfileModel pasien) {
    final operasi = (pasien.jenisOperasi ?? '').trim();
    final anestesi = (pasien.jenisAnestesi ?? '').trim();
    final asa = (pasien.klasifikasiAsa ?? '').trim();
    return operasi.isNotEmpty && anestesi.isNotEmpty && asa.isNotEmpty;
  }
}

enum _PatientSectionType {
  pending,
  approved,
  needAnesthesia,
}
