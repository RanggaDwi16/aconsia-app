import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AconsiaPageBackground extends StatelessWidget {
  const AconsiaPageBackground({
    super.key,
    required this.child,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.colors = const [UiPalette.blue50, UiPalette.white],
  });

  final Widget child;
  final Alignment begin;
  final Alignment end;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}

class AconsiaCardSurface extends StatelessWidget {
  const AconsiaCardSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor = UiPalette.slate200,
    this.radius = 12,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: UiPalette.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class AconsiaSectionTitle extends StatelessWidget {
  const AconsiaSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleSize = 20,
  });

  final String title;
  final String subtitle;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: UiTypography.h2.copyWith(
            fontSize: titleSize,
          ),
        ),
        const Gap(UiSpacing.sm),
        Text(
          subtitle,
          style: UiTypography.body.copyWith(color: UiPalette.slate500),
        ),
      ],
    );
  }
}

class AconsiaInfoBanner extends StatelessWidget {
  const AconsiaInfoBanner({
    super.key,
    required this.icon,
    required this.message,
    this.backgroundColor = UiPalette.blue50,
    this.borderColor = UiPalette.blue100,
    this.iconColor = UiPalette.blue600,
    this.textColor = UiPalette.slate700,
  });

  final IconData icon;
  final String message;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const Gap(UiSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: UiTypography.bodySmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
