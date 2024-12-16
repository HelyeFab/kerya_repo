import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_schemes.dart';
import 'text_themes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = AppTextTheme.textTheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: lightColorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: lightColorScheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelStyle: GoogleFonts.nunitoSans(
          color: lightColorScheme.primary,
        ),
        labelStyle: GoogleFonts.nunitoSans(),
        hintStyle: GoogleFonts.nunitoSans(),
        errorStyle: GoogleFonts.nunitoSans(
          color: lightColorScheme.error,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = AppTextTheme.textTheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkColorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: darkColorScheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelStyle: GoogleFonts.nunitoSans(
          color: darkColorScheme.primary,
        ),
        labelStyle: GoogleFonts.nunitoSans(),
        hintStyle: GoogleFonts.nunitoSans(),
        errorStyle: GoogleFonts.nunitoSans(
          color: darkColorScheme.error,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
