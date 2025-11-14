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
                Assets.icons.icHeart.path,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColor.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              Gap(12),
              Text(
                'Informasi Pribadi Medis',
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
            'Data prosedur medis',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.textGrayColor,
            ),
          ),
          Gap(24),
          if (isDokterInput == true) ...[
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: jenisOperasiController,
                    hintText: 'Jenis Operasi',
                    labelText: 'Jenis Operasi',
                    isDisabled: isEditable == true ? false : true,
                  ),
                ),
                Gap(12),
                Expanded(
                  child: CustomTextField(
                    controller: jenisAnestesiController,
                    hintText: 'Jenis Anestesi',
                    labelText: 'Jenis Anestesi',
                    isDisabled: isEditable == true ? false : true,
                  ),
                ),
              ],
            ),
            Gap(16),
            CustomTextField(
              controller: klasifikasiasaController,
              hintText: 'Klasifikasi ASA',
              labelText: 'Klasifikasi ASA',
              isDisabled: isEditable == true ? false : true,
            ),
            Gap(16),
          ],
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: tinggiBadanController,
                  hintText: 'Tinggi Badan (cm)',
                  labelText: 'Tinggi Badan (cm)',
                  isDisabled: isEditable == true ? false : true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ),
              Gap(12),
              Expanded(
                child: CustomTextField(
                  controller: beratBadanController,
                  hintText: 'Berat Badan (kg)',
                  labelText: 'Berat Badan (kg)',
                  isDisabled: isEditable == true ? false : true,
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
