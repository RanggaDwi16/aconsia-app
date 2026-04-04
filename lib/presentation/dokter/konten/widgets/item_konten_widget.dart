import 'package:aconsia_app/presentation/dokter/konten/controllers/delete_konten/put_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ItemKontenWidget extends ConsumerWidget {
  final KontenModel konten;
  final bool? isHome;

  const ItemKontenWidget({
    super.key,
    required this.konten,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String category = konten.jenisAnestesi ?? 'Kategori tidak tersedia';
    String subCategory = konten.resikoTindakan ?? 'Subkategori tidak tersedia';

    return AconsiaCardSurface(
      radius: 14,
      borderColor: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.all(UiSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  konten.judul!.length > 38
                      ? '${konten.judul!.substring(0, 38)}...'
                      : konten.judul!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: UiPalette.slate900,
                  ),
                ),
              ),
              if (isHome == false) ...[
                const Gap(UiSpacing.sm),
                GestureDetector(
                  onTap: () => context.showDeleteContentDialog(
                    onConfirm: () {
                      ref.read(putKontenProvider.notifier).putKonten(
                            kontenId: konten.id!,
                            onSuccess: (message) {
                              context.showSuccessDialog(
                                  context, 'Konten berhasil dihapus.');
                              ref.invalidate(
                                fetchKontenByDokterIdProvider(
                                    dokterId:
                                        FirebaseAuth.instance.currentUser?.uid ?? ''),
                              );
                            },
                            onError: (message) {
                              context.showErrorSnackbar(context, message);
                            },
                          );
                    },
                  ),
                  child: SvgPicture.asset(
                    Assets.icons.icDelete.path,
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ],
          ),
          const Gap(UiSpacing.md),
          Wrap(
            spacing: UiSpacing.sm,
            runSpacing: UiSpacing.sm,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiSpacing.sm,
                  vertical: UiSpacing.xs,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: UiPalette.slate300, width: 1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: UiPalette.slate700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiSpacing.sm,
                  vertical: UiSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: UiPalette.blue50,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  subCategory,
                  style: const TextStyle(
                    fontSize: 12,
                    color: UiPalette.blue600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final useVerticalAction = constraints.maxWidth < 350;
              final dateText = konten.updatedAt != null
                  ? '${konten.updatedAt!.day}-${konten.updatedAt!.month}-${konten.updatedAt!.year} (Diperbarui)'
                  : konten.createdAt != null
                      ? '${konten.createdAt!.day}-${konten.createdAt!.month}-${konten.createdAt!.year}'
                      : 'Tanggal tidak tersedia';

              if (useVerticalAction) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.icons.icKonten.path,
                          width: 18,
                          height: 18,
                          color: UiPalette.slate500,
                        ),
                        const Gap(UiSpacing.xs),
                        Expanded(
                          child: Text(
                            dateText,
                            style: const TextStyle(
                              fontSize: 13,
                              color: UiPalette.slate500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(UiSpacing.sm),
                    Button.outlined(
                      onPressed: () => context.pushNamed(
                        RouteName.detailKonten,
                        extra: konten.id,
                      ),
                      height: 40,
                      label: "Lihat Detail",
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.icKonten.path,
                    width: 18,
                    height: 18,
                    color: UiPalette.slate500,
                  ),
                  const Gap(UiSpacing.xs),
                  Expanded(
                    child: Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 13,
                        color: UiPalette.slate500,
                      ),
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Button.outlined(
                    onPressed: () => context.pushNamed(
                      RouteName.detailKonten,
                      extra: konten.id,
                    ),
                    width: 120,
                    height: 40,
                    label: "Lihat Detail",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
