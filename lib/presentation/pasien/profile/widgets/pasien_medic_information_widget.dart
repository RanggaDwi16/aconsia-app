import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienMedicInformationWidget extends HookConsumerWidget {
  final bool? isEditable;
  final bool? isDokterInput;
  final TextEditingController jenisOperasiController;
  final TextEditingController jenisAnestesiController;
  final TextEditingController klasifikasiasaController;
  final TextEditingController tinggiBadanController;
  final TextEditingController beratBadanController;

  const PasienMedicInformationWidget({
    super.key,
    this.isEditable = false,
    this.isDokterInput = false,
    required this.jenisOperasiController,
    required this.jenisAnestesiController,
    required this.klasifikasiasaController,
    required this.tinggiBadanController,
    required this.beratBadanController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editable = isEditable ?? false;
    final dokterInput = isDokterInput ?? false;

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
            iconPath: Assets.icons.icHeart.path,
            title: 'Informasi Medis',
            subtitle: 'Data prosedur dan parameter medis pasien',
          ),
          const Gap(UiSpacing.lg),
          if (dokterInput) ...[
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: jenisOperasiController,
                    hintText: 'Jenis Operasi',
                    labelText: 'Jenis Operasi',
                    isDisabled: !editable,
                  ),
                ),
                const Gap(UiSpacing.md),
                Expanded(
                  child: CustomTextField(
                    controller: jenisAnestesiController,
                    hintText: 'Jenis Anestesi',
                    labelText: 'Jenis Anestesi',
                    isDisabled: !editable,
                  ),
                ),
              ],
            ),
            const Gap(UiSpacing.md),
            CustomTextField(
              controller: klasifikasiasaController,
              hintText: 'Klasifikasi ASA',
              labelText: 'Klasifikasi ASA',
              isDisabled: !editable,
            ),
            const Gap(UiSpacing.md),
          ],
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: tinggiBadanController,
                  hintText: 'Tinggi Badan (cm)',
                  labelText: 'Tinggi Badan (cm)',
                  isDisabled: !editable,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ),
              const Gap(UiSpacing.md),
              Expanded(
                child: CustomTextField(
                  controller: beratBadanController,
                  hintText: 'Berat Badan (kg)',
                  labelText: 'Berat Badan (kg)',
                  isDisabled: !editable,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ),
            ],
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
