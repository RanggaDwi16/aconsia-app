import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/core/providers/token_manager_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/konten/controllers/material_read_progress_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailKontenPage extends HookConsumerWidget {
  const DetailKontenPage({
    super.key,
    this.isPasien = true,
    this.isRekomendasi = false,
    this.kontenId,
    this.jenisAnestesi,
    this.jenisOperasi,
  });

  final bool isPasien;
  final bool isRekomendasi;
  final String? kontenId;
  final String? jenisAnestesi;
  final String? jenisOperasi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kontenId == null || kontenId!.trim().isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Konten ID tidak valid.')),
      );
    }

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userRoleAsync = ref.watch(tokenManagerProvider);
    final detectedIsPasien = useState<bool?>(null);
    final selectedSectionIndex = useState<int>(0);
    final hasManualSelection = useState(false);

    useEffect(() {
      userRoleAsync.whenData((tokenManager) async {
        final role = await tokenManager.getRole();
        detectedIsPasien.value = role == 'pasien';
      });
      return null;
    }, [userRoleAsync]);

    final finalIsPasien = detectedIsPasien.value ?? isPasien;
    final kontenAsync = ref.watch(fetchKontenByIdProvider(kontenId: kontenId!));
    final sectionsAsync =
        ref.watch(fetchSectionsByKontenIdProvider(kontenId: kontenId!));

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [UiPalette.blue50, UiPalette.white],
        child: kontenAsync.when(
          data: (konten) {
            final kontenStatus = (konten.status ?? '').trim().toLowerCase();
            if (finalIsPasien && kontenStatus != 'published') {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(UiSpacing.md),
                  child: AconsiaCardSurface(
                    borderColor: const Color(0xFFFED7AA),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AconsiaSectionTitle(
                          title: 'Konten Belum Dipublikasikan',
                          subtitle:
                              'Konten ini masih draft dan belum tersedia untuk pasien.',
                          titleSize: 20,
                        ),
                        const Gap(UiSpacing.sm),
                        Button.outlined(
                          onPressed: () => context.pop(),
                          label: 'Kembali',
                          textColor: const Color(0xFF92400E),
                          borderColor: const Color(0xFFFED7AA),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return sectionsAsync.when(
              data: (sections) {
                final progressAsync = ref.watch(
                  materialReadProgressProvider(
                    MaterialReadProgressParams(
                      pasienId: uid,
                      kontenId: kontenId!,
                      totalSections: sections.length,
                    ),
                  ),
                );
                final progress = progressAsync.valueOrNull ??
                    MaterialReadProgress(
                      kontenId: kontenId!,
                      totalSections: sections.length,
                      completedSectionIds: const <String>[],
                      currentSectionIndex: 0,
                    );

                final initialIndex = sections.isEmpty
                    ? 0
                    : progress.currentSectionIndex
                        .clamp(0, sections.length - 1);
                final effectiveSelection = hasManualSelection.value
                    ? selectedSectionIndex.value
                    : initialIndex;
                final currentIndex = sections.isEmpty
                    ? 0
                    : effectiveSelection.clamp(0, sections.length - 1);
                final currentSection =
                    sections.isEmpty ? null : sections[currentIndex];
                final completedIds = progress.completedSectionIds.toSet();
                final unlockedIndex = sections.isEmpty
                    ? 0
                    : completedIds.length.clamp(0, sections.length - 1);
                final canOpenAi = progress.isCompleted;

                Future<void> saveProgress(MaterialReadProgress next) async {
                  if (uid.isEmpty) return;
                  await ref
                      .read(saveMaterialReadProgressProvider.notifier)
                      .save(
                        SaveMaterialReadProgressPayload(
                          pasienId: uid,
                          progress: next,
                        ),
                      );
                }

                Future<void> markCurrentSectionDone() async {
                  if (currentSection == null) return;
                  final sectionId = (currentSection.id ?? '').trim();
                  if (sectionId.isEmpty) return;

                  final nextCompleted = progress.completedSectionIds.toSet();
                  nextCompleted.add(sectionId);

                  final nextIndex =
                      (currentIndex + 1).clamp(0, sections.length - 1);
                  final next = progress.copyWith(
                    totalSections: sections.length,
                    completedSectionIds: nextCompleted.toList(growable: false),
                    currentSectionIndex: nextIndex,
                  );

                  await saveProgress(next);
                  hasManualSelection.value = true;
                  selectedSectionIndex.value = nextIndex;
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    UiSpacing.md,
                    UiSpacing.md,
                    UiSpacing.md,
                    120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AconsiaTopActionRow(
                        title: 'Detail Konten',
                        subtitle: 'Baca materi edukasi dari dokter',
                        onBack: () => context.pop(),
                      ),
                      const Gap(UiSpacing.sm),
                      AconsiaCardSurface(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              konten.judul ?? 'Materi tanpa judul',
                              style: UiTypography.h2,
                            ),
                            const Gap(UiSpacing.sm),
                            Wrap(
                              spacing: 8,
                              runSpacing: 10,
                              children: _buildMetadataChips(konten),
                            ),
                          ],
                        ),
                      ),
                      const Gap(UiSpacing.sm),
                      AconsiaCardSurface(
                        borderColor: const Color(0xFFBFDBFE),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress Membaca',
                              style: UiTypography.label.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              '${progress.completedSectionIds.length}/${sections.length} bagian selesai (${progress.completionRate.toStringAsFixed(0)}%)',
                              style: UiTypography.bodySmall.copyWith(
                                color: UiPalette.slate600,
                              ),
                            ),
                            const Gap(8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: sections.isEmpty
                                    ? 0
                                    : (progress.completedSectionIds.length /
                                            sections.length)
                                        .clamp(0.0, 1.0),
                                backgroundColor: const Color(0xFFDBEAFE),
                                color: UiPalette.blue600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(UiSpacing.sm),
                      const AconsiaInfoBanner(
                        icon: Icons.school_outlined,
                        message:
                            'Pelajari setiap bagian secara berurutan sampai selesai. Sesi AI terbuka setelah semua bagian selesai dibaca.',
                        backgroundColor: UiPalette.blue50,
                        borderColor: UiPalette.blue100,
                        iconColor: UiPalette.blue600,
                        textColor: UiPalette.slate700,
                      ),
                      const Gap(UiSpacing.md),
                      const AconsiaSectionTitle(
                        title: 'Bagian Materi',
                        subtitle:
                            'Bagian terkunci akan terbuka setelah bagian sebelumnya selesai',
                        titleSize: 20,
                      ),
                      const Gap(UiSpacing.sm),
                      if (sections.isEmpty)
                        const AconsiaCardSurface(
                          child: Text(
                            'Belum ada materi tersedia untuk konten ini.',
                            style: TextStyle(color: UiPalette.slate600),
                          ),
                        )
                      else
                        Column(
                          children: sections.asMap().entries.map((entry) {
                            final index = entry.key;
                            final section = entry.value;
                            final sectionId = (section.id ?? '').trim();
                            final isCompleted = sectionId.isNotEmpty &&
                                completedIds.contains(sectionId);
                            final isLocked =
                                !isCompleted && index > unlockedIndex;
                            final isActive = index == currentIndex;

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == sections.length - 1 ? 0 : 12,
                              ),
                              child: _SectionListCard(
                                number: index + 1,
                                title:
                                    (section.judulBagian ?? '').trim().isEmpty
                                        ? 'Bagian ${index + 1}'
                                        : section.judulBagian!.trim(),
                                isCompleted: isCompleted,
                                isLocked: isLocked,
                                isActive: isActive,
                                onTap: isLocked
                                    ? null
                                    : () async {
                                        hasManualSelection.value = true;
                                        selectedSectionIndex.value = index;
                                        await saveProgress(
                                          progress.copyWith(
                                            totalSections: sections.length,
                                            currentSectionIndex: index,
                                          ),
                                        );
                                      },
                              ),
                            );
                          }).toList(growable: false),
                        ),
                      if (currentSection != null) ...[
                        const Gap(UiSpacing.md),
                        _CurrentSectionReader(
                          section: currentSection,
                          sectionNumber: currentIndex + 1,
                          totalSection: sections.length,
                          isSectionDone: completedIds
                              .contains((currentSection.id ?? '').trim()),
                          onMarkDone: markCurrentSectionDone,
                        ),
                      ],
                      if (canOpenAi) ...[
                        const Gap(UiSpacing.md),
                        const AconsiaInfoBanner(
                          icon: Icons.check_circle_outline_rounded,
                          message:
                              'Semua bagian selesai dibaca. Anda dapat melanjutkan ke sesi AI pembelajaran.',
                          backgroundColor: Color(0xFFECFDF3),
                          borderColor: Color(0xFF86EFAC),
                          iconColor: Color(0xFF16A34A),
                          textColor: Color(0xFF166534),
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Terjadi kesalahan saat mengambil materi.\n$error'),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Terjadi kesalahan saat mengambil konten.\n$error'),
          ),
        ),
      ),
      bottomNavigationBar: finalIsPasien
          ? Padding(
              padding: const EdgeInsets.fromLTRB(
                UiSpacing.md,
                UiSpacing.xs,
                UiSpacing.md,
                UiSpacing.md,
              ),
              child: sectionsAsync.when(
                data: (sections) {
                  if (sections.isEmpty) return const SizedBox.shrink();

                  final progressAsync = ref.watch(
                    materialReadProgressProvider(
                      MaterialReadProgressParams(
                        pasienId: uid,
                        kontenId: kontenId!,
                        totalSections: sections.length,
                      ),
                    ),
                  );
                  final progress = progressAsync.valueOrNull ??
                      MaterialReadProgress(
                        kontenId: kontenId!,
                        totalSections: sections.length,
                        completedSectionIds: const <String>[],
                        currentSectionIndex: 0,
                      );
                  final hasReadCompleted = progress.isCompleted;

                  final quizResultAsync = ref.watch(
                    fetchQuizResultByKontenProvider(
                      pasienId: uid,
                      kontenId: kontenId ?? '',
                    ),
                  );
                  final hasCompletedQuiz = quizResultAsync.valueOrNull != null;

                  return Button.filled(
                    onPressed: () {
                      if (!hasReadCompleted) return;

                      if (hasCompletedQuiz && quizResultAsync.value != null) {
                        context.pushNamed(
                          RouteName.quizResult,
                          extra: {
                            'konten': kontenAsync.value,
                            'sessionId': quizResultAsync.value!.sessionId,
                            'quizResults':
                                quizResultAsync.value!.questionResults,
                          },
                        );
                        return;
                      }

                      context.pushNamed(
                        RouteName.chatAi,
                        extra: {
                          'kontenId': kontenId,
                          'source': 'detail_konten',
                        },
                      );
                    },
                    label: hasReadCompleted
                        ? (hasCompletedQuiz
                            ? 'Lihat Ringkasan Pembelajaran'
                            : 'Mulai Sesi AI Pembelajaran')
                        : 'Selesaikan Bacaan Dulu',
                    height: 48,
                    borderRadius: 12,
                    disabled: !hasReadCompleted,
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            )
          : null,
    );
  }

  List<Widget> _buildMetadataChips(KontenModel konten) {
    final entries = <String>[
      if (isPasien && isRekomendasi) 'Rekomendasi AI',
      if ((konten.jenisAnestesi ?? '').trim().isNotEmpty)
        konten.jenisAnestesi!.trim(),
      if ((konten.indikasiTindakan ?? '').trim().isNotEmpty)
        konten.indikasiTindakan!.trim(),
      if ((konten.komplikasi ?? '').trim().isNotEmpty)
        konten.komplikasi!.trim(),
    ];

    return entries
        .take(4)
        .map(
          (label) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              label,
              style: UiTypography.caption.copyWith(
                color: UiPalette.slate700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
        .toList(growable: false);
  }
}

class _SectionListCard extends StatelessWidget {
  const _SectionListCard({
    required this.number,
    required this.title,
    required this.isCompleted,
    required this.isLocked,
    required this.isActive,
    required this.onTap,
  });

  final int number;
  final String title;
  final bool isCompleted;
  final bool isLocked;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? UiPalette.blue600
        : isLocked
            ? UiPalette.slate200
            : UiPalette.slate300;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(UiSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEFF6FF) : UiPalette.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF16A34A)
                    : isLocked
                        ? UiPalette.slate300
                        : UiPalette.blue600,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: UiPalette.white,
                    )
                  : Text(
                      '$number',
                      style: const TextStyle(
                        color: UiPalette.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: UiTypography.body.copyWith(
                  color: isLocked ? UiPalette.slate400 : UiPalette.slate900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Gap(UiSpacing.xs),
            if (isLocked)
              const Icon(Icons.lock_outline_rounded,
                  size: 18, color: UiPalette.slate400)
            else if (isCompleted)
              const Text(
                'Selesai',
                style: TextStyle(
                  color: Color(0xFF166534),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: UiPalette.slate500,
              ),
          ],
        ),
      ),
    );
  }
}

class _CurrentSectionReader extends StatelessWidget {
  const _CurrentSectionReader({
    required this.section,
    required this.sectionNumber,
    required this.totalSection,
    required this.isSectionDone,
    required this.onMarkDone,
  });

  final KontenSectionModel section;
  final int sectionNumber;
  final int totalSection;
  final bool isSectionDone;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    final title = (section.judulBagian ?? '').trim().isEmpty
        ? 'Bagian $sectionNumber'
        : section.judulBagian!.trim();
    final content = (section.isiKonten ?? '').trim().isEmpty
        ? 'Isi materi belum tersedia.'
        : section.isiKonten!.trim();

    return AconsiaCardSurface(
      borderColor: const Color(0xFFBFDBFE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ($sectionNumber/$totalSection)',
            style: UiTypography.label.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(UiSpacing.sm),
          Text(
            content,
            style: UiTypography.body.copyWith(color: UiPalette.slate700),
          ),
          const Gap(UiSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSectionDone ? null : onMarkDone,
              icon: Icon(
                isSectionDone ? Icons.check_circle : Icons.done_rounded,
                size: 18,
              ),
              label: Text(
                isSectionDone
                    ? 'Bagian Ini Sudah Selesai'
                    : 'Tandai Bagian Selesai',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSectionDone ? UiPalette.slate300 : UiPalette.blue600,
                foregroundColor: UiPalette.white,
                disabledBackgroundColor: UiPalette.slate300,
                disabledForegroundColor: UiPalette.slate100,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
