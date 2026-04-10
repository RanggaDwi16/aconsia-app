import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ListPasienWidget extends StatelessWidget {
  final PasienProfileModel pasien;

  const ListPasienWidget({
    required this.pasien,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final reviewStatus = _resolveReviewStatus(pasien);
    final statusText = switch (reviewStatus) {
      'pending' => 'Menunggu Review',
      'rejected' => 'Ditolak',
      'ready' => 'Siap Edukasi',
      'in_progress' => 'Proses Edukasi',
      _ => 'Sudah Disetujui',
    };
    final statusColor = switch (reviewStatus) {
      'pending' => const Color(0xFFF59E0B),
      'rejected' => UiPalette.red600,
      'ready' => const Color(0xFF16A34A),
      'in_progress' => UiPalette.blue600,
      _ => const Color(0xFF22C35D),
    };
    final pasienUid = (pasien.uid ?? '').trim();

    return InkWell(
      onTap: pasienUid.isEmpty
          ? null
          : () => context.pushNamed(
                RouteName.detailPasien,
                extra: pasienUid,
              ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(UiSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3EAF4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 360;

            final identity = Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pasien.namaLengkap ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Text(
                    pasien.noRekamMedis?.isNotEmpty == true
                        ? 'No RM: ${pasien.noRekamMedis}'
                        : 'No RM belum diisi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: UiPalette.slate500,
                    ),
                  ),
                ],
              ),
            );

            final status = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: UiPalette.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Gap(UiSpacing.sm),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8FA0B8),
                ),
              ],
            );

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFD0EDFF),
                  child: SvgPicture.asset(
                    Assets.icons.icPerson.path,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      UiPalette.blue600,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Gap(UiSpacing.md),
                identity,
                const Gap(UiSpacing.sm),
                if (isNarrow)
                  Flexible(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: status,
                    ),
                  )
                else
                  status,
              ],
            );
          },
        ),
      ),
    );
  }

  String _resolveReviewStatus(PasienProfileModel pasien) {
    final preOp = pasien.preOperativeAssessment ?? const <String, dynamic>{};
    final rawStatus = (preOp['status'] as String? ?? '').trim().toLowerCase();
    if (rawStatus == 'pending' ||
        rawStatus == 'approved' ||
        rawStatus == 'in_progress' ||
        rawStatus == 'ready' ||
        rawStatus == 'completed' ||
        rawStatus == 'rejected') {
      return rawStatus;
    }

    final operasi = (pasien.jenisOperasi ?? '').trim();
    final anestesi = (pasien.jenisAnestesi ?? '').trim();
    final asa = (pasien.klasifikasiAsa ?? '').trim();
    final isMedicalReady =
        operasi.isNotEmpty && anestesi.isNotEmpty && asa.isNotEmpty;
    return isMedicalReady ? 'approved' : 'pending';
  }
}
