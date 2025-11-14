import 'package:aconsia_app/core/helpers/validators.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  String? labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final bool? isLink;
  final bool? isCalendar;
  final bool? isTime;
  final bool? isLocation;
  final bool? isDisabled;
  final bool? isRequired;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  // 🔥 new
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  CustomTextField({
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
    this.isTime = false,
    this.isDisabled = false,
    this.isLocation = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.onTapIcon,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
    // 🔥 new
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with WidgetsBindingObserver {
  final FocusNode inputFocusNode = FocusNode();
  String? errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    inputFocusNode.unfocus();
    inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final v = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      widget.controller.text = v;
      // panggil callback agar state eksternal ikut tersinkron
      widget.onChanged?.call(v);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final v = '${pickedTime.hour}:${pickedTime.minute}';
      widget.controller.text = v;
      // panggil callback agar state eksternal ikut tersinkron
      widget.onChanged?.call(v);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isRequired == true && widget.labelText != null)
          RichText(
            text: TextSpan(
              text: '${widget.labelText} ',
              style: textTheme.titleMedium?.copyWith(
                color: AppColor.primaryBlack,
                fontSize: deviceWidth > 600 ? 16 : 14,
              ),
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColor.primaryBlack),
                ),
              ],
            ),
          )
        else if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: textTheme.titleMedium?.copyWith(
              fontSize: deviceWidth > 600 ? 16 : 14,
            ),
          ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: inputFocusNode,
          controller: widget.controller,
          obscureText: widget.obscureText,
          validator: widget.validator ??
              (value) {
                return Validators.validateRequired(
                    value, widget.labelText ?? '');
              },
          readOnly: widget.isCalendar == true ||
              widget.isDisabled == true ||
              widget.isLocation == true ||
              widget.isTime == true,
          onTap: widget.isLocation == true
              ? widget.onTap
              : widget.isDisabled == true
                  ? null
                  : widget.isCalendar == true
                      ? () => _selectDate(context)
                      : widget.isTime == true
                          ? () => _selectTime(context)
                          : widget.onTap,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style: textTheme.bodyLarge?.copyWith(
            color: widget.labelText == 'Koordinat GPS Lahan'
                ? AppColor.primaryColor
                : AppColor.primaryBlack,
          ),
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            filled: widget.isDisabled == true,
            errorMaxLines: 2, // Allow error text to wrap across multiple lines
            fillColor: Colors.white,
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
              borderSide: BorderSide(
                color: const Color(0xFFB0B0B0),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.primaryRed,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.textGrayColor,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: widget.suffixIcon,
          ),
          textCapitalization: TextCapitalization.sentences,

          // 🔥 new
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
        ),
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
