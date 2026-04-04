import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
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
          colors: [UiPalette.blue50, UiPalette.white],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: AconsiaCardSurface(
        padding: const EdgeInsets.all(UiSpacing.lg),
        borderColor: const Color(0xFFDDE7F3),
        radius: 14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: UiTypography.body.copyWith(
                      color: UiPalette.slate500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SvgPicture.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(
                    UiPalette.blue600,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            const Gap(UiSpacing.sm),
            Text(
              count,
              style: UiTypography.h1.copyWith(
                color: UiPalette.slate900,
              ),
            ),
            const Gap(UiSpacing.md),
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
