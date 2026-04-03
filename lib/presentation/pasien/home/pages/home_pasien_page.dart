import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_learning_summary_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
      appBar: CustomAppBar(
        customTitleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profilePasien?.namaLengkap ?? 'Pasien',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              profilePasien?.jenisKelamin ?? 'Jenis Kelamin',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        actions: [
          // Notification icon - Hidden for now (Phase 3)
          // Padding(
          //   padding: const EdgeInsets.only(right: 8.0),
          //   child: Stack(
          //     children: [
          //       IconButton(
          //         icon: const Icon(Icons.notifications_outlined),
          //         onPressed: () {
          //           context.pushNamed(RouteName.notificationList);
          //         },
          //       ),
          //       // Unread badge...
          //     ],
          //   ),
          // ),
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
              Color(0xFFF4FAFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Dashboard Pasien',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Pantau progress pembelajaran Anda',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.textGrayColor,
                ),
              ),
              Gap(14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDCEBFF)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.school_outlined, color: AppColor.primaryColor),
                    Gap(10),
                    Expanded(
                      child: Text(
                        'Baca materi dari dokter, lalu selesaikan quiz untuk menilai pemahaman Anda.',
                        style: TextStyle(
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(selectedIndexPasienProvider.notifier).state = 1;
                      },
                      icon: const Icon(Icons.menu_book_outlined, size: 18),
                      label: const Text('Buka Konten'),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.pushNamed(RouteName.profilePasien),
                      icon: const Icon(Icons.person_outline, size: 18),
                      label: const Text('Profil Saya'),
                    ),
                  ),
                ],
              ),
              Gap(16),
              _buildLearningStatusCard(
                context: context,
                ref: ref,
                summaryAsync: learningSummaryAsync,
              ),
              Gap(16),
              _buildLatestQuizInsight(summaryAsync: learningSummaryAsync),
              Gap(16),
              AiRecommendationWidget(),
              Gap(32),
              Text(
                'Materi Pembelajaran',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Konten edukasi dari dokter Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textGrayColor,
                ),
              ),
              Gap(16),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EAF4)),
      ),
      child: summaryAsync.when(
        data: (summary) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Belajar Saat Ini',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF132A45),
                ),
              ),
              const Gap(8),
              Text(
                summary.totalKonten == 0
                    ? 'Belum ada materi dari dokter Anda.'
                    : '${summary.unreadKonten} materi belum selesai dari total ${summary.totalKonten} materi.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.textGrayColor,
                ),
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: _metricItem(
                      title: 'Progress',
                      value: '${summary.completionRate.toStringAsFixed(0)}%',
                      color: const Color(0xFF0EA5E9),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _metricItem(
                      title: 'Selesai',
                      value: '${summary.completedKonten}',
                      color: const Color(0xFF22C35D),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _metricItem(
                      title: 'Belum',
                      value: '${summary.unreadKonten}',
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const Gap(10),
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
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Text(
          'Gagal memuat status belajar: $error',
          style: const TextStyle(
            color: AppColor.primaryRed,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLatestQuizInsight({
    required AsyncValue<PasienLearningSummary> summaryAsync,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EAF4)),
      ),
      child: summaryAsync.when(
        data: (summary) {
          final latest = summary.latestQuiz;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Insight Quiz',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF132A45),
                ),
              ),
              const Gap(8),
              if (latest == null)
                Text(
                  'Belum ada hasil quiz. Selesaikan materi dan quiz untuk melihat insight.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.textGrayColor,
                  ),
                )
              else ...[
                Text(
                  'Rata-rata nilai quiz Anda ${summary.averageQuizScore.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.textGrayColor,
                  ),
                ),
                const Gap(10),
                Row(
                  children: [
                    Expanded(
                      child: _metricItem(
                        title: 'Quiz Terakhir',
                        value: '${latest.overallScore}%',
                        color: _quizScoreColor(latest.overallScore),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _metricItem(
                        title: 'Total Quiz',
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
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 64, color: Colors.grey),
              Gap(16),
              Text(
                'Belum ada dokter yang ditugaskan',
                style: TextStyle(color: AppColor.textGrayColor),
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
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.description_outlined,
                      size: 64, color: Colors.grey),
                  Gap(16),
                  Text(
                    'Belum ada konten tersedia',
                    style: TextStyle(color: AppColor.textGrayColor),
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
                Gap(16),
              ],
            );
          }).toList(),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              Gap(16),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    konten.judul ?? 'Judul tidak tersedia',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textColor,
                    ),
                  ),
                  Gap(6),

                  // Subjudul / jenis anestesi
                  Text(
                    konten.jenisAnestesi ?? 'Jenis anestesi tidak tersedia',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Gap(12),

                  // ----------------- TAGS -----------------
                  SizedBox(
                    height: 32,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (hasCompletedQuiz) ...[
                          StatusSelesaiTag(),
                          Gap(8),
                        ],
                        if (konten.jenisAnestesi != null) ...[
                          JenisAnestesiTag(text: konten.jenisAnestesi!),
                          Gap(8),
                        ],
                        if (konten.tataCara != null) ...[
                          TataCaraTag(text: konten.tataCara!),
                          Gap(8),
                        ],
                        if (konten.resikoTindakan != null) ...[
                          KomplikasiTag(text: konten.resikoTindakan!),
                          Gap(8),
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
                              foregroundColor: AppColor.primaryColor,
                              side: BorderSide(
                                  color: AppColor.primaryColor, width: 1.5),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Review',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
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
                              backgroundColor: AppColor.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Mulai',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              fontSize: 11,
              color: Color(0xFF5F748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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
}
