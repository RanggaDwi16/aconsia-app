// A custom text field widget for authentication forms with various features.

import 'package:flutter/material.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';

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
    final textTheme = Theme.of(context).textTheme;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.isRequired == true && widget.labelText != null)
          RichText(
            text: TextSpan(
              text: '${widget.labelText} ',
              style: textTheme.titleMedium?.copyWith(
                color: AppColor.primaryBlack,
                fontSize: deviceWidth > 600 ? 16 : 14, // Responsive font size
              ),
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          )
        else if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: textTheme.titleMedium?.copyWith(
              fontSize: deviceWidth > 600 ? 16 : 14, // Responsive font size
            ),
          ),

        const SizedBox(height: 8),

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
          style: textTheme.bodyLarge?.copyWith(color: AppColor.primaryBlack),
          maxLines: widget.maxLines, // Allow multiple lines for address field
          decoration: InputDecoration(
            labelText: widget.labelText, // Menambahkan label untuk TextField
            hintText: widget.hintText,
            hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFB0B0B0), // Light grey border
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.primaryColor, // Primary color when focused
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFB0B0B0)),
              borderRadius: BorderRadius.circular(5),
            ),
            suffixIcon: widget.suffixIcon,
          ),
        ),

        // Display Error Text
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorText!,
              style: textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
