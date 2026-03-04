import 'package:flutter/material.dart';

class AppTheme {
  // Premium Palette
  static const Color brandPrimary = Color(0xFF1E293B); // Slate 800
  static const Color brandSecondary = Color(0xFF3B82F6); // Blue 500
  static const Color brandDark = Color(0xFF0F172A); // Slate 900
  static const Color brandAccent = Color(0xFF10B981); // Emerald 500
  
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color borderMedium = Color(0xFFCBD5E1); // Slate 300
  static const Color errorColor = Color(0xFFEF4444); // Red 500

  // Status Colors
  static const Color statusDraft = Color(0xFF94A3B8); // Slate 400
  static const Color statusSubmitted = Color(0xFF3B82F6); // Blue 500
  static const Color statusAcknowledged = Color(0xFFF59E0B); // Amber 500
  static const Color statusPaid = Color(0xFF10B981); // Emerald 500
  static const Color statusPartial = Color(0xFFF97316); // Orange 500
  static const Color statusOverdue = Color(0xFFEF4444); // Red 500
  
  static const Color statusTextDraft = Color(0xFF334155); 
  static const Color statusTextSubmitted = Color(0xFF1E3A8A); 
  static const Color statusTextPaid = Color(0xFF064E3B); 
  
  static const Color statusBgDraft = Color(0xFFF1F5F9); 
  static const Color statusBgSubmitted = Color(0xFFEFF6FF); 
  static const Color statusBgPaid = Color(0xFFECFDF5); 

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textOnDark = Color(0xFFF8FAFC);
  static const Color textAmount = Color(0xFF0F172A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandSecondary,
        primary: brandSecondary,
        secondary: brandAccent,
        surface: surfaceLight,
        error: errorColor,
      ),
      scaffoldBackgroundColor: surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textSecondary),
      ),
      cardTheme: const CardThemeData(
        color: surfaceWhite,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: -0.5),
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        titleSmall: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: textMuted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandSecondary, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandSecondary,
          foregroundColor: surfaceWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brandSecondary,
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(surfaceLight),
        headingTextStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: textSecondary),
        dataTextStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w400, color: textPrimary),
        dividerThickness: 1,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: borderLight)),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: surfaceWhite,
      ),
    );
  }
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: brandSecondary,
        primary: brandSecondary,
        secondary: brandAccent,
        surface: brandDark,
        error: errorColor,
      ),
      scaffoldBackgroundColor: brandDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: brandPrimary,
        foregroundColor: textOnDark,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: brandPrimary,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.bold, color: textOnDark),
        headlineMedium: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold, color: textOnDark),
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: textOnDark),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: textOnDark),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w400, color: textMuted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brandPrimary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: brandPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(brandPrimary),
        headingTextStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: textMuted),
        dataTextStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w400, color: textOnDark),
      ),
    );
  }

  static ThemeData get modernBusinessTheme {
    final base = lightTheme;
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF2563EB), // Deeper blue
        secondary: const Color(0xFFD97706), // Amber
      ),
      scaffoldBackgroundColor: const Color(0xFFEFF6FF), // Blue tint background
      cardTheme: base.cardTheme.copyWith(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    );
  }

  static ThemeData get minimalistTheme {
    final base = lightTheme;
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF171717), // Near black
        secondary: const Color(0xFF525252), // Neutral grey
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: base.appBarTheme.copyWith(backgroundColor: Colors.white),
      cardTheme: base.cardTheme.copyWith(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0), side: const BorderSide(color: Color(0xFFE5E5E5)))),
    );
  }
}
