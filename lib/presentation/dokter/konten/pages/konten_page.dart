import 'package:aconsia_app/core/helpers/widgets/empty_list_data.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_search_field.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/presentation/dokter/konten/widgets/item_konten_widget.dart';
import 'package:flutter/material.dart';
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

    final searchController = useTextEditingController();
    final searchQuery = useState(''); // 🔍 untuk menampung kata kunci

    return Scaffold(
      body: SafeArea(
        child: AconsiaPageBackground(
          colors: const [
            Color(0xFFF8FAFC),
            UiPalette.white,
          ],
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fetchKontenByDokterIdProvider);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const AconsiaSectionTitle(
                  title: 'Manajemen Konten',
                  subtitle: 'Kelola materi edukasi anestesi Anda',
                ),
                const Gap(UiSpacing.md),
                AconsiaInfoBanner(
                  icon: Icons.auto_awesome,
                  message: allKonten.when(
                    data: (items) =>
                        '${items?.length ?? 0} konten aktif siap dibagikan ke pasien.',
                    loading: () => 'Memuat jumlah konten...',
                    error: (_, __) => 'Data konten belum tersedia.',
                  ),
                  backgroundColor: const Color(0xFFEFF6FF),
                  borderColor: const Color(0xFFDCEAFF),
                  iconColor: UiPalette.blue600,
                  textColor: const Color(0xFF23415F),
                ),
                const Gap(UiSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 390;

                    if (isNarrow) {
                      return Column(
                        children: [
                          CustomSearchField(
                            hintText: 'Cari konten...',
                            controller: searchController,
                            onChanged: (value) {
                              searchQuery.value = value.trim().toLowerCase();
                            },
                          ),
                          const Gap(UiSpacing.sm),
                          Button.filled(
                            onPressed: () =>
                                context.pushNamed(RouteName.addKonten),
                            height: 52,
                            label: 'Konten Baru',
                            icon: const Icon(Icons.add, color: Colors.white),
                            color: UiPalette.blue600,
                            borderColor: UiPalette.blue600,
                            borderRadius: 12,
                          ),
                        ],
                      );
                    }

                    return Row(
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
                        const Gap(UiSpacing.sm),
                        SizedBox(
                          width: constraints.maxWidth * 0.4,
                          child: Button.filled(
                            onPressed: () =>
                                context.pushNamed(RouteName.addKonten),
                            height: 52,
                            label: 'Konten Baru',
                            icon: const Icon(Icons.add, color: Colors.white),
                            color: UiPalette.blue600,
                            borderColor: UiPalette.blue600,
                            borderRadius: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Gap(UiSpacing.xl),
                allKonten.when(
                  data: (kontens) {
                    if (kontens == null || kontens.isEmpty) {
                      return emptyListData(context);
                    }

                    // 🔍 Filter berdasarkan semua isi konten
                    final filteredKonten = kontens.where((konten) {
                      final query = searchQuery.value;

                      if (query.isEmpty) return true;

                      return (konten.judul ?? '')
                              .toLowerCase()
                              .contains(query) ||
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
                            const Gap(UiSpacing.sm),
                            Text(
                              'Tidak ada konten sesuai pencarian',
                              style: TextStyle(
                                fontSize: 14,
                                color: UiPalette.slate500,
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
                      separatorBuilder: (_, __) => const Gap(UiSpacing.md),
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
        ),
      ),
    );
  }
}
