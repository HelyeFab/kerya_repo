import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color lightPrimary = Color(0xFF6750A4);
  static const Color lightSecondary = Color(0xFF625B71);
  static const Color lightTertiary = Color(0xFF7D5260);
  static const Color lightBackground = Color(0xFFF6F2FF);
  static const Color lightSurface = Color(0xFFFFFBFE);
  static const Color lightSurfaceVariant = Color(0xFFE7E0EC);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1C1B1F);
  static const Color lightOnSurface = Color(0xFF1C1B1F);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFFBB86FC);
  static const Color darkSecondary = Color(0xFF03DAC6);
  static const Color darkTertiary = Color(0xFFCF6679);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF373737);
  static const Color darkSurfaceContainer = Color(0xFF383838);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnTertiary = Color(0xFFFFFFFF);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFB3B3B3);

  // Common colors
  static const Color error = Color(0xFFCF6679);
  static const Color onError = Color(0xFF000000);
  static const Color playful = Color(0xFFFFAB40);
  static const Color calm = Color(0xFF64DD17);
  static const Color focus = Color(0xFF0091EA);

  // Control colors for reader
  static const Color controlPurple = Color(0xFFBB86FC);
  static const Color controlPink = Color(0xFFF48FB1);
  static const Color controlText = Color(0xFFFFFFFF);

  // Icon colors for navigation
  static const Color icon = Color(0xFF1C1B1F);
  static const Color iconDark = Color(0xFFFFFFFF);

  // For backward compatibility
  static const Color primary = lightPrimary;

  // Flashcard colors
  static const flashcardHardLight = Color(0xFFCF6679);
  static const flashcardHardDark = Color(0xFF8E0031);
  static const flashcardGoodLight = Color(0xFF81D4FA);
  static const flashcardGoodDark = Color(0xFF0277BD);
  static const flashcardEasyLight = Color(0xFFB9F6CA);
  static const flashcardEasyDark = Color(0xFF1B5E20);
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.lightPrimary,
  onPrimary: AppColors.lightOnPrimary,
  secondary: AppColors.lightSecondary,
  onSecondary: AppColors.lightOnSecondary,
  tertiary: AppColors.lightTertiary,
  onTertiary: AppColors.lightOnTertiary,
  error: AppColors.error,
  onError: AppColors.onError,
  surface: AppColors.lightSurface,
  onSurface: AppColors.lightOnSurface,
  surfaceContainerHighest: AppColors.lightSurfaceVariant,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.darkPrimary,
  onPrimary: AppColors.darkOnPrimary,
  secondary: AppColors.darkSecondary,
  onSecondary: AppColors.darkOnSecondary,
  tertiary: AppColors.darkTertiary,
  onTertiary: AppColors.darkOnTertiary,
  error: AppColors.error,
  onError: AppColors.onError,
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkOnSurface,
  surfaceContainerHighest: AppColors.darkSurfaceVariant,
  surfaceContainerLowest: AppColors.darkSurfaceContainer, // New surface container color
);
