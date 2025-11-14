import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ListPasienWidget extends StatelessWidget {
  final PasienProfileModel pasien;
  const ListPasienWidget({
    required this.pasien,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        RouteName.detailPasien,
        extra: pasien.uid,
      ),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFD0EDFF),
                child: SvgPicture.asset(
                  Assets.icons.icPerson.path,
                  width: 24,
                  height: 24,
                  color: AppColor.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pasien.namaLengkap ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pasien.noRekamMedis ?? '-',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.textGrayColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C35D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    color: AppColor.primaryWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Gap(12),
          Divider(color: AppColor.borderColor)
        ],
      ),
    );
  }
}
