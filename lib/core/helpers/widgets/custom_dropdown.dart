import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';

class CustomDropdown extends StatefulWidget {
  final List<String>? items; // 🔹 Masih bisa pakai List<String> lama
  final List<Map<String, String>>? itemsWithValue; // 🔹 Untuk value–label pair
  final String? title;
  final String? selectedValue;
  final Function(String)? onChanged;
  final bool? isRequired;
  final bool disabled;

  const CustomDropdown({
    super.key,
    this.items,
    this.itemsWithValue,
    required this.title,
    this.selectedValue,
    this.onChanged,
    this.isRequired = false,
    this.disabled = false,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      setState(() {
        _selected = widget.selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan sumber item (pakai itemsWithValue jika ada)
    final useValueLabel = widget.itemsWithValue != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isRequired == true && widget.title != null)
          RichText(
            text: TextSpan(
              text: '${widget.title} ',
              style: UiTypography.label,
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: UiPalette.red600),
                ),
              ],
            ),
          )
        else if (widget.title != null)
          Text(
            widget.title!,
            style: UiTypography.label,
          ),
        const SizedBox(height: UiSpacing.xs),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'Pilih',
              style: UiTypography.body.copyWith(color: UiPalette.slate400),
            ),
            items: useValueLabel
                ? widget.itemsWithValue!
                    .map((item) => DropdownMenuItem(
                          value: item['value'],
                          child: Text(
                            item['label'] ?? '',
                            style: UiTypography.body.copyWith(
                              color: UiPalette.slate900,
                            ),
                          ),
                        ))
                    .toList()
                : widget.items!
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: UiTypography.body.copyWith(
                              color: UiPalette.slate900,
                            ),
                          ),
                        ))
                    .toList(),
            value: _selected,
            onChanged: widget.disabled
                ? null
                : (value) {
                    setState(() {
                      _selected = value;
                    });
                    if (value != null) {
                      widget.onChanged?.call(value);
                    }
                  },
            buttonStyleData: ButtonStyleData(
              height: 52,
              padding: const EdgeInsets.only(right: UiSpacing.sm),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: UiPalette.slate300,
                  width: 1,
                ),
                color: widget.disabled ? UiPalette.slate100 : UiPalette.white,
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 24,
              iconEnabledColor: UiPalette.slate400,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: UiPalette.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(10),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: UiSpacing.sm),
            ),
          ),
        ),
      ],
    );
  }
}
