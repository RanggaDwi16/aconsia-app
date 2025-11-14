import 'package:aconsia_app/core/providers/token_manager_provider.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/pages/quiz_chat_ai_page.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    // Auto-detect user role
    final userRoleAsync = ref.watch(tokenManagerProvider);
    final detectedIsPasien = useState<bool?>(null);

    useEffect(() {
      userRoleAsync.whenData((tokenManager) async {
        final role = await tokenManager.getRole();
        detectedIsPasien.value = (role == 'pasien');
        print(
            'DetailKontenPage - Role detected: $role, isPasien: ${detectedIsPasien.value}');
      });
      return null;
    }, [userRoleAsync]);

    // Use detected role if available, otherwise use parameter
    final finalIsPasien = detectedIsPasien.value ?? isPasien;

    // Watch kedua provider
    final kontenAsync = ref.watch(fetchKontenByIdProvider(kontenId: kontenId!));
    final sectionKontenAsync =
        ref.watch(fetchSectionsByKontenIdProvider(kontenId: kontenId!));

    // State untuk tracking reading session ID
    final currentSessionId = useState<String?>(null);

    // Start reading session when page loads (hanya untuk pasien)
    useEffect(() {
      // Only run after role detection is complete (detectedIsPasien must have value)
      if (detectedIsPasien.value == null) {
        return null;
      }

      if (finalIsPasien && uid.isNotEmpty) {
        print('DetailKontenPage - Starting reading session for pasien: $uid');
        Future.microtask(() async {
          final konten = await ref
              .read(fetchKontenByIdProvider(kontenId: kontenId!).future);
          final sections = await ref.read(
              fetchSectionsByKontenIdProvider(kontenId: kontenId!).future);

          if (konten != null && sections != null && sections.isNotEmpty) {
            await ref
                .read(createOrUpdateReadingSessionProvider.notifier)
                .createOrUpdate(
                  pasienId: uid,
                  kontenId: kontenId!,
                  sectionId: sections.first.id ?? '',
                  dokterId: konten.dokterId ?? '',
                );

            // Get session ID from state
            final sessionState = ref.read(createOrUpdateReadingSessionProvider);
            sessionState.whenData((session) {
              if (session != null) {
                currentSessionId.value = session.id;
              }
            });
          }
        });
      } else {
        if (!finalIsPasien) {
          print('DetailKontenPage - Skipping reading session, user is dokter');
        }
      }

      return null;
    }, [kontenId, uid, detectedIsPasien.value]);

    return Scaffold(
      appBar: CustomAppBar(
        title: finalIsPasien ? 'Mater Pembelajaran' : 'Detail Konten',
        centertitle: true,
        actions: [
          if (!finalIsPasien) // Only dokter can edit
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Button.filled(
                onPressed: () =>
                    context.pushNamed(RouteName.editKonten, extra: kontenId),
                label: 'Edit',
                textColor: AppColor.primaryColor,
                icon: SvgPicture.asset(
                  Assets.icons.icEdit.path,
                  width: 16,
                  height: 16,
                  color: AppColor.primaryColor,
                ),
                width: 90,
                color: AppColor.primaryWhite,
              ),
            ),
        ],
      ),
      body: kontenAsync.when(
        data: (konten) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  konten?.judul ?? 'Judul tidak tersedia',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(16),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    if (isPasien && isRekomendasi) const RekomendasiTag(),
                    if (konten?.jenisAnestesi != null)
                      JenisAnestesiTag(text: konten!.jenisAnestesi!),
                    if (konten?.tataCara != null)
                      TataCaraTag(text: konten!.tataCara!),
                    if (konten?.komplikasi != null)
                      KomplikasiTag(text: konten!.komplikasi!),
                    if (konten?.indikasiTindakan != null)
                      IndikasiTindakanTag(text: konten!.indikasiTindakan!),
                    if (konten?.prognosis != null)
                      PrognosisTag(text: konten!.prognosis!),
                    if (konten?.alternatifLain != null)
                      AlternatifLainTag(text: konten!.alternatifLain!),
                  ],
                ),
                const Gap(24),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: konten?.gambarUrl != null &&
                            konten!.gambarUrl!.isNotEmpty
                        ? Image.network(
                            konten.gambarUrl!,
                            width: context.deviceWidth,
                            height: context.deviceWidth * 0.5,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            Assets.images.imgKonten.path,
                            width: context.deviceWidth * 0.8,
                            height: context.deviceWidth * 0.5,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const Gap(24),

                // === BAGIAN SECTION ===
                sectionKontenAsync.when(
                  data: (sections) {
                    if (sections == null || sections.isEmpty) {
                      return const Text('Tidak ada materi tersedia.');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sections.map((section) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sections[0].judulBagian ??
                                    'Judul section tidak tersedia',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                section.isiKonten ?? 'Konten tidak tersedia',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textGrayColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (e, st) {
                    return Center(
                      child: Text(
                        'Terjadi kesalahan saat mengambil materi.\n$e',
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (e, st) {
          return Center(
            child: Text(
              'Terjadi kesalahan saat mengambil konten.\n$e',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
      bottomNavigationBar: finalIsPasien
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: kontenAsync.when(
                data: (konten) {
                  // Check if quiz completed
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
                          // Navigate to quiz result page
                          context.pushNamed(
                            RouteName.quizResult,
                            extra: {
                              'konten': konten,
                              'sessionId': quizResultAsync.value!.sessionId,
                              'quizResults':
                                  quizResultAsync.value!.questionResults,
                            },
                          );
                        } else {
                          // Navigate to Quiz AI Chat
                          if (konten != null &&
                              sections != null &&
                              sections.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizChatAiPage(
                                  konten: konten,
                                  sections: sections,
                                  sessionId: currentSessionId.value ?? '',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      label: hasCompletedQuiz
                          ? 'Lihat Review'
                          : 'Mulai Quiz Pembelajaran',
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            )
          : null,
    );
  }
}
