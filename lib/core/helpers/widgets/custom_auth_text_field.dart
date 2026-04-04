// A custom text field widget for authentication forms with various features.

import 'package:flutter/material.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';

class CustomAuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final bool? isLink;
  final bool? isCalendar;
  final bool? isDisabled;
  final bool? isRequired;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapIcon;
  final TextInputType? keyboardType;
  final int? maxLines; // To allow multiline input for Address

  const CustomAuthTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.obscureText = false,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.isRequired = false,
    this.isLink = false,
    this.isCalendar = false,
    this.isDisabled = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.onTapIcon,
    this.maxLines = 1, // Default to 1 line, adjustable for Address
  });

  @override
  State<CustomAuthTextField> createState() => _CustomAuthTextFieldState();
}

class _CustomAuthTextFieldState extends State<CustomAuthTextField> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    if (widget.isLink == true) {
      widget.controller.addListener(() {
        final text = widget.controller.text;
        setState(() {
          errorText = (text.isNotEmpty && !text.startsWith('https://'))
              ? 'Input link harus diawali dengan https://'
              : null;
        });
      });
    }
  }

  // Method to show date picker for Tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      widget.controller.text =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.isRequired == true && widget.labelText != null)
          RichText(
            text: TextSpan(
              text: '${widget.labelText} ',
              style: UiTypography.label,
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: UiPalette.red600),
                ),
              ],
            ),
          )
        else if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: UiTypography.label,
          ),

        const SizedBox(height: UiSpacing.xs),

        // Input Field
        TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          readOnly: widget.isCalendar == true || widget.isDisabled == true,
          onTap: widget.isCalendar == true
              ? () =>
                  _selectDate(context) // Open date picker if it's a date field
              : widget.onTap,
          keyboardType: widget.keyboardType,
          style: UiTypography.body.copyWith(color: UiPalette.slate900),
          maxLines: widget.maxLines, // Allow multiple lines for address field
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.isDisabled == true
                ? UiPalette.slate100
                : UiPalette.white,
            hintStyle: UiTypography.body.copyWith(color: UiPalette.slate400),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: UiSpacing.md, right: UiSpacing.xs),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding: const EdgeInsets.symmetric(
                vertical: UiSpacing.md, horizontal: UiSpacing.md),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: UiPalette.slate300, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: UiPalette.blue600, width: 1.6),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: UiPalette.red600),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: UiPalette.red600, width: 1.6),
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: UiPalette.slate300),
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: widget.suffixIcon,
          ),
        ),

        // Display Error Text
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: UiSpacing.xs),
            child: Text(
              errorText!,
              style: UiTypography.caption.copyWith(color: UiPalette.red600),
            ),
          ),
      ],
    );
  }
}
