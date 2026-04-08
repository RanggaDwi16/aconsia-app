import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienPersonalInformationWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController namaController;
  final TextEditingController noRekamMedisController;
  final TextEditingController nikController;
  final TextEditingController tanggalLahirController;
  final TextEditingController jenisKelaminController;
  final TextEditingController agamaController;
  final TextEditingController statusPernikahanController;
  final TextEditingController pendidikanTerakhirController;
  final TextEditingController pekerjaanController;

  const PasienPersonalInformationWidget({
    super.key,
    this.isEditable = false,
    required this.namaController,
    required this.noRekamMedisController,
    required this.nikController,
    required this.tanggalLahirController,
    required this.jenisKelaminController,
    required this.agamaController,
    required this.statusPernikahanController,
    required this.pendidikanTerakhirController,
    required this.pekerjaanController,
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
            iconPath: Assets.icons.icPerson.path,
            title: 'Informasi Pribadi',
            subtitle: 'Data identitas pasien',
          ),
          const Gap(UiSpacing.lg),
          CustomTextField(
            controller: namaController,
            hintText: 'Nama Lengkap',
            labelText: 'Nama Lengkap',
            isDisabled: !editable,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: noRekamMedisController,
            hintText: 'Nomor Rekam Medis',
            labelText: 'Nomor Rekam Medis',
            isDisabled: !editable,
            inputFormatters: [LengthLimitingTextInputFormatter(13)],
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: nikController,
            hintText: 'NIK',
            labelText: 'NIK',
            isDisabled: !editable,
            keyboardType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(16)],
          ),
          const Gap(UiSpacing.md),
          pairFields(
            left: CustomTextField(
              controller: tanggalLahirController,
              hintText: 'Tanggal Lahir',
              labelText: 'Tanggal Lahir',
              isDisabled: !editable,
              suffixIcon: const Icon(Icons.calendar_month_outlined),
              isCalendar: true,
            ),
            right: CustomDropdown(
              title: 'Jenis Kelamin',
              items: const ['Laki-laki', 'Perempuan'],
              selectedValue: jenisKelaminController.text.isEmpty
                  ? null
                  : jenisKelaminController.text,
              onChanged: (selected) {
                jenisKelaminController.text = selected;
              },
              disabled: !editable,
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            left: CustomDropdown(
              title: 'Agama',
              items: const [
                'Islam',
                'Kristen',
                'Katolik',
                'Hindu',
                'Buddha',
                'Konghucu',
                'Lainnya',
              ],
              selectedValue:
                  agamaController.text.isEmpty ? null : agamaController.text,
              onChanged: (selected) {
                agamaController.text = selected;
              },
              disabled: !editable,
            ),
            right: CustomDropdown(
              title: 'Status Pernikahan',
              items: const [
                'Belum Menikah',
                'Menikah',
                'Cerai Hidup',
                'Cerai Mati',
              ],
              selectedValue: statusPernikahanController.text.isEmpty
                  ? null
                  : statusPernikahanController.text,
              onChanged: (selected) {
                statusPernikahanController.text = selected;
              },
              disabled: !editable,
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            left: CustomTextField(
              controller: pendidikanTerakhirController,
              hintText: 'SD, SMP, SMA, S1, dll',
              labelText: 'Pendidikan Terakhir',
              isDisabled: !editable,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
            ),
            right: CustomTextField(
              controller: pekerjaanController,
              hintText: 'Pegawai, Wiraswasta, dll',
              labelText: 'Pekerjaan',
              isDisabled: !editable,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
