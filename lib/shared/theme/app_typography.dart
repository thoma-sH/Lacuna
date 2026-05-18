import 'package:first_flutter_app/shared/theme/lacuna_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  /// Variants that already declare a serif body font keep that serif on
  /// display sizes. Sans/mono variants get Fraunces on display only — body
  /// text stays on the variant's chosen font for readability.
  static const _serifVariantFonts = {'Lora', 'Cinzel', 'Fraunces'};

  static TextTheme build() {
    final variant = currentLacunaTheme;
    final base = GoogleFonts.getTextTheme(variant.fontName);
    final displayFamily = _serifVariantFonts.contains(variant.fontName)
        ? variant.fontName
        : 'Fraunces';
    final display = GoogleFonts.getTextTheme(displayFamily);

    return TextTheme(
      displayLarge: display.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        letterSpacing: -1.2,
        height: 1.05,
        color: AppColors.textPrimary,
      ),
      displayMedium: display.displayMedium?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.8,
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      displaySmall: display.displaySmall?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.5,
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
        color: AppColors.textPrimary,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: AppColors.textPrimary,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.5,
        color: AppColors.textTertiary,
      ),
    );
  }
}
