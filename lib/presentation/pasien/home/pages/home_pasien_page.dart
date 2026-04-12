import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_accessible_konten_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_comprehension_score_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_learning_summary_provider.dart';
import 'package:aconsia_app/presentation/pasien/konten/controllers/material_read_progress_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomePasienPage extends ConsumerWidget {
  const HomePasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final profilePasien =
        ref.watch(fetchPasienProfileProvider(pasienId: uid ?? '')).value;
    final dokterId = profilePasien?.dokterId ?? '';

    final learningSummaryAsync = (uid ?? '').isNotEmpty && dokterId.isNotEmpty
        ? ref.watch(
            pasienLearningSummaryProvider(
              PasienLearningSummaryParams(
                pasienId: uid!,
                dokterId: dokterId,
              ),
            ),
          )
        : const AsyncValue.data(PasienLearningSummary.empty());
    final comprehensionAsync = (uid ?? '').isNotEmpty
        ? ref.watch(pasienComprehensionScoreProvider(uid!))
        : const AsyncValue.data(PasienComprehensionState.empty());
    final comprehensionScore = comprehensionAsync.valueOrNull?.score ?? 0;

    return Scaffold(
      body: AconsiaPageBackground(
        colors: [
          UiPalette.blue50,
          UiPalette.white,
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienProfileProvider);
            ref.invalidate(pasienAccessibleKontenProvider);
            ref.invalidate(materialReadProgressMapProvider);
            if ((uid ?? '').isNotEmpty && dokterId.isNotEmpty) {
              ref.invalidate(
                pasienLearningSummaryProvider(
                  PasienLearningSummaryParams(
                    pasienId: uid!,
                    dokterId: dokterId,
                  ),
                ),
              );
            }
            if ((uid ?? '').isNotEmpty) {
              ref.invalidate(pasienComprehensionScoreProvider(uid!));
            }
            await Future.delayed(const Duration(milliseconds: 350));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AconsiaTopActionRow(
                  title: 'Dashboard Pasien',
                  subtitle: 'Pantau progress pembelajaran Anda',
                  leading: IconButton(
                    onPressed: () =>
                        PasienMainShellScope.maybeOf(context)?.openDrawer(),
                    icon: const Icon(Icons.menu_rounded),
                    color: UiPalette.slate600,
                  ),
                ),
                const Gap(UiSpacing.md),
                const AconsiaInfoBanner(
                  icon: Icons.school_outlined,
                  message:
                      'Baca materi dari dokter, lalu selesaikan sesi AI untuk menilai pemahaman Anda.',
                  backgroundColor: Color(0xFFF1F8FF),
                  borderColor: Color(0xFFDCEBFF),
                  iconColor: UiPalette.blue600,
                  textColor: Color(0xFF23415F),
                ),
                const Gap(UiSpacing.md),
                if (profilePasien != null) ...[
                  _buildIdentitasPasienCard(profilePasien),
                  const Gap(UiSpacing.md),
                ],
                _buildAksiUtamaCards(
                  ref: ref,
                  summaryAsync: learningSummaryAsync,
                  comprehensionScore: comprehensionScore,
                  profilePasien: profilePasien,
                ),
                const Gap(UiSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        'Materi Pembelajaran',
                        style: UiTypography.h2,
                      ),
                    ),
                    if ((profilePasien?.jenisAnestesi ?? '').trim().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: UiSpacing.sm,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: UiPalette.white,
                          border: Border.all(color: UiPalette.slate300),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Auto-filter: ${profilePasien!.jenisAnestesi!}',
                          style: UiTypography.caption.copyWith(
                            color: UiPalette.slate700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(UiSpacing.xs),
                const Text(
                  'Konten edukasi dari dokter Anda',
                  style: UiTypography.bodySmall,
                ),
                const Gap(UiSpacing.md),
                _buildKontenList(
                  context,
                  ref,
                  uid: uid,
                  dokterId: profilePasien?.dokterId,
                ),
                const Gap(UiSpacing.md),
                _buildAiRecommendationSection(
                    summaryAsync: learningSummaryAsync),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentitasPasienCard(PasienProfileModel profile) {
    final tanggalLahir = profile.tanggalLahir?.toDate();
    final tanggalLahirText = tanggalLahir == null
        ? '-'
        : '${tanggalLahir.day.toString().padLeft(2, '0')}/${tanggalLahir.month.toString().padLeft(2, '0')}/${tanggalLahir.year}';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.badge_outlined, color: UiPalette.blue600),
                const Gap(UiSpacing.xs),
                Text(
                  'Identitas Pasien',
                  style: UiTypography.label.copyWith(
                    fontSize: 18,
                    color: UiPalette.slate900,
                  ),
                ),
              ],
            ),
            const Gap(UiSpacing.sm),
            Wrap(
              spacing: UiSpacing.sm,
              runSpacing: UiSpacing.sm,
              children: [
                _identityInfoItem('Nama Lengkap', profile.namaLengkap ?? '-'),
                _identityInfoItem(
                    'No. Rekam Medis', profile.noRekamMedis ?? '-'),
                _identityInfoItem('Tanggal Lahir', tanggalLahirText),
                _identityInfoItem('Jenis Kelamin', profile.jenisKelamin ?? '-'),
                _identityInfoItem('No. Telepon', profile.nomorTelepon ?? '-'),
                _identityInfoItem(
                    'Jenis Anestesi', profile.jenisAnestesi ?? '-'),
                _identityInfoItem('Jenis Operasi', profile.jenisOperasi ?? '-'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _identityInfoItem(String label, String value) {
    return Container(
      width: 158,
      padding: const EdgeInsets.all(UiSpacing.sm),
      decoration: BoxDecoration(
        color: UiPalette.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8E8FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: UiTypography.bodySmall.copyWith(
              color: UiPalette.slate500,
              fontSize: 12,
            ),
          ),
          const Gap(2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: UiTypography.bodySmall.copyWith(
              color: UiPalette.slate900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAksiUtamaCards({
    required WidgetRef ref,
    required AsyncValue<PasienLearningSummary> summaryAsync,
    required int comprehensionScore,
    required PasienProfileModel? profilePasien,
  }) {
    final progressMateri = summaryAsync.valueOrNull?.completionRate ?? 0;
    final jadwalTersedia = comprehensionScore >= 80;
    final assessmentDone = profilePasien?.assessmentCompleted ?? false;
    final scheduleDateRaw =
        profilePasien?.preOperativeAssessment?['scheduledSignatureDate'];
    final scheduleTimeRaw =
        profilePasien?.preOperativeAssessment?['scheduledSignatureTime'];
    final hasSignatureSchedule =
        (scheduleDateRaw is String && scheduleDateRaw.trim().isNotEmpty) ||
            scheduleDateRaw != null;

    return Column(
      children: [
        _aksiUtamaCard(
          icon: Icons.assignment_outlined,
          iconColor: assessmentDone
              ? const Color(0xFF16A34A)
              : const Color(0xFFF59E0B),
          title: 'Asesmen Pra-Operasi',
          subtitle: 'Riwayat medis, alergi, dan kondisi kesehatan',
          actionLabel: assessmentDone ? 'Lihat / Edit' : 'Isi Sekarang',
          actionColor: assessmentDone
              ? const Color(0xFF16A34A)
              : const Color(0xFFF59E0B),
          onTap: () => ref.read(selectedIndexPasienProvider.notifier).state = 2,
          trailingStatus: assessmentDone ? 'Selesai' : null,
        ),
        const Gap(UiSpacing.sm),
        _aksiUtamaCard(
          icon: Icons.calendar_month_outlined,
          iconColor: hasSignatureSchedule
              ? const Color(0xFF16A34A)
              : const Color(0xFF16A34A),
          title: 'Jadwalkan Tanda Tangan',
          subtitle:
              'Pemahaman ≥80%, siapkan pertanyaan, bawa identitas & dokumen medis',
          actionLabel: hasSignatureSchedule
              ? 'Ubah Jadwal'
              : (jadwalTersedia
                  ? 'Atur Jadwal'
                  : 'Locked (<$comprehensionScore%)'),
          actionColor:
              jadwalTersedia ? const Color(0xFF16A34A) : UiPalette.slate400,
          onTap: jadwalTersedia
              ? () => ref.read(selectedIndexPasienProvider.notifier).state = 6
              : null,
          trailingStatus: hasSignatureSchedule
              ? 'Terjadwal ${scheduleTimeRaw is String && scheduleTimeRaw.trim().isNotEmpty ? scheduleTimeRaw : ''}'
              : 'Progress Materi ${progressMateri.toStringAsFixed(0)}%',
        ),
      ],
    );
  }

  Widget _aksiUtamaCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionLabel,
    required Color actionColor,
    required VoidCallback? onTap,
    String? trailingStatus,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: UiPalette.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UiPalette.slate200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(UiSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: UiTypography.label.copyWith(
                      color: UiPalette.slate900,
                      fontSize: 18,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: UiTypography.bodySmall.copyWith(
                      color: UiPalette.slate500,
                    ),
                  ),
                  if (trailingStatus != null) ...[
                    const Gap(UiSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF3),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: Text(
                        trailingStatus,
                        style: UiTypography.caption.copyWith(
                          color: const Color(0xFF166534),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(UiSpacing.xs),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: UiPalette.white,
                disabledBackgroundColor: UiPalette.slate300,
                disabledForegroundColor: UiPalette.slate100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: UiSpacing.md,
                  vertical: UiSpacing.xs,
                ),
                elevation: 0,
              ),
              child: Text(
                actionLabel,
                style: UiTypography.button.copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiRecommendationSection({
    required AsyncValue<PasienLearningSummary> summaryAsync,
  }) {
    return summaryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) {
        final latest = summary.latestQuiz;
        if (latest == null) {
          return const SizedBox.shrink();
        }

        final weakAreas = latest.areasToImprove
            .where((area) => area.trim().isNotEmpty)
            .toList(growable: false);

        if (weakAreas.isEmpty) {
          return AconsiaCardSurface(
            borderColor: const Color(0xFFBBF7D0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Insight Sesi AI',
                  style: UiTypography.label,
                ),
                const Gap(UiSpacing.sm),
                Text(
                  'Anda sudah menjawab sesi AI dengan baik. Tidak ada rekomendasi khusus saat ini.',
                  style: UiTypography.bodySmall.copyWith(
                    color: const Color(0xFF166534),
                  ),
                ),
                const Gap(UiSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiSpacing.sm,
                    vertical: UiSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Text(
                    'Skor sesi terakhir: ${latest.overallScore}%',
                    style: UiTypography.bodySmall.copyWith(
                      color: const Color(0xFF166534),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return AconsiaCardSurface(
          borderColor: const Color(0xFFFECACA),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rekomendasi AI - Materi yang Perlu Diperkuat',
                style: UiTypography.label,
              ),
              const Gap(UiSpacing.sm),
              Text(
                'Fokus pada topik berikut agar pemahaman Anda lebih kuat.',
                style: UiTypography.bodySmall.copyWith(
                  color: UiPalette.slate600,
                ),
              ),
              const Gap(UiSpacing.sm),
              ...weakAreas.take(3).map(
                    (area) => Padding(
                      padding: const EdgeInsets.only(bottom: UiSpacing.xs),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: UiSpacing.sm,
                          vertical: UiSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: UiPalette.red600,
                            ),
                            const Gap(UiSpacing.xs),
                            Expanded(
                              child: Text(
                                area,
                                style: UiTypography.bodySmall.copyWith(
                                  color: UiPalette.slate800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKontenList(
    BuildContext context,
    WidgetRef ref, {
    required String? uid,
    required String? dokterId,
  }) {
    if (dokterId == null || dokterId.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(UiSpacing.xxl),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 64, color: Colors.grey),
              const Gap(UiSpacing.md),
              Text(
                'Belum ada dokter yang ditugaskan',
                style: TextStyle(color: UiPalette.slate500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final pasienId = uid ?? '';
    if (pasienId.isEmpty) {
      return const SizedBox.shrink();
    }

    final kontenAsync = ref.watch(
      pasienAccessibleKontenProvider(
        PasienAccessibleKontenParams(
          pasienId: pasienId,
          dokterId: dokterId,
        ),
      ),
    );

    return kontenAsync.when(
      data: (kontenList) {
        if (kontenList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(UiSpacing.xxl),
              child: Column(
                children: [
                  const Icon(Icons.description_outlined,
                      size: 64, color: Colors.grey),
                  const Gap(UiSpacing.md),
                  Text(
                    'Belum ada konten tersedia',
                    style: TextStyle(color: UiPalette.slate500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final displayKonten = kontenList.take(5).toList();

        return Column(
          children: displayKonten.map((konten) {
            return Column(
              children: [
                _buildKontenCard(context, ref, pasienId, konten),
                const Gap(UiSpacing.md),
              ],
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(UiSpacing.xxl),
          child: AconsiaCardSurface(
            borderColor: const Color(0xFFFECACA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: UiPalette.red600),
                const Gap(UiSpacing.md),
                Text(
                  'Materi belum bisa dimuat saat ini.',
                  style: UiTypography.label.copyWith(color: UiPalette.red600),
                  textAlign: TextAlign.center,
                ),
                const Gap(UiSpacing.xs),
                Text(
                  'Silakan tarik ke bawah atau tap coba lagi.',
                  style: UiTypography.bodySmall.copyWith(
                    color: UiPalette.slate500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(UiSpacing.md),
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.invalidate(pasienAccessibleKontenProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKontenCard(
    BuildContext context,
    WidgetRef ref,
    String uid,
    KontenModel konten,
  ) {
    final kontenId = konten.id ?? '';
    final sectionsAsync =
        ref.watch(fetchSectionsByKontenIdProvider(kontenId: kontenId));
    final totalSections = sectionsAsync.valueOrNull?.length ?? 0;
    final progressAsync = ref.watch(
      materialReadProgressProvider(
        MaterialReadProgressParams(
          pasienId: uid,
          kontenId: kontenId,
          totalSections: totalSections,
        ),
      ),
    );
    final progress = progressAsync.valueOrNull ??
        MaterialReadProgress(
          kontenId: kontenId,
          totalSections: totalSections,
          completedSectionIds: const <String>[],
          currentSectionIndex: 0,
        );
    final statusLabel = progress.statusLabel;

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteName.detailKonten,
          extra: konten.id,
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: UiPalette.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: UiPalette.slate200),
        ),
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(UiSpacing.sm),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: UiPalette.blue600,
              ),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    konten.judul ?? 'Judul tidak tersedia',
                    style: UiTypography.label.copyWith(
                      fontSize: 18,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    konten.indikasiTindakan ?? 'Materi edukasi dari dokter',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: UiTypography.bodySmall.copyWith(
                      color: UiPalette.slate600,
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: UiPalette.slate100,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: UiPalette.slate300),
                    ),
                    child: Text(
                      statusLabel,
                      style: UiTypography.caption.copyWith(
                        color: UiPalette.slate700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(UiSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '45 detik',
                  style: UiTypography.bodySmall.copyWith(
                    color: UiPalette.slate500,
                  ),
                ),
                const Gap(UiSpacing.sm),
                ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed(
                      RouteName.detailKonten,
                      extra: konten.id,
                    );
                  },
                  icon: const Icon(Icons.play_circle_outline_rounded, size: 16),
                  label: Text(progress.actionLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UiPalette.blue600,
                    foregroundColor: UiPalette.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
