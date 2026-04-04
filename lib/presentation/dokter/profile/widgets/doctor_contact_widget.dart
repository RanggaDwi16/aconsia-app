import 'package:flutter/services.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DoctorContactWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController emailController;
  final TextEditingController nomorHpController;

  const DoctorContactWidget({
    super.key,
    this.isEditable = false,
    required this.emailController,
    required this.nomorHpController,
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
                    Assets.icons.icCall.path,
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
                'Kontak',
                style: UiTypography.title,
              ),
            ],
          ),
          const Gap(UiSpacing.xxs),
          const Text(
            'Informasi Kontak',
            style: UiTypography.caption,
          ),
          const Gap(UiSpacing.lg),
          CustomTextField(
            controller: emailController,
            hintText: 'Email',
            labelText: 'Email',
            isDisabled: isEditable == true ? false : true,
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: nomorHpController,
            hintText: 'Nomor WhatsApp',
            labelText: 'Nomor WhatsApp',
            isDisabled: isEditable == true ? false : true,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
          ),
        ],
      ),
    );
  }
}
