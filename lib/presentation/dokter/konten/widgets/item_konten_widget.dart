import 'package:aconsia_app/presentation/dokter/konten/controllers/delete_konten/put_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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

    return Container(
      width: context.deviceWidth,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  konten.judul!.length > 15
                      ? '${konten.judul!.substring(0, 15)}...'
                      : konten.judul!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isHome == false) ...[
                  Spacer(),
                  Gap(16),
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
                                      dokterId: FirebaseAuth
                                              .instance.currentUser?.uid ??
                                          ''),
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
                ]
              ],
            ),
            Gap(16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.borderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFE3F4FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subCategory,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(16),
            Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.icKonten.path,
                  width: 20,
                  height: 20,
                  color: AppColor.textGrayColor,
                ),
                Gap(8),
                Text(
                  // Prioritas: updatedAt dulu, kalau null pakai createdAt
                  konten.updatedAt != null
                      ? '${konten.updatedAt!.day}-${konten.updatedAt!.month}-${konten.updatedAt!.year} (Diperbarui)'
                      : konten.createdAt != null
                          ? '${konten.createdAt!.day}-${konten.createdAt!.month}-${konten.createdAt!.year}'
                          : 'Tanggal tidak tersedia',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.textGrayColor,
                  ),
                ),
                Spacer(),
                Button.outlined(
                  onPressed: () => context.pushNamed(RouteName.detailKonten,
                      extra: konten.id),
                  width: 120,
                  label: "Lihat Detail",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
