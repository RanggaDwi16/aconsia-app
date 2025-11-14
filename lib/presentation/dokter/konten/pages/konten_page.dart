import 'package:aconsia_app/core/helpers/widgets/empty_list_data.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/fetch_dokter_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_search_field.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/konten/widgets/item_konten_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KontenPage extends HookConsumerWidget {
  const KontenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final allKonten =
        ref.watch(fetchKontenByDokterIdProvider(dokterId: uid ?? ''));
    final profileDokter = ref.watch(fetchDokterProfileProvider(uid: uid ?? ''));

    final searchController = useTextEditingController();
    final searchQuery = useState(''); // 🔍 untuk menampung kata kunci

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
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.showLogoutDialog(ref);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Invalidate providers to refresh data
          ref.invalidate(fetchKontenByDokterIdProvider);
          ref.invalidate(fetchDokterProfileProvider);

          // Wait for providers to rebuild
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manajemen Konten',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Kelola materi edukasi anestesi Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textGrayColor,
                ),
              ),
              const Gap(32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomSearchField(
                      hintText: 'Cari konten...',
                      controller: searchController,
                      onChanged: (value) {
                        searchQuery.value = value.trim().toLowerCase();
                      },
                    ),
                  ),
                  const Gap(12),
                  Button.filled(
                    onPressed: () => context.pushNamed(RouteName.addKonten),
                    height: 52,
                    width: context.deviceWidth * 0.4,
                    label: 'Konten Baru',
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const Gap(32),
              allKonten.when(
                data: (kontens) {
                  if (kontens == null || kontens.isEmpty) {
                    return emptyListData(context);
                  }

                  // 🔍 Filter berdasarkan semua isi konten
                  final filteredKonten = kontens.where((konten) {
                    final query = searchQuery.value;

                    if (query.isEmpty) return true;

                    return (konten.judul ?? '').toLowerCase().contains(query) ||
                        (konten.jenisAnestesi ?? '')
                            .toLowerCase()
                            .contains(query) ||
                        (konten.resikoTindakan ?? '')
                            .toLowerCase()
                            .contains(query) ||
                        // Search juga di tanggal (prioritas updatedAt)
                        (konten.updatedAt != null &&
                            '${konten.updatedAt!.day}-${konten.updatedAt!.month}-${konten.updatedAt!.year}'
                                .contains(query)) ||
                        (konten.createdAt != null &&
                            '${konten.createdAt!.day}-${konten.createdAt!.month}-${konten.createdAt!.year}'
                                .contains(query));
                  }).toList();

                  if (filteredKonten.isEmpty) {
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
                    itemCount: filteredKonten.length,
                    separatorBuilder: (_, __) => const Gap(16),
                    itemBuilder: (context, index) {
                      return ItemKontenWidget(
                        konten: filteredKonten[index],
                        isHome: false,
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
