import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.nunitoSans(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.nunitoSans(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: GoogleFonts.nunitoSans(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: GoogleFonts.nunitoSans(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: GoogleFonts.nunitoSans(
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: GoogleFonts.nunitoSans(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: GoogleFonts.nunitoSans(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelLarge: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    );
  }
}
