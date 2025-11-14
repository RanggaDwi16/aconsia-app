import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DoctorProfesionalInformationWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController spesialisasiController;
  final TextEditingController nomorstrController;
  final TextEditingController nomorsipController;
  final TextEditingController tanggalGabungController;
  const DoctorProfesionalInformationWidget({
    super.key,
    required this.spesialisasiController,
    required this.nomorstrController,
    required this.nomorsipController,
    required this.tanggalGabungController,
    this.isEditable = false,
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
              SvgPicture.asset(Assets.icons.icDoctor.path),
              Gap(12),
              Text(
                'Informasi Profesional',
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
            'Kredensial dan spesialisasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.textGrayColor,
            ),
          ),
          Gap(24),
          CustomTextField(
            controller: spesialisasiController,
            hintText: 'Spesialisasi',
            labelText: 'Spesialisasi',
            isDisabled: true,
          ),
          Gap(16),
          Row(
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
              Gap(12),
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
          ),
          Gap(16),
          CustomTextField(
            controller: tanggalGabungController,
            hintText: 'Tanggal Bergabung',
            labelText: 'Tanggal Bergabung',
            isCalendar: true,
            suffixIcon: Icon(
              Icons.calendar_month,
              color: AppColor.primaryColor,
            ),
            isDisabled: isEditable == true ? false : true,
          ),
        ],
      ),
    );
  }
}
