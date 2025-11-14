import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class DashboardSummaryWidget extends StatelessWidget {
  final String title;
  final String count;
  final VoidCallback? onPressed;
  final String iconPath;
  const DashboardSummaryWidget({
    super.key,
    required this.title,
    required this.count,
    this.onPressed,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.deviceWidth,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                SvgPicture.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
            Gap(8),
            Text(
              count,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            Gap(16),
            Button.outlined(
              onPressed: () => onPressed?.call(),
              label: 'Lihat Detail',
            )
          ],
        ),
      ),
    );
  }
}
