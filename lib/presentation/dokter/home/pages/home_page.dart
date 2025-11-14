import 'package:aconsia_app/core/helpers/widgets/empty_list_data.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_count_by_dokter_id/fetch_pasien_count_by_dokter_id_provider.dart';
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

    print('[DokterHome] 📊 Active Reader Count: $activeReaderCount');
    print('[DokterHome] 👨‍⚕️ Dokter UID: $uid');

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
      body: RefreshIndicator(
        onRefresh: () async {
          // Invalidate all providers to refresh data
          ref.invalidate(fetchDokterProfileProvider);
          ref.invalidate(fetchKontenByDokterIdProvider);
          ref.invalidate(fetchKontenCountByDokterIdProvider);
          ref.invalidate(fetchPasienCountByDokterIdProvider);
          ref.invalidate(activeReadingSessionsStreamProvider);

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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Text(
                'Kelola konten edukasi dan pantau pasien Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textGrayColor,
                ),
              ),
              Gap(32),
              // Show alert only if there are active readers
              if (activeReaderCount > 0) ...[
                AlertPasienReadWidget(activeReaderCount: activeReaderCount),
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
                title: 'Daftar Pasien Sakit',
                count: totalPasien.when(
                  data: (data) => data.toString(),
                  loading: () => '...',
                  error: (err, stack) => 'Error',
                ),
                iconPath: Assets.icons.icPeoples.path,
                onPressed: () => context.pushNamed(RouteName.listActivePasien),
              ),
              Gap(32),
              Text(
                'Konten Terbaru',
                style: TextStyle(
                  fontSize: 20,
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
    );
  }
}
