import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienContactWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController alamatLengkapController;
  final TextEditingController rtController;
  final TextEditingController rwController;
  final TextEditingController kelurahanDesaController;
  final TextEditingController kecamatanController;
  final TextEditingController kotaKabupatenController;
  final TextEditingController provinsiController;

  const PasienContactWidget({
    super.key,
    this.isEditable = false,
    required this.emailController,
    required this.phoneController,
    required this.alamatLengkapController,
    required this.rtController,
    required this.rwController,
    required this.kelurahanDesaController,
    required this.kecamatanController,
    required this.kotaKabupatenController,
    required this.provinsiController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editable = isEditable ?? false;
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    Widget pairFields({required Widget left, required Widget right}) {
      if (isWide) {
        return Row(
          children: [
            Expanded(child: left),
            const Gap(UiSpacing.md),
            Expanded(child: right),
          ],
        );
      }
      return Column(
        children: [
          left,
          const Gap(UiSpacing.md),
          right,
        ],
      );
    }

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
            iconPath: Assets.icons.icCall.path,
            title: 'Kontak',
            subtitle: 'Informasi kontak pasien',
          ),
          const Gap(UiSpacing.lg),
          CustomTextField(
            controller: emailController,
            hintText: 'Email',
            labelText: 'Email',
            isDisabled: !editable,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: phoneController,
            hintText: 'Nomor WhatsApp',
            labelText: 'Nomor WhatsApp',
            isDisabled: !editable,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: alamatLengkapController,
            hintText: 'Jalan, nomor rumah',
            labelText: 'Alamat Lengkap',
            isDisabled: !editable,
            maxLines: 3,
          ),
          const Gap(UiSpacing.md),
          pairFields(
            left: CustomTextField(
              controller: rtController,
              hintText: '001',
              labelText: 'RT',
              isDisabled: !editable,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
            right: CustomTextField(
              controller: rwController,
              hintText: '002',
              labelText: 'RW',
              isDisabled: !editable,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            left: CustomTextField(
              controller: kelurahanDesaController,
              hintText: 'Kelurahan/Desa',
              labelText: 'Kelurahan/Desa',
              isDisabled: !editable,
            ),
            right: CustomTextField(
              controller: kecamatanController,
              hintText: 'Kecamatan',
              labelText: 'Kecamatan',
              isDisabled: !editable,
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            left: CustomTextField(
              controller: kotaKabupatenController,
              hintText: 'Kota/Kabupaten',
              labelText: 'Kota/Kabupaten',
              isDisabled: !editable,
            ),
            right: CustomTextField(
              controller: provinsiController,
              hintText: 'Provinsi',
              labelText: 'Provinsi',
              isDisabled: !editable,
            ),
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
