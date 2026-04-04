// A custom search field widget with an icon and hint text.

import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? color;
  final Function(String)? onChanged;

  const CustomSearchField({
    super.key,
    this.controller,
    this.color = UiPalette.white,
    this.hintText = 'Cari',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: UiPalette.slate300,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: UiPalette.slate500,
          ),
          const SizedBox(width: UiSpacing.xs),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: UiTypography.body.copyWith(color: UiPalette.slate900),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 1,
                  horizontal: 0,
                ),
                hintText: hintText,
                hintStyle:
                    UiTypography.body.copyWith(color: UiPalette.slate400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
