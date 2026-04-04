import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AconsiaScreenShell extends StatelessWidget {
  const AconsiaScreenShell({
    super.key,
    required this.child,
    this.top,
    this.padding = const EdgeInsets.all(UiSpacing.md),
    this.colors = const [UiPalette.blue50, UiPalette.white],
  });

  final Widget child;
  final Widget? top;
  final EdgeInsetsGeometry padding;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AconsiaPageBackground(
        colors: colors,
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (top != null) ...[
                top!,
                const Gap(UiSpacing.md),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class AconsiaTopActionRow extends StatelessWidget {
  const AconsiaTopActionRow({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBack != null)
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: UiPalette.slate600,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        if (onBack != null) const Gap(UiSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: UiTypography.h1.copyWith(height: 1.2),
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                const Gap(UiSpacing.xxs),
                Text(
                  subtitle!,
                  style: UiTypography.body.copyWith(color: UiPalette.slate500),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const Gap(UiSpacing.sm),
          trailing!,
        ],
      ],
    );
  }
}
