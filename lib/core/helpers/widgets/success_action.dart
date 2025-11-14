// A widget that displays a success message with an optional icon and navigation.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';

class SuccessAction extends StatelessWidget {
  final String? iconPath;
  final String? title;
  final String? message;
  final String? nextRoute;
  const SuccessAction({
    super.key,
    this.iconPath,
    this.title,
    this.message,
    this.nextRoute,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        if (nextRoute != null) {
          context.goNamed(nextRoute!);
        } else {
          context.pop();
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(iconPath ?? ''),
                ),
                const Gap(32),
                Text(
                  title ?? 'Aksi Berhasil',
                  style: textTheme.headlineSmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                Text(
                  message ??
                      'Aksi yang Anda lakukan telah berhasil. Silakan lanjutkan ke langkah berikutnya.',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: Button.filled(
            onPressed: () {
              if (nextRoute != null) {
                context.goNamed(nextRoute!);
              } else {
                context.pop();
              }
            },
            label: 'Kembali',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
