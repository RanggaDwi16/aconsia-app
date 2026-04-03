import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5FAFF),
            Color(0xFFFFFFFF),
          ],
        ),
        border: Border.all(color: const Color(0xFFDDE7F3)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColor.textGrayColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SvgPicture.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
            Gap(8),
            Text(
              count,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F2742),
              ),
            ),
            Gap(10),
            Button.outlined(
              onPressed: () => onPressed?.call(),
              label: 'Buka',
            )
          ],
        ),
      ),
    );
  }
}
