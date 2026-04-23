import 'package:first_flutter_app/shared/theme/lacuna_theme_provider.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Color get bgDeep => currentLacunaTheme.palette.bgDeep;
  static Color get bgBase => currentLacunaTheme.palette.bgBase;
  static Color get surface1 => currentLacunaTheme.palette.surface1;
  static Color get surface2 => currentLacunaTheme.palette.surface2;
  static Color get surface3 => currentLacunaTheme.palette.surface3;

  static Color get borderSubtle => currentLacunaTheme.palette.borderSubtle;
  static Color get borderHairline => currentLacunaTheme.palette.borderHairline;

  static Color get textPrimary => currentLacunaTheme.palette.textPrimary;
  static Color get textSecondary => currentLacunaTheme.palette.textSecondary;
  static Color get textTertiary => currentLacunaTheme.palette.textTertiary;
  static Color get textDisabled => currentLacunaTheme.palette.textDisabled;

  static Color get accent => currentLacunaTheme.palette.accent;
  static Color get accentSoft => currentLacunaTheme.palette.accentSoft;
  static Color get accentDeep => currentLacunaTheme.palette.accentDeep;
  static Color get accentGlow => currentLacunaTheme.palette.accentGlow;

  static Color get upvote => currentLacunaTheme.palette.upvote;
  static Color get downvote => currentLacunaTheme.palette.downvote;
}
