import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColor.textColor,
      cardColor: Colors.white,
      scaffoldBackgroundColor: AppColor.primaryWhite,
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor,
        surface: AppColor.backgroundColor,
      ),
      // fontFamily: 'Poppins',
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(
          color: AppColor.textColor,
        ),
        titleTextStyle: TextStyle(
          color: AppColor.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColor.textColor),
        trackColor:
            WidgetStateProperty.all(AppColor.textColor.withOpacity(0.16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIconColor: AppColor.primaryBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppColor.primaryBlack,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColor.textColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppColor.primaryBlack,
          ),
        ),
      ),
      primaryTextTheme: TextTheme(
        displayLarge: UiTypography.display.copyWith(color: Colors.white),
        displayMedium: UiTypography.h1.copyWith(color: Colors.white),
        displaySmall: UiTypography.h2.copyWith(color: Colors.white),
        headlineLarge: UiTypography.h2.copyWith(color: Colors.white),
        headlineMedium: UiTypography.title.copyWith(color: Colors.white),
        headlineSmall: UiTypography.title.copyWith(color: Colors.white),
        titleLarge: UiTypography.label.copyWith(color: Colors.white),
        titleMedium: UiTypography.body.copyWith(color: Colors.white),
        titleSmall: UiTypography.caption.copyWith(color: Colors.white),
        bodyLarge: UiTypography.body.copyWith(color: Colors.white),
        bodyMedium: UiTypography.bodySmall.copyWith(color: Colors.white),
        bodySmall: UiTypography.caption.copyWith(color: Colors.white),
        labelLarge: UiTypography.button.copyWith(color: Colors.white),
        labelMedium: UiTypography.caption.copyWith(color: Colors.white),
        labelSmall: UiTypography.caption.copyWith(color: Colors.white),
      ),
      textTheme: TextTheme(
        displayLarge:
            UiTypography.display.copyWith(color: AppColor.primaryBlack),
        displayMedium: UiTypography.h1.copyWith(color: AppColor.primaryBlack),
        displaySmall: UiTypography.h2.copyWith(color: AppColor.primaryBlack),
        headlineLarge: UiTypography.h2.copyWith(color: AppColor.primaryBlack),
        headlineMedium:
            UiTypography.title.copyWith(color: AppColor.primaryBlack),
        headlineSmall:
            UiTypography.title.copyWith(color: AppColor.primaryBlack),
        titleLarge: UiTypography.label.copyWith(color: AppColor.primaryBlack),
        titleMedium: UiTypography.body.copyWith(color: AppColor.primaryBlack),
        titleSmall: UiTypography.caption.copyWith(color: AppColor.primaryBlack),
        bodyLarge: UiTypography.body.copyWith(color: AppColor.primaryBlack),
        bodyMedium:
            UiTypography.bodySmall.copyWith(color: AppColor.primaryBlack),
        bodySmall: UiTypography.caption.copyWith(color: AppColor.primaryBlack),
        labelLarge: UiTypography.button.copyWith(color: AppColor.primaryBlack),
        labelMedium:
            UiTypography.caption.copyWith(color: AppColor.primaryBlack),
        labelSmall: UiTypography.caption.copyWith(color: AppColor.primaryBlack),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.white),
          backgroundColor: WidgetStateProperty.all(AppColor.textColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ));

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: AppColor.textColor,
    cardColor: const Color(0xFF1F1F1F),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      color: AppColor.textColor,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: true,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.all(Colors.white.withOpacity(0.16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      suffixIconColor: Colors.white.withOpacity(0.16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.16),
        ),
      ),
      hintStyle: const TextStyle(
        color: Colors.white,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.16),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColor.textColor),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: AppColor.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    primaryTextTheme: TextTheme(
      displayLarge: UiTypography.display.copyWith(color: AppColor.textColor),
      displayMedium: UiTypography.h1.copyWith(color: AppColor.textColor),
      displaySmall: UiTypography.h2.copyWith(color: AppColor.textColor),
      headlineLarge: UiTypography.h2.copyWith(color: AppColor.textColor),
      headlineMedium: UiTypography.title.copyWith(color: AppColor.textColor),
      headlineSmall: UiTypography.title.copyWith(color: AppColor.textColor),
      titleLarge: UiTypography.label.copyWith(color: AppColor.textColor),
      titleMedium: UiTypography.body.copyWith(color: AppColor.textColor),
      titleSmall: UiTypography.caption.copyWith(color: AppColor.textColor),
      bodyLarge: UiTypography.body.copyWith(color: AppColor.textColor),
      bodyMedium: UiTypography.bodySmall.copyWith(color: AppColor.textColor),
      bodySmall: UiTypography.caption.copyWith(color: AppColor.textColor),
      labelLarge: UiTypography.button.copyWith(color: AppColor.textColor),
      labelMedium: UiTypography.caption.copyWith(color: AppColor.textColor),
      labelSmall: UiTypography.caption.copyWith(color: AppColor.textColor),
    ),
    textTheme: TextTheme(
      displayLarge: UiTypography.display.copyWith(color: Colors.white),
      displayMedium: UiTypography.h1.copyWith(color: Colors.white),
      displaySmall: UiTypography.h2.copyWith(color: Colors.white),
      headlineLarge: UiTypography.h2.copyWith(color: Colors.white),
      headlineMedium: UiTypography.title.copyWith(color: Colors.white),
      headlineSmall: UiTypography.title.copyWith(color: Colors.white),
      titleLarge: UiTypography.label.copyWith(color: Colors.white),
      titleMedium: UiTypography.body.copyWith(color: Colors.white),
      titleSmall: UiTypography.caption.copyWith(color: Colors.white),
      bodyLarge: UiTypography.body.copyWith(color: Colors.white),
      bodyMedium: UiTypography.bodySmall.copyWith(color: Colors.white),
      bodySmall: UiTypography.caption.copyWith(color: Colors.white),
      labelLarge: UiTypography.button.copyWith(color: Colors.white),
      labelMedium: UiTypography.caption.copyWith(color: Colors.white),
      labelSmall: UiTypography.caption.copyWith(color: Colors.white),
    ),
  );
}
