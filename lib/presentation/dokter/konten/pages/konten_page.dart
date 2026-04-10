import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/widgets/item_konten_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KontenPage extends HookConsumerWidget {
  const KontenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = useStream<User?>(
      FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
    );
    final uid = authState.data?.uid;
    final allKonten = uid == null
        ? const AsyncLoading<List<KontenModel>>()
        : ref.watch(fetchKontenByDokterIdProvider(dokterId: uid));

    return Scaffold(
      body: SafeArea(
        child: AconsiaPageBackground(
          colors: const [Color(0xFFF8FAFC), UiPalette.white],
          child: RefreshIndicator(
            onRefresh: () async {
              if (uid != null) {
                ref.invalidate(fetchKontenByDokterIdProvider(dokterId: uid));
              }
              await Future.delayed(const Duration(milliseconds: 450));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UiSpacing.md),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 620;

                  return allKonten.when(
                    loading: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isNarrow),
                        const Gap(UiSpacing.xl),
                        const Center(
                            child: CircularProgressIndicator.adaptive()),
                      ],
                    ),
                    error: (error, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isNarrow),
                        const Gap(UiSpacing.lg),
                        AconsiaCardSurface(
                          borderColor: const Color(0xFFFECACA),
                          padding: const EdgeInsets.all(UiSpacing.md),
                          child: Text(
                            'Gagal memuat konten: $error',
                            style: const TextStyle(
                              color: UiPalette.red600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    data: (kontens) {
                      final publishedCount = kontens
                          .where(
                            (item) =>
                                (item.status ?? '').trim().toLowerCase() ==
                                'published',
                          )
                          .length;
                      final draftCount = kontens.length - publishedCount;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context, isNarrow),
                          const Gap(UiSpacing.md),
                          _buildSummarySection(
                            isNarrow: isNarrow,
                            totalCount: kontens.length,
                            publishedCount: publishedCount,
                            draftCount: draftCount,
                          ),
                          const Gap(UiSpacing.md),
                          AconsiaCardSurface(
                            radius: 16,
                            borderColor: const Color(0xFFE2E8F0),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daftar Konten Edukasi',
                                  style: TextStyle(
                                    fontSize: 30 / 2,
                                    fontWeight: FontWeight.w700,
                                    color: UiPalette.slate900,
                                  ),
                                ),
                                const Gap(UiSpacing.xs),
                                const Text(
                                  'Daftar konten edukasi yang telah Anda buat.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: UiPalette.slate500,
                                  ),
                                ),
                                const Gap(UiSpacing.sm),
                                if (kontens.isEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(UiSpacing.md),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: const Text(
                                      'Belum ada konten untuk dokter ini.',
                                      style: TextStyle(
                                        color: UiPalette.slate500,
                                      ),
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: kontens.length,
                                    separatorBuilder: (_, __) =>
                                        const Gap(UiSpacing.xs),
                                    itemBuilder: (context, index) {
                                      return ItemKontenWidget(
                                        konten: kontens[index],
                                        isHome: false,
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isNarrow) {
    final addButton = SizedBox(
      width: isNarrow ? double.infinity : 180,
      child: ElevatedButton.icon(
        onPressed: () => context.pushNamed(RouteName.addKonten),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Tambah Konten'),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: UiPalette.blue600,
          foregroundColor: UiPalette.white,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AconsiaSectionTitle(
            title: 'Konten Edukasi',
            subtitle: 'Kelola konten edukasi untuk pasien Anda.',
          ),
          const Gap(UiSpacing.md),
          addButton,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: AconsiaSectionTitle(
            title: 'Konten Edukasi',
            subtitle: 'Kelola konten edukasi untuk pasien Anda.',
          ),
        ),
        const Gap(UiSpacing.md),
        addButton,
      ],
    );
  }

  Widget _buildSummarySection({
    required bool isNarrow,
    required int totalCount,
    required int publishedCount,
    required int draftCount,
  }) {
    final cards = [
      _SummaryCardData(
        title: 'Total Konten',
        value: totalCount,
        icon: Icons.description_outlined,
        iconColor: UiPalette.blue600,
        iconBackground: const Color(0xFFDBEAFE),
      ),
      _SummaryCardData(
        title: 'Published',
        value: publishedCount,
        icon: Icons.menu_book_outlined,
        iconColor: const Color(0xFF16A34A),
        iconBackground: const Color(0xFFDCFCE7),
      ),
      _SummaryCardData(
        title: 'Draft',
        value: draftCount,
        icon: Icons.edit_note_rounded,
        iconColor: const Color(0xFFD97706),
        iconBackground: const Color(0xFFFEF3C7),
      ),
    ];

    if (isNarrow) {
      return Column(
        children: [
          for (final card in cards) ...[
            _SummaryCard(data: card),
            if (card != cards.last) const Gap(UiSpacing.xs),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: _SummaryCard(data: cards[i])),
          if (i < cards.length - 1) const Gap(UiSpacing.md),
        ],
      ],
    );
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _SummaryCardData data;

  @override
  Widget build(BuildContext context) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.md,
        vertical: UiSpacing.sm,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 76),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: data.iconColor),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: UiPalette.slate600,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    '${data.value}',
                    style: const TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
