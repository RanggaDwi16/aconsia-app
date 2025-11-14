// A custom search field widget with an icon and hint text.

import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? color;
  final Function(String)? onChanged;

  const CustomSearchField({
    super.key,
    this.controller,
    this.color = AppColor.primaryWhite,
    this.hintText = 'Cari',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: AppColor.borderColor,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
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
                hintStyle: const TextStyle(color: AppColor.textGrayColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
