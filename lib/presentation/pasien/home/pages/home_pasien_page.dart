import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_learning_summary_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/ai_recommendation_widget.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      body: AconsiaPageBackground(
        colors: [
          UiPalette.blue50,
          UiPalette.white,
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienProfileProvider);
            ref.invalidate(fetchKontenByDokterIdProvider);
            ref.invalidate(fetchQuizResultByKontenProvider);
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
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AconsiaTopActionRow(
                  title: 'Dashboard Pasien',
                  subtitle: 'Pantau progress pembelajaran Anda',
                  trailing: IconButton(
                    onPressed: () => context.showLogoutDialog(ref),
                    icon: const Icon(Icons.logout_rounded),
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
                Wrap(
                  spacing: UiSpacing.sm,
                  runSpacing: UiSpacing.sm,
                  children: [
                    _quickActionCard(
                      icon: Icons.menu_book_outlined,
                      label: 'Buka Konten',
                      onTap: () {
                        ref.read(selectedIndexPasienProvider.notifier).state =
                            1;
                      },
                    ),
                    _quickActionCard(
                      icon: Icons.person_outline,
                      label: 'Profil Saya',
                      onTap: () => context.pushNamed(RouteName.profilePasien),
                    ),
                    _quickActionCard(
                      icon: Icons.smart_toy_outlined,
                      label: 'Diskusi AI',
                      onTap: () => context.pushNamed(
                        RouteName.chatAi,
                        extra: const {'source': 'home_pasien'},
                      ),
                    ),
                  ],
                ),
                const Gap(UiSpacing.md),
                _buildLearningStatusCard(
                  context: context,
                  ref: ref,
                  summaryAsync: learningSummaryAsync,
                ),
                const Gap(UiSpacing.md),
                _buildLatestQuizInsight(summaryAsync: learningSummaryAsync),
                const Gap(UiSpacing.md),
                const AiRecommendationWidget(),
                const Gap(32),
                const Text(
                  'Materi Pembelajaran',
                  style: UiTypography.h2,
                ),
                const Gap(UiSpacing.sm),
                const Text(
                  'Konten edukasi dari dokter Anda',
                  style: UiTypography.bodySmall,
                ),
                const Gap(UiSpacing.md),
                // Fetch real konten data from Firestore
                _buildKontenList(context, ref, profilePasien?.dokterId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLearningStatusCard({
    required BuildContext context,
    required WidgetRef ref,
    required AsyncValue<PasienLearningSummary> summaryAsync,
  }) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFE2EAF4),
      child: summaryAsync.when(
        data: (summary) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Belajar Saat Ini',
                style: UiTypography.label,
              ),
              const Gap(UiSpacing.sm),
              Text(
                summary.totalKonten == 0
                    ? 'Belum ada materi dari dokter Anda.'
                    : '${summary.unreadKonten} materi belum selesai dari total ${summary.totalKonten} materi.',
                style: TextStyle(
                  fontSize: UiTypography.bodySmall.fontSize,
                  color: UiTypography.bodySmall.color,
                ),
              ),
              const Gap(UiSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _metricItem(
                      title: 'Progress',
                      value: '${summary.completionRate.toStringAsFixed(0)}%',
                      color: const Color(0xFF0EA5E9),
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Expanded(
                    child: _metricItem(
                      title: 'Selesai',
                      value: '${summary.completedKonten}',
                      color: const Color(0xFF22C35D),
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Expanded(
                    child: _metricItem(
                      title: 'Belum',
                      value: '${summary.unreadKonten}',
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const Gap(UiSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    ref.read(selectedIndexPasienProvider.notifier).state = 1;
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Lanjut Belajar'),
                ),
              )
            ],
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: UiSpacing.sm),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Text(
          'Gagal memuat status belajar: $error',
          style: const TextStyle(
            color: UiPalette.red600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildLatestQuizInsight({
    required AsyncValue<PasienLearningSummary> summaryAsync,
  }) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFE2EAF4),
      child: summaryAsync.when(
        data: (summary) {
          final latest = summary.latestQuiz;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Insight Sesi AI',
                style: UiTypography.label,
              ),
              const Gap(UiSpacing.sm),
              if (latest == null)
                Text(
                  'Belum ada hasil sesi. Selesaikan materi dan sesi AI untuk melihat insight.',
                  style: TextStyle(
                    fontSize: UiTypography.bodySmall.fontSize,
                    color: UiTypography.bodySmall.color,
                  ),
                )
              else ...[
                Text(
                  'Rata-rata nilai sesi AI Anda ${summary.averageQuizScore.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: UiTypography.bodySmall.fontSize,
                    color: UiTypography.bodySmall.color,
                  ),
                ),
                const Gap(UiSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _metricItem(
                        title: 'Sesi Terakhir',
                        value: '${latest.overallScore}%',
                        color: _quizScoreColor(latest.overallScore),
                      ),
                    ),
                    const Gap(UiSpacing.sm),
                    Expanded(
                      child: _metricItem(
                        title: 'Total Sesi',
                        value: '${summary.totalQuiz}',
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildKontenList(
      BuildContext context, WidgetRef ref, String? dokterId) {
    if (dokterId == null || dokterId.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(UiSpacing.xxl),
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 64, color: Colors.grey),
              Gap(UiSpacing.md),
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

    final kontenAsync =
        ref.watch(fetchKontenByDokterIdProvider(dokterId: dokterId));

    return kontenAsync.when(
      data: (kontenList) {
        if (kontenList == null || kontenList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(UiSpacing.xxl),
              child: Column(
                children: [
                  Icon(Icons.description_outlined,
                      size: 64, color: Colors.grey),
                  Gap(UiSpacing.md),
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

        // Show only first 5 konten for home page
        final displayKonten = kontenList.take(5).toList();
        final uid = FirebaseAuth.instance.currentUser?.uid;

        return Column(
          children: displayKonten.map((konten) {
            return Column(
              children: [
                _buildKontenCard(context, ref, uid!, konten),
                Gap(UiSpacing.md),
              ],
            );
          }).toList(),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(UiSpacing.xxl),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              Gap(UiSpacing.md),
              Text(
                'Gagal memuat konten: $error',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKontenCard(
      BuildContext context, WidgetRef ref, String uid, KontenModel konten) {
    final quizResultAsync = ref.watch(
      fetchQuizResultByKontenProvider(
        pasienId: uid,
        kontenId: konten.id ?? '',
      ),
    );

    final hasCompletedQuiz = quizResultAsync.valueOrNull != null;

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteName.detailKonten,
          extra: konten.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- IMAGE BANNER -----------------
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: konten.gambarUrl != null
                    ? Image.network(
                        konten.gambarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child:
                              Icon(Icons.image, size: 48, color: Colors.grey),
                        ),
                      ),
              ),
            ),

            // ----------------- CONTENT -----------------
            Padding(
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    konten.judul ?? 'Judul tidak tersedia',
                    style: UiTypography.label.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                    ),
                  ),
                  Gap(UiSpacing.xs),

                  // Subjudul / jenis anestesi
                  Text(
                    konten.jenisAnestesi ?? 'Jenis anestesi tidak tersedia',
                    style: UiTypography.bodySmall.copyWith(
                      color: UiPalette.slate500,
                    ),
                  ),
                  Gap(UiSpacing.md),

                  // ----------------- TAGS -----------------
                  SizedBox(
                    height: 32,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (hasCompletedQuiz) ...[
                          StatusSelesaiTag(),
                          Gap(UiSpacing.sm),
                        ],
                        if (konten.jenisAnestesi != null) ...[
                          JenisAnestesiTag(text: konten.jenisAnestesi!),
                          Gap(UiSpacing.sm),
                        ],
                        if (konten.tataCara != null) ...[
                          TataCaraTag(text: konten.tataCara!),
                          Gap(UiSpacing.sm),
                        ],
                        if (konten.resikoTindakan != null) ...[
                          KomplikasiTag(text: konten.resikoTindakan!),
                          Gap(UiSpacing.sm),
                        ],
                        if (konten.indikasiTindakan != null)
                          IndikasiTindakanTag(text: konten.indikasiTindakan!),
                      ],
                    ),
                  ),
                  Gap(20),

                  // ----------------- BUTTON -----------------
                  SizedBox(
                    width: double.infinity,
                    child: hasCompletedQuiz
                        ? OutlinedButton(
                            onPressed: () {
                              context.pushNamed(
                                RouteName.detailKonten,
                                extra: konten.id,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: UiPalette.blue600,
                              side: BorderSide(
                                  color: UiPalette.blue600, width: 1.5),
                              padding: EdgeInsets.symmetric(
                                vertical: UiSpacing.sm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Review',
                              style: UiTypography.button.copyWith(
                                color: UiPalette.blue600,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              context.pushNamed(
                                RouteName.detailKonten,
                                extra: konten.id,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UiPalette.blue600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: UiSpacing.sm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Mulai',
                              style: UiTypography.button.copyWith(
                                color: UiPalette.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _metricItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.sm,
        vertical: UiSpacing.sm,
      ),
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
              color: Color(0xFF5F748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(UiSpacing.xs),
          Text(
            value,
            style: UiTypography.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _quizScoreColor(int score) {
    if (score >= 80) return const Color(0xFF16A34A);
    if (score >= 60) return const Color(0xFF0EA5E9);
    return const Color(0xFFF59E0B);
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
        width: 166,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: UiPalette.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDDE7F3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: UiPalette.blue600, size: 20),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: UiPalette.slate900,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: UiPalette.slate400,
            ),
          ],
        ),
      ),
    );
  }
}
