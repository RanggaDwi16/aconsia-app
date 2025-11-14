import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/detail_konten_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class KontenPasienWidget extends StatelessWidget {
  final bool isRekomendasi;
  final String? jenisAnestesi;
  final String? jenisOperasi;
  final double? skorPemahamanAI;
  final bool isSelesai;

  const KontenPasienWidget({
    super.key,
    this.isRekomendasi = false,
    this.jenisAnestesi,
    this.jenisOperasi,
    this.skorPemahamanAI,
    this.isSelesai = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.deviceWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Persiapan Anestesi Regional',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(8),
          Text(
            'Pelajari cara-cara efektif untuk mengelola stres di lingkungan kerja Anda dan meningkatkan kesejahteraan mental Anda.',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.textGrayColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(16),
          DetailKontenWidget(
            isRekomendasi: isRekomendasi,
            jenisAnestesi: jenisAnestesi,
            jenisOperasi: jenisOperasi,
            skorPemahamanAI: skorPemahamanAI,
            isSelesai: isSelesai,
          ),
          Gap(16),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (skorPemahamanAI != null && isSelesai) {
      return Button.outlined(
        onPressed: () => context.pushNamed(RouteName.detailKonten),
        label: 'Review',
      );
    }

    return Button.filled(
      onPressed: () => context.pushNamed(RouteName.detailKonten),
      label: 'Mulai',
    );
  }
}
