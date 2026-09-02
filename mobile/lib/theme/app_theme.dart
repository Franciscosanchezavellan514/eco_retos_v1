import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Verdes principales - inspirados en el prototipo, refinados para la app
  static const Color primary = Color(0xFF2E7D45);      // verde principal, más vivo
  static const Color primaryDark = Color(0xFF1B4D2E);  // verde oscuro para headers/acentos
  static const Color primaryLight = Color(0xFF6FCF7C); // verde claro para highlights

  // Fondos
  static const Color background = Color(0xFFF6FBF5);   // fondo general, casi blanco con tinte verde
  static const Color surfaceSoft = Color(0xFFE8F5E9);   // fondo de tarjetas/inputs suaves

  // Texto
  static const Color textPrimary = Color(0xFF1C2B1E);
  static const Color textMuted = Color(0xFF6B7A6C);

  // Estados
  static const Color danger = Color(0xFFD9534F);
  static const Color warning = Color(0xFFF2A93B);
}

class AppTheme {
  static ThemeData get light {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999), // botones tipo "pill"
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
      ),
    );
  }
}