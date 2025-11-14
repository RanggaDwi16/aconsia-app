import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
      primaryTextTheme: const TextTheme(
        displayLarge: TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600),
        displayMedium: TextStyle(
            color: Colors.white, fontSize: 28, fontWeight: FontWeight.w500),
        displaySmall: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: Colors.white, fontSize: 12),
        labelLarge: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 32,
            fontWeight: FontWeight.w600),
        displayMedium: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 28,
            fontWeight: FontWeight.w500),
        displaySmall: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 24,
            fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 22,
            fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 20,
            fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        titleMedium: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 14,
            fontWeight: FontWeight.w500),
        titleSmall: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        labelLarge: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 14,
            fontWeight: FontWeight.w600),
        labelMedium: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 12,
            fontWeight: FontWeight.w500),
        labelSmall: TextStyle(
            color: AppColor.primaryBlack,
            fontSize: 10,
            fontWeight: FontWeight.w400),
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
    primaryTextTheme: const TextTheme(
      displayLarge: TextStyle(
          color: AppColor.textColor, fontSize: 32, fontWeight: FontWeight.w600),
      displayMedium: TextStyle(
          color: AppColor.textColor, fontSize: 28, fontWeight: FontWeight.w500),
      displaySmall: TextStyle(
          color: AppColor.textColor, fontSize: 24, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(
          color: AppColor.textColor, fontSize: 22, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(
          color: AppColor.textColor, fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
          color: AppColor.textColor, fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(
          color: AppColor.textColor, fontSize: 16, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(
          color: AppColor.textColor, fontSize: 14, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: AppColor.textColor, fontSize: 12, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(
          color: AppColor.textColor, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          color: AppColor.textColor, fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: AppColor.textColor, fontSize: 12),
      labelLarge: TextStyle(
          color: AppColor.textColor, fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(
          color: AppColor.textColor, fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          color: AppColor.textColor, fontSize: 10, fontWeight: FontWeight.w400),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600),
      displayMedium: TextStyle(
          color: Colors.white, fontSize: 28, fontWeight: FontWeight.w500),
      displaySmall: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
    ),
  );
}
