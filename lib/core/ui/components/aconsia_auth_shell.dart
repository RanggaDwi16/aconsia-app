import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AconsiaAuthCard extends StatelessWidget {
  const AconsiaAuthCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(UiSpacing.xl),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: UiPalette.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiPalette.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class AconsiaAuthBackButton extends StatelessWidget {
  const AconsiaAuthBackButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back, size: 20),
        label: const Text('Kembali'),
        style: TextButton.styleFrom(
          foregroundColor: UiPalette.slate500,
          padding: const EdgeInsets.symmetric(
            horizontal: UiSpacing.xs,
            vertical: UiSpacing.sm,
          ),
          minimumSize: const Size(0, 44),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class AconsiaAuthFooter extends StatelessWidget {
  const AconsiaAuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: UiPalette.slate200)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.xl,
        vertical: UiSpacing.xl,
      ),
      child: Column(
        children: [
          const Text(
            '© 2026 ACONSIA - Sistem Informasi untuk Edukasi Pasien',
            textAlign: TextAlign.center,
            style: UiTypography.caption,
          ),
          const Gap(UiSpacing.xs),
          Text(
            'Keamanan Data Pasien Terjamin',
            style: UiTypography.caption.copyWith(
              color: UiPalette.slate500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
