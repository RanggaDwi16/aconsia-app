import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';

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
    final textTheme = Theme.of(context).textTheme;
    double deviceWidth = MediaQuery.of(context).size.width;

    // Tentukan sumber item (pakai itemsWithValue jika ada)
    final useValueLabel = widget.itemsWithValue != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isRequired == true && widget.title != null)
          RichText(
            text: TextSpan(
              text: '${widget.title} ',
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
        else if (widget.title != null)
          Text(
            widget.title!,
            style: textTheme.titleMedium?.copyWith(
              fontSize: deviceWidth > 600 ? 16 : 14,
              color: AppColor.primaryBlack,
            ),
          ),
        const SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'Pilih',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            items: useValueLabel
                ? widget.itemsWithValue!
                    .map((item) => DropdownMenuItem(
                          value: item['value'],
                          child: Text(
                            item['label'] ?? '',
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: 14,
                              color: AppColor.primaryBlack,
                            ),
                          ),
                        ))
                    .toList()
                : widget.items!
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: 14,
                              color: AppColor.primaryBlack,
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
              height: 48,
              padding: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFB0B0B0),
                  width: 1,
                ),
                color: AppColor.primaryWhite,
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 24,
              iconEnabledColor: Color(0xFFB0B0B0),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
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
              padding: EdgeInsets.symmetric(horizontal: 13),
            ),
          ),
        ),
      ],
    );
  }
}
