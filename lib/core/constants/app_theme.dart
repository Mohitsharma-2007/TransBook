import 'package:flutter/material.dart';

class AppTheme {
  // Primary Palette
  static const Color brandPrimary = Color(0xFF1A3C8F);
  static const Color brandSecondary = Color(0xFFF7A800);
  static const Color brandDark = Color(0xFF0D2255);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF4F6FB);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFCBD5E0);
  static const Color errorColor = Color(0xFFF44336);

  // Status Colors
  static const Color statusDraft = Color(0xFF9E9E9E);
  static const Color statusSubmitted = Color(0xFF2196F3);
  static const Color statusAcknowledged = Color(0xFFFF9800);
  static const Color statusPaid = Color(0xFF4CAF50);
  static const Color statusPartial = Color(0xFFFF5722);
  static const Color statusOverdue = Color(0xFFF44336);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF5A6A7A);
  static const Color textMuted = Color(0xFF9EAAB8);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textAmount = Color(0xFF1A3C8F);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        primary: brandPrimary,
        secondary: brandSecondary,
        surface: surfaceWhite,
        background: surfaceLight,
        error: statusOverdue,
      ),
      scaffoldBackgroundColor: surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: brandPrimary,
        foregroundColor: textOnDark,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        titleSmall: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400, color: textPrimary),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w400, color: textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: brandPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: statusOverdue),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: textOnDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
