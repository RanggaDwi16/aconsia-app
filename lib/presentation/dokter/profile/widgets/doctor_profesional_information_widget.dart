import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/services.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DoctorProfesionalInformationWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController spesialisasiController;
  final TextEditingController nomorstrController;
  final TextEditingController nomorsipController;
  final TextEditingController hospitalNameController;
  final TextEditingController tanggalGabungController;
  const DoctorProfesionalInformationWidget({
    super.key,
    required this.spesialisasiController,
    required this.nomorstrController,
    required this.nomorsipController,
    required this.hospitalNameController,
    required this.tanggalGabungController,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.md,
        vertical: UiSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: UiPalette.white,
        border: Border.all(color: UiPalette.slate200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    Assets.icons.icDoctor.path,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      UiPalette.blue600,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const Gap(UiSpacing.sm),
              const Text(
                'Informasi Profesional',
                style: UiTypography.title,
              ),
            ],
          ),
          const Gap(UiSpacing.xxs),
          const Text(
            'Kredensial dan spesialisasi',
            style: UiTypography.caption,
          ),
          const Gap(UiSpacing.lg),
          CustomTextField(
            controller: spesialisasiController,
            hintText: 'Spesialisasi',
            labelText: 'Spesialisasi',
            isDisabled: isEditable == true ? false : true,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: hospitalNameController,
            hintText: 'Rumah Sakit',
            labelText: 'Rumah Sakit',
            isDisabled: isEditable == true ? false : true,
          ),
          const Gap(UiSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              if (isNarrow) {
                return Column(
                  children: [
                    CustomTextField(
                      controller: nomorstrController,
                      hintText: 'Nomor STR',
                      labelText: 'Nomor STR',
                      isDisabled: isEditable == true ? false : true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(14),
                      ],
                    ),
                    const Gap(UiSpacing.md),
                    CustomTextField(
                      controller: nomorsipController,
                      hintText: 'Nomor SIP',
                      labelText: 'Nomor SIP',
                      isDisabled: isEditable == true ? false : true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(14),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: nomorstrController,
                      hintText: 'Nomor STR',
                      labelText: 'Nomor STR',
                      isDisabled: isEditable == true ? false : true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(14),
                      ],
                    ),
                  ),
                  const Gap(UiSpacing.md),
                  Expanded(
                    child: CustomTextField(
                      controller: nomorsipController,
                      hintText: 'Nomor SIP',
                      labelText: 'Nomor SIP',
                      isDisabled: isEditable == true ? false : true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(14),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: tanggalGabungController,
            hintText: 'Tanggal Bergabung',
            labelText: 'Tanggal Bergabung',
            isCalendar: true,
            suffixIcon: const Icon(
              Icons.calendar_month,
              color: UiPalette.blue600,
              size: 20,
            ),
            isDisabled: true,
          ),
        ],
      ),
    );
  }
}
