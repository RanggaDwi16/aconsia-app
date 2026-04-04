import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';

enum ButtonStyle { filled, outlined }

class Button extends StatelessWidget {
  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isPay = false,
    this.style = ButtonStyle.filled,
    this.color = UiPalette.blue600,
    this.textColor = UiPalette.white,
    this.width = double.infinity,
    this.height = 48,
    this.borderColor = UiPalette.blue600,
    this.borderRadius = 12,
    this.disabled = false,
    this.isActive = false,
    this.fontSize = 15,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
  });

  const Button.outlined({
    super.key,
    required this.onPressed,
    this.label = "",
    this.icon,
    this.style = ButtonStyle.outlined,
    this.color = Colors.transparent,
    this.textColor = UiPalette.blue600,
    this.width = double.infinity,
    this.height = 48,
    this.borderRadius = 12,
    this.borderColor = UiPalette.blue600,
    this.disabled = false,
    this.isPay = false,
    this.isActive = false,
    this.fontSize = 15,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  final Function() onPressed;
  final String label;
  final Widget? icon;
  final ButtonStyle style;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final double width;
  final double height;
  final double borderRadius;
  final bool disabled;
  final bool isActive;
  final bool isPay;
  final double fontSize;
  final double elevation;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: style == ButtonStyle.filled
          ? ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                padding: padding,
                elevation: elevation,
                shape: isPay
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
              ).copyWith(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return UiPalette.slate400;
                    }
                    return color;
                  },
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) const SizedBox(width: 5.0),
                  Text(
                    label,
                    style: UiTypography.button.copyWith(
                      color: disabled ? UiPalette.white : textColor,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                padding: padding,
                elevation: elevation,
                backgroundColor: color,
                foregroundColor: textColor,
                side: BorderSide(color: borderColor, width: 1.5),
                shape: isPay
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(borderRadius),
                          bottomRight: Radius.circular(borderRadius),
                        ),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: UiTypography.button.copyWith(
                      color: disabled ? UiPalette.slate500 : textColor,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
