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
                'Wali / Pendamping',
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
            'Informasi wali atau pendamping pasien',
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
          ),
          Gap(16),
          CustomTextField(
            controller: hubunganController,
            hintText: 'Hubungan',
            labelText: 'Hubungan',
            isDisabled: isEditable == true ? false : true,
          ),
          Gap(16),
          CustomTextField(
            controller: nomorHpController,
            hintText: 'Nomor Telepon Wali',
            labelText: 'Nomor Telepon Wali',
            isDisabled: isEditable == true ? false : true,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          Gap(16),
          CustomTextField(
            controller: alamatController,
            hintText: 'Alamat Wali',
            labelText: 'Alamat Wali',
            isDisabled: isEditable == true ? false : true,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
