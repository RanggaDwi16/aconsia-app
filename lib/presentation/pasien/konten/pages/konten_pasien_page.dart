import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_accessible_konten_provider.dart';
import 'package:aconsia_app/presentation/pasien/konten/controllers/material_read_progress_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_search_field.dart';
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
              pasienAccessibleKontenProvider(
                PasienAccessibleKontenParams(
                  pasienId: uid,
                  dokterId: profile.dokterId!,
                ),
              ),
            );

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(fetchPasienProfileProvider);
                ref.invalidate(pasienAccessibleKontenProvider);
                ref.invalidate(materialReadProgressMapProvider);

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
                            leading: IconButton(
                              onPressed: () => PasienMainShellScope.maybeOf(
                                context,
                              )?.openDrawer(),
                              icon: const Icon(Icons.menu_rounded),
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
                      if (kontenList.isEmpty) {
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
                                  'Belum ada konten published atau assignment dari dokter.',
                                  style: TextStyle(color: UiPalette.slate500),
                                  textAlign: TextAlign.center,
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
                                  style: TextStyle(color: UiPalette.slate500),
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
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(UiSpacing.lg),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4F4),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFFFECACA)),
                            ),
                            child: const AconsiaCardSurface(
                              borderColor: Colors.transparent,
                              child: _KontenErrorMessage(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text(
              'Profil pasien belum dapat dimuat. Silakan coba lagi.',
              style: UiTypography.bodySmall.copyWith(color: UiPalette.red600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKontenCard(
      BuildContext context, WidgetRef ref, String uid, KontenModel konten) {
    final kontenId = konten.id ?? '';
    final sectionsAsync =
        ref.watch(fetchSectionsByKontenIdProvider(kontenId: kontenId));
    final totalSections = sectionsAsync.valueOrNull?.length ?? 0;
    final progressAsync = ref.watch(
      materialReadProgressProvider(
        MaterialReadProgressParams(
          pasienId: uid,
          kontenId: kontenId,
          totalSections: totalSections,
        ),
      ),
    );
    final progress = progressAsync.valueOrNull ??
        MaterialReadProgress(
          kontenId: kontenId,
          totalSections: totalSections,
          completedSectionIds: const <String>[],
          currentSectionIndex: 0,
        );
    final title = (konten.judul ?? 'Judul tidak tersedia').trim();
    final anesthesia =
        (konten.jenisAnestesi ?? 'Jenis anestesi tidak tersedia').trim();
    final description = (konten.indikasiTindakan ??
            konten.resikoTindakan ??
            'Konten edukasi dari dokter Anda')
        .trim();

    final tags = <String>[
      progress.statusLabel,
      if ((konten.jenisAnestesi ?? '').trim().isNotEmpty)
        konten.jenisAnestesi!.trim(),
      if ((konten.indikasiTindakan ?? '').trim().isNotEmpty)
        konten.indikasiTindakan!.trim(),
      if ((konten.resikoTindakan ?? '').trim().isNotEmpty)
        konten.resikoTindakan!.trim(),
    ];
    final visibleTags = tags.take(2).toList();
    final hiddenTagCount = tags.length - visibleTags.length;

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteName.detailKonten,
          extra: konten.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: UiPalette.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                UiSpacing.md,
                UiSpacing.md,
                UiSpacing.md,
                0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: UiPalette.blue600,
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Expanded(
                    child: Text(
                      anesthesia,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: UiPalette.slate500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildProgressBadge(progress.statusLabel),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                      height: 1.25,
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: UiPalette.slate600,
                      height: 1.35,
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Wrap(
                    spacing: UiSpacing.xs,
                    runSpacing: UiSpacing.xs,
                    children: [
                      for (final tag in visibleTags) _buildInfoTag(tag),
                      if (hiddenTagCount > 0)
                        _buildInfoTag('+$hiddenTagCount info'),
                    ],
                  ),
                  const Gap(UiSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
                          vertical: UiSpacing.md - 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        progress.actionLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
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

  Widget _buildProgressBadge(String statusLabel) {
    final isDone = statusLabel == 'Selesai';
    final isReading = statusLabel == 'Sedang Dibaca';
    final bgColor = isDone
        ? const Color(0xFFDCFCE7)
        : isReading
            ? const Color(0xFFEFF6FF)
            : const Color(0xFFFFF7ED);
    final borderColor = isDone
        ? const Color(0xFF86EFAC)
        : isReading
            ? const Color(0xFFBFDBFE)
            : const Color(0xFFFED7AA);
    final textColor = isDone
        ? const Color(0xFF166534)
        : isReading
            ? const Color(0xFF1D4ED8)
            : const Color(0xFF9A3412);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        statusLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoTag(String text) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          color: UiPalette.slate700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _KontenErrorMessage extends StatelessWidget {
  const _KontenErrorMessage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error_outline_rounded,
          color: UiPalette.red600,
          size: 32,
        ),
        const Gap(UiSpacing.sm),
        Text(
          'Materi belum bisa dimuat.',
          style: UiTypography.label.copyWith(
            color: const Color(0xFF991B1B),
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(UiSpacing.xs),
        Text(
          'Silakan tarik layar ke bawah untuk mencoba lagi.',
          style: UiTypography.bodySmall.copyWith(
            color: UiPalette.slate500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
