import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: ThemeConstants.primaryColor,
        secondary: ThemeConstants.secondaryColor,
        error: ThemeConstants.errorColor,
        surface: ThemeConstants.surfaceColor,
        background: ThemeConstants.backgroundColor,
      ),
      scaffoldBackgroundColor: ThemeConstants.backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeConstants.surfaceColor,
        foregroundColor: ThemeConstants.textPrimary,
        elevation: 0,
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.all(ThemeConstants.spacing16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: const BorderSide(color: ThemeConstants.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: const BorderSide(color: ThemeConstants.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ThemeConstants.primaryColor,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          color: ThemeConstants.textTertiary,
          fontSize: ThemeConstants.fontSmall,
        ),
        labelStyle: const TextStyle(
          color: ThemeConstants.textSecondary,
          fontSize: ThemeConstants.fontSmall,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.primaryColor,
          foregroundColor: ThemeConstants.textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing24,
            vertical: ThemeConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: ThemeConstants.fontBase,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeConstants.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing16,
            vertical: ThemeConstants.spacing12,
          ),
          textStyle: const TextStyle(
            fontSize: ThemeConstants.fontBase,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ThemeConstants.primaryLight,
        selectedColor: ThemeConstants.primaryColor,
        labelStyle: const TextStyle(
          color: ThemeConstants.textPrimary,
          fontSize: ThemeConstants.fontSmall,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing8,
          vertical: ThemeConstants.spacing4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: ThemeConstants.font4XL,
          fontWeight: FontWeight.w700,
          color: ThemeConstants.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: ThemeConstants.font3XL,
          fontWeight: FontWeight.w700,
          color: ThemeConstants.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: ThemeConstants.font2XL,
          fontWeight: FontWeight.w700,
          color: ThemeConstants.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: ThemeConstants.fontXL,
          fontWeight: FontWeight.w600,
          color: ThemeConstants.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: ThemeConstants.fontLarge,
          fontWeight: FontWeight.w600,
          color: ThemeConstants.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: ThemeConstants.fontBase,
          fontWeight: FontWeight.w600,
          color: ThemeConstants.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: ThemeConstants.fontBase,
          fontWeight: FontWeight.w400,
          color: ThemeConstants.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: ThemeConstants.fontSmall,
          fontWeight: FontWeight.w400,
          color: ThemeConstants.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: ThemeConstants.fontXS,
          fontWeight: FontWeight.w400,
          color: ThemeConstants.textTertiary,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: ThemeConstants.primaryLight,
        secondary: ThemeConstants.secondaryLight,
        error: ThemeConstants.errorColor,
        surface: const Color(0xFF1F2937),
        background: const Color(0xFF111827),
      ),
      scaffoldBackgroundColor: const Color(0xFF111827),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: ThemeConstants.textInverse,
        elevation: 0,
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D3748),
        contentPadding: const EdgeInsets.all(ThemeConstants.spacing16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF4B5563)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF4B5563)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: const BorderSide(
            color: ThemeConstants.primaryLight,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.primaryColor,
          foregroundColor: ThemeConstants.textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing24,
            vertical: ThemeConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          ),
        ),
      ),
    );
  }
}
