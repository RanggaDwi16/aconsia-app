import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          // Invalidate all providers to refresh data
          ref.invalidate(fetchPasienProfileProvider);
          ref.invalidate(fetchKontenByDokterIdProvider);
          ref.invalidate(fetchQuizResultByKontenProvider);

          // Wait for providers to rebuild
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Pasien',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Pantau progress pembelajaran Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textGrayColor,
                ),
              ),
              Gap(16),
              _buildUnreadKontenCard(
                  context, ref, uid, profilePasien?.dokterId),
              Gap(16),
              AiRecommendationWidget(),
              Gap(32),
              Text(
                'Materi Pembelajaran',
                style: TextStyle(
                  fontSize: 20,
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
    );
  }

  Widget _buildUnreadKontenCard(
      BuildContext context, WidgetRef ref, String? uid, String? dokterId) {
    if (dokterId == null || dokterId.isEmpty || uid == null || uid.isEmpty) {
      return SizedBox.shrink();
    }

    final kontenAsync =
        ref.watch(fetchKontenByDokterIdProvider(dokterId: dokterId));

    return kontenAsync.when(
      data: (kontenList) {
        if (kontenList == null || kontenList.isEmpty) {
          return Card(
            shadowColor: Colors.transparent,
            color: AppColor.primaryColor.withOpacity(0.05),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    child: Icon(Icons.notifications,
                        color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Konten belum dibaca',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Belum ada konten tersedia',
                          style: TextStyle(color: AppColor.textGrayColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Get unread konten (konten without quiz result)
        final unreadKonten = <dynamic>[];
        for (var konten in kontenList) {
          final quizResultAsync = ref.watch(
            fetchQuizResultByKontenProvider(
              pasienId: uid,
              kontenId: konten.id ?? '',
            ),
          );
          final hasCompleted = quizResultAsync.valueOrNull != null;
          if (!hasCompleted) {
            unreadKonten.add(konten);
          }
        }

        final unreadCount = unreadKonten.length;
        final unreadTitles =
            unreadKonten.map((k) => k.judul ?? 'Tanpa Judul').toList();

        return Card(
          shadowColor: Colors.transparent,
          color: AppColor.primaryColor.withOpacity(0.05),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColor.primaryColor,
                      child: Icon(Icons.notifications,
                          color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konten belum dibaca',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '$unreadCount konten belum Anda baca',
                            style: TextStyle(color: AppColor.textGrayColor),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to konten tab (index 1)
                        ref.read(selectedIndexPasienProvider.notifier).state =
                            1;
                      },
                      child: Text('Lihat'),
                    ),
                  ],
                ),
                if (unreadTitles.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    'Daftar konten belum terbaca:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.textGrayColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: unreadTitles.take(5).map((t) {
                      return Chip(
                        label: Text(
                          t,
                          style: TextStyle(fontSize: 12),
                        ),
                        backgroundColor:
                            AppColor.primaryColor.withOpacity(0.12),
                      );
                    }).toList(),
                  ),
                ] else ...[
                  SizedBox(height: 12),
                  Text(
                    'Semua konten telah dibaca.',
                    style: TextStyle(color: AppColor.textGrayColor),
                  ),
                ]
              ],
            ),
          ),
        );
      },
      loading: () => Card(
        shadowColor: Colors.transparent,
        color: AppColor.primaryColor.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColor.primaryColor,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konten belum dibaca',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Memuat data...',
                      style: TextStyle(color: AppColor.textGrayColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) => SizedBox.shrink(),
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
}
