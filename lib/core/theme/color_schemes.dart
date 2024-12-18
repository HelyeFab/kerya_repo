import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6750A4);
  static const Color secondary = Color(0xFF625B71);
  static const Color tertiary = Color(0xFF7D5260);
  
  // Background colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  
  // Text colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  
  // Error colors
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  
  // Custom colors for children's app
  static const Color playful = Color(0xFFFF9800);
  static const Color calm = Color(0xFF81C784);
  static const Color focus = Color(0xFF4FC3F7);

  // Control colors
  static const Color controlPurple = Color(0xFFE6E0F4);
  static const Color controlPink = Color(0xFFFFE0E6);
  static const Color controlText = Color(0xFF1C1B1F); // Using onSurface color for consistency
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  tertiary: AppColors.tertiary,
  onTertiary: AppColors.onTertiary,
  error: AppColors.error,
  onError: AppColors.onError,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.primary,
  onPrimary: AppColors.background,
  secondary: AppColors.secondary,
  onSecondary: AppColors.background,
  tertiary: AppColors.tertiary,
  onTertiary: AppColors.background,
  error: AppColors.error,
  onError: AppColors.background,
  surface: AppColors.onBackground,
  onSurface: AppColors.background,
);
