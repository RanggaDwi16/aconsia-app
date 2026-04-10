import 'package:aconsia_app/core/helpers/formatters/date_formatter.dart';
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
    final mappedPatients = pasienItems.map(_mapToDashboardPatient).toList();

    final pendingPatients =
        mappedPatients.where((p) => p.status == 'pending').toList();
    final rejectedPatients =
        mappedPatients.where((p) => p.status == 'rejected').toList();
    final approvedPatients = mappedPatients
        .where(
          (p) =>
              p.status == 'approved' ||
              p.status == 'in_progress' ||
              p.status == 'ready' ||
              p.status == 'completed',
        )
        .toList();
    final patientsNeedAnesthesia = mappedPatients
        .where((p) => p.status == 'approved' && p.anesthesiaType.isEmpty)
        .toList();

    final totalCount = totalPasien.valueOrNull ?? mappedPatients.length;
    final reviewCount = pendingPatients.length;
    final approvedCount = approvedPatients.length;
    final completionRate = approvedPatients.isEmpty
        ? 0
        : ((approvedPatients.where((p) => p.score >= 80).length /
                    approvedPatients.length) *
                100)
            .round();

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
                  Text(
                    'Dashboard Dokter Anestesi',
                    style: UiTypography.h1.copyWith(height: 1.15),
                  ),
                  const Gap(UiSpacing.xxs),
                  Text(
                    'Selamat datang, ${dokterName.isEmpty ? 'Dokter' : dokterName}',
                    style: UiTypography.bodySmall,
                  ),
                  const Gap(UiSpacing.md),
                  _QuickActionCard(
                    icon: Icons.monitor_outlined,
                    title: 'Real-Time Monitoring',
                    subtitle: activeReaderCount > 0
                        ? '$activeReaderCount pasien sedang membaca materi'
                        : 'Pantau progress edukasi pasien secara real-time',
                    borderColor: const Color(0xFF93C5FD),
                    backgroundColor: const Color(0xFFEFF6FF),
                    iconBgColor: UiPalette.blue600,
                    onTap: () => context.pushNamed(RouteName.listActivePasien),
                  ),
                  const Gap(UiSpacing.sm),
                  _QuickActionCard(
                    icon: Icons.fact_check_outlined,
                    title: 'Review Pasien Baru',
                    subtitle: 'Approve & tentukan jenis anestesi',
                    borderColor: const Color(0xFFD8B4FE),
                    backgroundColor: const Color(0xFFFAF5FF),
                    iconBgColor: const Color(0xFF7E22CE),
                    trailingBadge: reviewCount > 0 ? '$reviewCount' : null,
                    onTap: () {
                      final firstPending = pendingPatients.firstOrNull;
                      if (firstPending?.uid?.isNotEmpty == true) {
                        context.pushNamed(
                          RouteName.detailPasien,
                          extra: firstPending!.uid,
                        );
                        return;
                      }
                      context.pushNamed(RouteName.listActivePasien);
                    },
                  ),
                  const Gap(UiSpacing.md),
                  _StatsGrid(
                    total: totalCount,
                    pending: reviewCount,
                    approved: approvedCount,
                    completion: completionRate,
                  ),
                  const Gap(UiSpacing.md),
                  _SectionCard(
                    icon: Icons.schedule_outlined,
                    iconColor: const Color(0xFFB45309),
                    title: 'Pasien Menunggu Review ($reviewCount)',
                    titleColor: const Color(0xFF9A3412),
                    borderColor: const Color(0xFFFED7AA),
                    backgroundColor: const Color(0xFFFFF7ED),
                    emptyLabel: 'Belum ada pasien menunggu review.',
                    children: pendingPatients
                        .map(
                          (patient) => _PatientCard(
                            patient: patient,
                            variant: _PatientCardVariant.pending,
                            onTapAction: () {
                              if ((patient.uid ?? '').isEmpty) return;
                              context.pushNamed(
                                RouteName.detailPasien,
                                extra: patient.uid,
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                  if (rejectedPatients.isNotEmpty) ...[
                    const Gap(UiSpacing.md),
                    _SectionCard(
                      icon: Icons.cancel_outlined,
                      iconColor: UiPalette.red600,
                      title: 'Pasien Ditolak (${rejectedPatients.length})',
                      titleColor: UiPalette.red600,
                      borderColor: const Color(0xFFFECACA),
                      backgroundColor: const Color(0xFFFEF2F2),
                      emptyLabel: 'Belum ada pasien ditolak.',
                      children: rejectedPatients
                          .map(
                            (patient) => _PatientCard(
                              patient: patient,
                              variant: _PatientCardVariant.rejected,
                              onTapAction: () {
                                if ((patient.uid ?? '').isEmpty) return;
                                context.pushNamed(
                                  RouteName.detailPasien,
                                  extra: patient.uid,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const Gap(UiSpacing.md),
                  _SectionCard(
                    icon: Icons.verified_outlined,
                    iconColor: const Color(0xFF166534),
                    title: 'Pasien yang Sudah Disetujui ($approvedCount)',
                    titleColor: const Color(0xFF166534),
                    borderColor: const Color(0xFFD1FAE5),
                    backgroundColor: UiPalette.white,
                    emptyLabel: 'Belum ada data pasien untuk kategori ini.',
                    children: approvedPatients
                        .map(
                          (patient) => _PatientCard(
                            patient: patient,
                            variant: _PatientCardVariant.approved,
                            onTapAction: () {
                              if ((patient.uid ?? '').isEmpty) return;
                              context.pushNamed(
                                RouteName.detailPasien,
                                extra: patient.uid,
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const Gap(UiSpacing.md),
                  _SectionCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: UiPalette.blue600,
                    title:
                        'Pasien yang Membutuhkan Anestesi (${patientsNeedAnesthesia.length})',
                    titleColor: UiPalette.blue600,
                    borderColor: const Color(0xFFBFDBFE),
                    backgroundColor: const Color(0xFFEFF6FF),
                    emptyLabel: 'Semua pasien sudah memiliki jenis anestesi.',
                    children: patientsNeedAnesthesia
                        .map(
                          (patient) => _PatientCard(
                            patient: patient,
                            variant: _PatientCardVariant.needAnesthesia,
                            onTapAction: () {
                              if ((patient.uid ?? '').isEmpty) return;
                              context.pushNamed(
                                RouteName.detailPasien,
                                extra: patient.uid,
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _DoctorDashboardPatient _mapToDashboardPatient(PasienProfileModel pasien) {
    final preOp = pasien.preOperativeAssessment ?? const <String, dynamic>{};
    final rawStatus = (preOp['status'] as String? ?? '').trim().toLowerCase();
    final comprehension = (preOp['comprehensionScore'] is num)
        ? (preOp['comprehensionScore'] as num).toInt().clamp(0, 100)
        : _estimatedComprehension(pasien);

    final status = _normalizeStatus(rawStatus, pasien, comprehension);

    return _DoctorDashboardPatient(
      uid: pasien.uid,
      name: (pasien.namaLengkap ?? 'Pasien').trim().isEmpty
          ? 'Pasien'
          : pasien.namaLengkap!.trim(),
      mrn: (pasien.noRekamMedis ?? '-').trim().isEmpty
          ? '-'
          : pasien.noRekamMedis!.trim(),
      nik: (pasien.nik ?? '-').trim().isEmpty ? '-' : pasien.nik!.trim(),
      phone: (pasien.nomorTelepon ?? '-').trim().isEmpty
          ? '-'
          : pasien.nomorTelepon!.trim(),
      diagnosis: (pasien.jenisOperasi ?? '-').trim().isEmpty
          ? '-'
          : pasien.jenisOperasi!.trim(),
      surgeryDate: _formatTanggalLahir(pasien),
      anesthesiaType: (pasien.jenisAnestesi ?? '').trim(),
      score: comprehension,
      status: status,
    );
  }

  String _normalizeStatus(
    String rawStatus,
    PasienProfileModel pasien,
    int comprehension,
  ) {
    const allowed = {
      'pending',
      'approved',
      'in_progress',
      'ready',
      'completed',
      'rejected',
    };
    if (allowed.contains(rawStatus)) return rawStatus;

    final hasOperation = (pasien.jenisOperasi ?? '').trim().isNotEmpty;
    if (!hasOperation) return 'pending';
    if (comprehension >= 80) return 'ready';
    if (comprehension > 0) return 'in_progress';
    return 'approved';
  }

  String _formatTanggalLahir(PasienProfileModel pasien) {
    final ts = pasien.tanggalLahir;
    if (ts == null) return '-';
    return DateFormatter.formatDate(ts.toDate());
  }

  int _estimatedComprehension(PasienProfileModel pasien) {
    final hasOperation = (pasien.jenisOperasi ?? '').trim().isNotEmpty;
    final hasAnesthesia = (pasien.jenisAnestesi ?? '').trim().isNotEmpty;
    if (hasOperation && hasAnesthesia) return 85;
    if (hasOperation) return 60;
    return 0;
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.borderColor,
    required this.backgroundColor,
    required this.iconBgColor,
    required this.onTap,
    this.trailingBadge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color borderColor;
  final Color backgroundColor;
  final Color iconBgColor;
  final VoidCallback onTap;
  final String? trailingBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(UiSpacing.md),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: UiPalette.white, size: 28),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: UiTypography.label.copyWith(
                      fontSize: 18,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(2),
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
                  color: const Color(0xFFF97316),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  trailingBadge!,
                  style: const TextStyle(
                    color: UiPalette.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              const Icon(Icons.show_chart, color: UiPalette.blue600),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.total,
    required this.pending,
    required this.approved,
    required this.completion,
  });

  final int total;
  final int pending;
  final int approved;
  final int completion;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = (width - (UiSpacing.md * 2) - UiSpacing.sm) / 2;

    return Wrap(
      spacing: UiSpacing.sm,
      runSpacing: UiSpacing.sm,
      children: [
        _StatCard(
          width: cardWidth,
          title: 'Total Pasien',
          value: '$total',
          valueColor: UiPalette.slate900,
          icon: Icons.groups_2_outlined,
          iconBg: const Color(0xFFDBEAFE),
          iconColor: UiPalette.blue600,
        ),
        _StatCard(
          width: cardWidth,
          title: 'Menunggu\nReview',
          value: '$pending',
          valueColor: const Color(0xFFF97316),
          icon: Icons.schedule_outlined,
          iconBg: const Color(0xFFFFEDD5),
          iconColor: const Color(0xFFF97316),
        ),
        _StatCard(
          width: cardWidth,
          title: 'Sudah\nDisetujui',
          value: '$approved',
          valueColor: const Color(0xFF16A34A),
          icon: Icons.verified_outlined,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF16A34A),
        ),
        _StatCard(
          width: cardWidth,
          title: 'Tingkat\nPemahaman',
          value: '$completion%',
          valueColor: UiPalette.blue600,
          icon: Icons.trending_up,
          iconBg: const Color(0xFFE0F2FE),
          iconColor: UiPalette.blue600,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.width,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  final double width;
  final String title;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        color: UiPalette.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: UiTypography.bodySmall.copyWith(
                    color: UiPalette.slate600,
                  ),
                ),
                const Gap(UiSpacing.xs),
                Text(
                  value,
                  style: UiTypography.h1.copyWith(
                    fontSize: 21,
                    color: valueColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.emptyLabel,
    required this.children,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final Color borderColor;
  final Color backgroundColor;
  final String emptyLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const Gap(UiSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: UiTypography.title.copyWith(
                    fontSize: 18,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          if (children.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: UiSpacing.sm),
              child: Text(
                emptyLabel,
                style: UiTypography.body.copyWith(color: UiPalette.slate500),
              ),
            )
          else
            ...children.map(
              (widget) => Padding(
                padding: const EdgeInsets.only(bottom: UiSpacing.sm),
                child: widget,
              ),
            ),
        ],
      ),
    );
  }
}

enum _PatientCardVariant { pending, approved, needAnesthesia, rejected }

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.patient,
    required this.variant,
    required this.onTapAction,
  });

  final _DoctorDashboardPatient patient;
  final _PatientCardVariant variant;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    final ui = _resolveUi();
    final ctaLabel = _resolveActionLabel();
    final badgeLabel = _resolveBadgeLabel();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        color: UiPalette.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ui.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ui.avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: ui.avatarColor,
                  size: 24,
                ),
              ),
              const Gap(UiSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: UiTypography.title.copyWith(fontSize: 17),
                    ),
                    const Gap(2),
                    Wrap(
                      spacing: UiSpacing.xs,
                      runSpacing: 2,
                      children: [
                        Text('No. RM: ${patient.mrn}',
                            style: UiTypography.caption),
                        Text('• ${patient.diagnosis}',
                            style: UiTypography.caption),
                        Text('• ${patient.surgeryDate}',
                            style: UiTypography.caption),
                      ],
                    ),
                  ],
                ),
              ),
              if (variant == _PatientCardVariant.approved)
                _ScorePill(score: patient.score),
            ],
          ),
          const Gap(UiSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 340;
              final badge = Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiSpacing.sm,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ui.badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeLabel,
                  style: UiTypography.caption.copyWith(
                    color: ui.badgeText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );

              final cta = SizedBox(
                height: 36,
                child: TextButton(
                  onPressed: onTapAction,
                  style: TextButton.styleFrom(
                    foregroundColor: ui.actionColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: UiSpacing.sm,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(0, 36),
                  ),
                  child: Text(
                    ctaLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    badge,
                    const Gap(UiSpacing.xs),
                    cta,
                  ],
                );
              }

              return Wrap(
                spacing: UiSpacing.xs,
                runSpacing: UiSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [badge, cta],
              );
            },
          ),
        ],
      ),
    );
  }

  _PatientCardUi _resolveUi() {
    switch (variant) {
      case _PatientCardVariant.pending:
        return const _PatientCardUi(
          border: Color(0xFFFED7AA),
          avatarBg: Color(0xFFFFEDD5),
          avatarColor: Color(0xFFEA580C),
          badgeBg: Color(0xFFFFEDD5),
          badgeText: Color(0xFF9A3412),
          actionColor: Color(0xFFEA580C),
        );
      case _PatientCardVariant.needAnesthesia:
        return const _PatientCardUi(
          border: Color(0xFFBFDBFE),
          avatarBg: Color(0xFFDBEAFE),
          avatarColor: UiPalette.blue600,
          badgeBg: Color(0xFFDBEAFE),
          badgeText: Color(0xFF1D4ED8),
          actionColor: UiPalette.blue600,
        );
      case _PatientCardVariant.approved:
        return const _PatientCardUi(
          border: Color(0xFFE2E8F0),
          avatarBg: Color(0xFFDCFCE7),
          avatarColor: Color(0xFF16A34A),
          badgeBg: Color(0xFFDCFCE7),
          badgeText: Color(0xFF166534),
          actionColor: Color(0xFF16A34A),
        );
      case _PatientCardVariant.rejected:
        return const _PatientCardUi(
          border: Color(0xFFFECACA),
          avatarBg: Color(0xFFFEE2E2),
          avatarColor: UiPalette.red600,
          badgeBg: Color(0xFFFEE2E2),
          badgeText: UiPalette.red600,
          actionColor: UiPalette.red600,
        );
    }
  }

  String _resolveActionLabel() {
    switch (variant) {
      case _PatientCardVariant.pending:
        return 'Review Sekarang';
      case _PatientCardVariant.needAnesthesia:
        return 'Assign Anestesi';
      case _PatientCardVariant.approved:
        return 'Lihat Detail';
      case _PatientCardVariant.rejected:
        return 'Lihat Alasan';
    }
  }

  String _resolveBadgeLabel() {
    if (variant == _PatientCardVariant.pending) return 'Menunggu Review';
    if (variant == _PatientCardVariant.needAnesthesia) {
      return 'Membutuhkan Anestesi';
    }
    if (variant == _PatientCardVariant.rejected) return 'Ditolak';
    if (patient.score >= 80) return 'Siap TTD';
    return 'Belajar';
  }
}

class _PatientCardUi {
  const _PatientCardUi({
    required this.border,
    required this.avatarBg,
    required this.avatarColor,
    required this.badgeBg,
    required this.badgeText,
    required this.actionColor,
  });

  final Color border;
  final Color avatarBg;
  final Color avatarColor;
  final Color badgeBg;
  final Color badgeText;
  final Color actionColor;
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final isGood = score >= 80;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isGood ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$score%',
        style: UiTypography.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: isGood ? const Color(0xFF166534) : const Color(0xFF1D4ED8),
        ),
      ),
    );
  }
}

class _DoctorDashboardPatient {
  const _DoctorDashboardPatient({
    required this.uid,
    required this.name,
    required this.mrn,
    required this.nik,
    required this.phone,
    required this.diagnosis,
    required this.surgeryDate,
    required this.anesthesiaType,
    required this.score,
    required this.status,
  });

  final String? uid;
  final String name;
  final String mrn;
  final String nik;
  final String phone;
  final String diagnosis;
  final String surgeryDate;
  final String anesthesiaType;
  final int score;
  final String status;
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
