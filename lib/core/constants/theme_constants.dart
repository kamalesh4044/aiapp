import 'package:flutter/material.dart';

class ThemeConstants {
  // Primary Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFE0E7FF);
  
  // Secondary Colors
  static const Color secondaryColor = Color(0xFF10B981);
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFFD1FAE5);
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFFCD34D);
  static const Color successColor = Color(0xFF10B981);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);
  
  // Border Colors
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color borderColorDark = Color(0xFFD1D5DB);
  
  // Spacing
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  
  // Border Radius
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXL = 24;
  static const double radiusCircle = 999;
  
  // Font Sizes
  static const double fontXS = 12;
  static const double fontSmall = 14;
  static const double fontBase = 16;
  static const double fontLarge = 18;
  static const double fontXL = 20;
  static const double font2XL = 24;
  static const double font3XL = 30;
  static const double font4XL = 36;
  
  // Shadows
  static const BoxShadow shadowSmall = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  
  static const BoxShadow shadowMedium = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow shadowLarge = BoxShadow(
    color: Color(0x29000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );
}
