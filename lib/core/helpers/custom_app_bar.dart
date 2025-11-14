import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  List<Widget> actions;
  final Widget? customTitleWidget;
  Widget? leading;
  Color backgroundColor;
  Color textColor;
  IconThemeData iconTheme;

  PreferredSizeWidget? bottom;
  bool? centertitle;
  bool showBackButton;

  CustomAppBar({
    super.key,
    this.leading,
    this.title = "",
    this.customTitleWidget,
    this.centertitle = false,
    this.actions = const [],
    this.textColor = AppColor.primaryBlack,
    this.backgroundColor = AppColor.primaryWhite,
    this.iconTheme = const IconThemeData(color: Colors.black),
    this.bottom,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ??
          (showBackButton && Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              : null),
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor,
      centerTitle: centertitle,
      iconTheme: iconTheme,
      title: customTitleWidget ??
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: Colors.white,
                child: bottom,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      bottom == null ? const Size.fromHeight(56) : const Size.fromHeight(100);
}
