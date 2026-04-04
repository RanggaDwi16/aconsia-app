import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_search_field.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class KontenPasienPage extends HookConsumerWidget {
  const KontenPasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final profilePasien = ref.watch(fetchPasienProfileProvider(pasienId: uid));
    final searchController = useTextEditingController();
    final searchQuery = useState('');

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [
          UiPalette.blue50,
          UiPalette.white,
        ],
        child: profilePasien.when(
          data: (profile) {
            if (profile?.dokterId == null || profile!.dokterId!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(UiSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 64, color: Colors.grey),
                      Gap(UiSpacing.md),
                      Text(
                        'Belum ada dokter yang ditugaskan',
                        style: TextStyle(
                          fontSize: 16,
                          color: UiPalette.slate500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            final kontenAsync = ref.watch(
              fetchKontenByDokterIdProvider(dokterId: profile.dokterId!),
            );

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(fetchPasienProfileProvider);
                ref.invalidate(fetchKontenByDokterIdProvider);
                ref.invalidate(fetchQuizResultByKontenProvider);

                await Future.delayed(Duration(milliseconds: 300));
              },
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  // 🔹 Padding di atas
                  SliverPadding(
                    padding: EdgeInsets.all(UiSpacing.md),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AconsiaTopActionRow(
                            title: 'Konten Pembelajaran',
                            subtitle: 'Materi edukasi dari dokter Anda',
                            trailing: IconButton(
                              onPressed: () => context.showLogoutDialog(ref),
                              icon: const Icon(Icons.logout_rounded),
                              color: UiPalette.slate600,
                            ),
                          ),
                          Gap(UiSpacing.md),
                          CustomSearchField(
                            controller: searchController,
                            hintText: 'Cari konten...',
                            onChanged: (value) {
                              searchQuery.value = value.toLowerCase();
                            },
                          ),
                          Gap(UiSpacing.md),
                          const AconsiaInfoBanner(
                            icon: Icons.lightbulb_outline,
                            message:
                                'Baca konten dari dokter sampai selesai, lalu lanjutkan sesi AI untuk cek pemahaman.',
                            backgroundColor: Color(0xFFEFF6FF),
                            borderColor: Color(0xFFDCEAFF),
                            iconColor: UiPalette.blue600,
                            textColor: Color(0xFF23415F),
                          ),
                          Gap(UiSpacing.sm),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => context.pushNamed(
                                RouteName.chatAi,
                                extra: const {'source': 'konten_pasien'},
                              ),
                              icon: const Icon(Icons.smart_toy_outlined),
                              label: const Text('Buka Sesi AI Sekarang'),
                            ),
                          ),
                          Gap(UiSpacing.lg),
                          const AconsiaSectionTitle(
                            title: 'Materi Pembelajaran',
                            subtitle: 'Konten edukasi dari dokter Anda',
                            titleSize: 22,
                          ),
                          Gap(UiSpacing.md),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 List konten dari dokter
                  kontenAsync.when(
                    data: (kontenList) {
                      if (kontenList == null || kontenList.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.description_outlined,
                                    size: 64, color: Colors.grey),
                                Gap(UiSpacing.md),
                                Text(
                                  'Belum ada konten tersedia',
                                  style:
                                      TextStyle(color: UiPalette.slate500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final filteredKonten = kontenList.where((konten) {
                        if (searchQuery.value.isEmpty) return true;
                        return (konten.judul ?? '')
                                .toLowerCase()
                                .contains(searchQuery.value) ||
                            (konten.jenisAnestesi ?? '')
                                .toLowerCase()
                                .contains(searchQuery.value);
                      }).toList();

                      if (filteredKonten.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off,
                                    size: 64, color: Colors.grey),
                                Gap(UiSpacing.md),
                                Text(
                                  'Tidak ada konten yang cocok',
                                  style:
                                      TextStyle(color: UiPalette.slate500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverList.separated(
                        itemCount: filteredKonten.length,
                        separatorBuilder: (_, __) => Gap(UiSpacing.md),
                        itemBuilder: (context, index) {
                          final konten = filteredKonten[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: UiSpacing.md,
                            ),
                            child: _buildKontenCard(context, ref, uid, konten),
                          );
                        },
                      );
                    },
                    loading: () => SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stack) => SliverFillRemaining(
                      child: Center(
                        child: Text('Error: $error'),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
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
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                    ),
                  ),
                  Gap(UiSpacing.xs),

                  // Subjudul / jenis anestesi
                  Text(
                    konten.jenisAnestesi ?? 'Jenis anestesi tidak tersedia',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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
