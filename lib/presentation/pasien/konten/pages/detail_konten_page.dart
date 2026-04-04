import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/core/providers/token_manager_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailKontenPage extends HookConsumerWidget {
  final bool isPasien;
  final bool isRekomendasi;
  final String? kontenId;
  final String? jenisAnestesi;
  final String? jenisOperasi;

  const DetailKontenPage({
    super.key,
    this.isPasien = true,
    this.isRekomendasi = false,
    this.jenisAnestesi,
    this.jenisOperasi,
    this.kontenId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kontenId == null || kontenId!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Konten ID tidak valid.')),
      );
    }

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final userRoleAsync = ref.watch(tokenManagerProvider);
    final detectedIsPasien = useState<bool?>(null);

    useEffect(() {
      userRoleAsync.whenData((tokenManager) async {
        final role = await tokenManager.getRole();
        detectedIsPasien.value = role == 'pasien';
      });
      return null;
    }, [userRoleAsync]);

    final finalIsPasien = detectedIsPasien.value ?? isPasien;
    final kontenAsync = ref.watch(fetchKontenByIdProvider(kontenId: kontenId!));
    final sectionKontenAsync =
        ref.watch(fetchSectionsByKontenIdProvider(kontenId: kontenId!));
    final currentSessionId = useState<String?>(null);

    useEffect(() {
      if (detectedIsPasien.value == null) {
        return null;
      }

      if (finalIsPasien && uid.isNotEmpty) {
        Future.microtask(() async {
          final konten =
              await ref.read(fetchKontenByIdProvider(kontenId: kontenId!).future);
          final sections = await ref
              .read(fetchSectionsByKontenIdProvider(kontenId: kontenId!).future);

          if (konten != null && sections != null && sections.isNotEmpty) {
            await ref
                .read(createOrUpdateReadingSessionProvider.notifier)
                .createOrUpdate(
                  pasienId: uid,
                  kontenId: kontenId!,
                  sectionId: sections.first.id ?? '',
                  dokterId: konten.dokterId ?? '',
                );

            final sessionState = ref.read(createOrUpdateReadingSessionProvider);
            sessionState.whenData((session) {
              if (session != null) {
                currentSessionId.value = session.id;
              }
            });
          }
        });
      }

      return null;
    }, [kontenId, uid, detectedIsPasien.value]);

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [UiPalette.blue50, UiPalette.white],
        child: kontenAsync.when(
          data: (konten) {
            if (konten == null) {
              return const Center(
                child: Text('Konten tidak ditemukan.'),
              );
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
                          children: [
                            if (isPasien && isRekomendasi) const RekomendasiTag(),
                            if (konten.jenisAnestesi != null)
                              JenisAnestesiTag(text: konten.jenisAnestesi!),
                            if (konten.tataCara != null)
                              TataCaraTag(text: konten.tataCara!),
                            if (konten.komplikasi != null)
                              KomplikasiTag(text: konten.komplikasi!),
                            if (konten.indikasiTindakan != null)
                              IndikasiTindakanTag(text: konten.indikasiTindakan!),
                            if (konten.prognosis != null)
                              PrognosisTag(text: konten.prognosis!),
                            if (konten.alternatifLain != null)
                              AlternatifLainTag(text: konten.alternatifLain!),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  const AconsiaInfoBanner(
                    icon: Icons.school_outlined,
                    message:
                        'Baca sampai selesai, lalu lanjutkan sesi AI untuk memastikan pemahaman Anda.',
                    backgroundColor: UiPalette.blue50,
                    borderColor: UiPalette.blue100,
                    iconColor: UiPalette.blue600,
                    textColor: UiPalette.slate700,
                  ),
                  const Gap(UiSpacing.sm),
                  AconsiaCardSurface(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: konten.gambarUrl != null && konten.gambarUrl!.isNotEmpty
                          ? Image.network(
                              konten.gambarUrl!,
                              width: context.deviceWidth,
                              height: context.deviceWidth * 0.52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                Assets.images.imgKonten.path,
                                width: context.deviceWidth,
                                height: context.deviceWidth * 0.52,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              Assets.images.imgKonten.path,
                              width: context.deviceWidth,
                              height: context.deviceWidth * 0.52,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const Gap(UiSpacing.md),
                  const AconsiaSectionTitle(
                    title: 'Bagian Materi',
                    subtitle: 'Pelajari setiap bagian secara berurutan',
                    titleSize: 20,
                  ),
                  const Gap(UiSpacing.sm),
                  sectionKontenAsync.when(
                    data: (sections) {
                      if (sections == null || sections.isEmpty) {
                        return const AconsiaCardSurface(
                          child: Text(
                            'Belum ada materi tersedia untuk konten ini.',
                            style: TextStyle(
                              color: UiPalette.slate600,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: sections
                            .asMap()
                            .entries
                            .map(
                              (entry) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: entry.key == sections.length - 1 ? 0 : 12,
                                ),
                                child: _SectionCard(
                                  section: entry.value,
                                  number: entry.key + 1,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) {
                      return AconsiaCardSurface(
                        borderColor: UiPalette.red600,
                        child: Text(
                          'Terjadi kesalahan saat mengambil materi.\n$e',
                          style: const TextStyle(
                            color: UiPalette.red600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) {
            return Center(
              child: Text(
                'Terjadi kesalahan saat mengambil konten.\n$e',
                textAlign: TextAlign.center,
              ),
            );
          },
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
              child: kontenAsync.when(
                data: (konten) {
                  final quizResultAsync = ref.watch(
                    fetchQuizResultByKontenProvider(
                      pasienId: uid,
                      kontenId: kontenId ?? '',
                    ),
                  );
                  final hasCompletedQuiz = quizResultAsync.valueOrNull != null;

                  return sectionKontenAsync.when(
                    data: (sections) => Button.filled(
                      onPressed: () {
                        if (hasCompletedQuiz) {
                          context.pushNamed(
                            RouteName.quizResult,
                            extra: {
                              'konten': konten,
                              'sessionId': quizResultAsync.value!.sessionId,
                              'quizResults': quizResultAsync.value!.questionResults,
                            },
                          );
                          return;
                        }

                        if (konten != null && sections != null && sections.isNotEmpty) {
                          context.pushNamed(
                            RouteName.chatAi,
                            extra: {
                              'kontenId': konten.id,
                              'source': 'detail_konten',
                            },
                          );
                        }
                      },
                      label: hasCompletedQuiz
                          ? 'Lihat Ringkasan Pembelajaran'
                          : 'Mulai Sesi AI Pembelajaran',
                      height: 48,
                      borderRadius: 12,
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            )
          : null,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.section,
    required this.number,
  });

  final KontenSectionModel section;
  final int number;

  @override
  Widget build(BuildContext context) {
    return AconsiaCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: UiPalette.blue600,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: UiPalette.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  section.judulBagian?.trim().isNotEmpty == true
                      ? section.judulBagian!
                      : 'Bagian $number',
                  style: UiTypography.label.copyWith(
                    fontWeight: FontWeight.w700,
                    color: UiPalette.slate900,
                  ),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          Text(
            section.isiKonten?.trim().isNotEmpty == true
                ? section.isiKonten!
                : 'Isi materi belum tersedia.',
            style: UiTypography.body.copyWith(
              color: UiPalette.slate700,
            ),
          ),
        ],
      ),
    );
  }
}
