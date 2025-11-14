import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienPersonalInformationWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController namaController;
  final TextEditingController noRekamMedisController;
  final TextEditingController nikController;
  final TextEditingController tanggalLahirController;
  final TextEditingController jenisKelaminController;
  const PasienPersonalInformationWidget({
    super.key,
    this.isEditable = false,
    required this.namaController,
    required this.noRekamMedisController,
    required this.nikController,
    required this.tanggalLahirController,
    required this.jenisKelaminController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.icPerson.path,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColor.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              Gap(12),
              Text(
                'Informasi Pribadi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              SvgPicture.asset(
                Assets.icons.icEdit.path,
                width: 20,
                height: 20,
              )
            ],
          ),
          Gap(4),
          Text(
            'Data identitas pasien',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.textGrayColor,
            ),
          ),
          Gap(24),
          CustomTextField(
            controller: namaController,
            hintText: 'Nama Lengkap',
            labelText: 'Nama Lengkap',
            isDisabled: isEditable == true ? false : true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
            ],
          ),
          Gap(16),
          CustomTextField(
            controller: noRekamMedisController,
            hintText: 'Nomor Rekam Medis',
            labelText: 'Nomor Rekam Medis',
            isDisabled: isEditable == true ? false : true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(13),
            ],
          ),
          Gap(16),
          CustomTextField(
            controller: nikController,
            hintText: 'NIK',
            labelText: 'NIK',
            isDisabled: isEditable == true ? false : true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(16),
            ],
          ),
          Gap(16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: tanggalLahirController,
                  hintText: 'Tanggal Lahir',
                  labelText: 'Tanggal Lahir',
                  isDisabled: isEditable == true ? false : true,
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                  isCalendar: true,
                ),
              ),
              Gap(12),
              Expanded(
                child: CustomDropdown(
                  title: 'Jenis Kelamin',
                  items: [
                    'Laki-laki',
                    'Perempuan',
                  ],
                  selectedValue: jenisKelaminController.text.isEmpty
                      ? null
                      : jenisKelaminController.text,
                  onChanged: (selected) {
                    jenisKelaminController.text = selected;
                  },
                  disabled: !(isEditable ?? false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
