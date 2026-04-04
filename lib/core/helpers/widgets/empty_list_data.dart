// A widget that displays a styled message indicating an empty data list.

import 'package:flutter/material.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';

Widget emptyListData(BuildContext context) {
  return Container(
    width: context.deviceWidth,
    height: context.deviceHeight * 0.2,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Kotak hijau di belakang
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: UiPalette.blue50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Icon(
                    Icons.hourglass_empty_outlined,
                    size: 40,
                    color: UiPalette.slate500,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Belum ada data',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    ),
  );
}
