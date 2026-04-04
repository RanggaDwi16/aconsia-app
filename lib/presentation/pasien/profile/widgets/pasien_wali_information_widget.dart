import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienWaliInformationWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController namaController;
  final TextEditingController hubunganController;
  final TextEditingController nomorHpController;
  final TextEditingController alamatController;

  const PasienWaliInformationWidget({
    super.key,
    this.isEditable = false,
    required this.namaController,
    required this.hubunganController,
    required this.nomorHpController,
    required this.alamatController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editable = isEditable ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.md,
        vertical: UiSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: UiPalette.white,
        border: Border.all(color: UiPalette.slate200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            iconPath: Assets.icons.icPerson.path,
            title: 'Wali / Pendamping',
            subtitle: 'Informasi pendamping utama pasien',
          ),
          const Gap(UiSpacing.lg),
          CustomTextField(
            controller: namaController,
            hintText: 'Nama Lengkap',
            labelText: 'Nama Lengkap',
            isDisabled: !editable,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: hubunganController,
            hintText: 'Hubungan',
            labelText: 'Hubungan',
            isDisabled: !editable,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: nomorHpController,
            hintText: 'Nomor Telepon Wali',
            labelText: 'Nomor Telepon Wali',
            isDisabled: !editable,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: alamatController,
            hintText: 'Alamat Wali',
            labelText: 'Alamat Wali',
            isDisabled: !editable,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.iconPath,
    required this.title,
    required this.subtitle,
  });

  final String iconPath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: UiPalette.blue50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(UiPalette.blue600, BlendMode.srcIn),
            ),
          ),
        ),
        const Gap(UiSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: UiPalette.slate900,
                ),
              ),
              const Gap(UiSpacing.xxs),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: UiPalette.slate500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
