import 'package:flutter/material.dart';

enum LacunaThemeVariant {
  calm,
  industrial,
  space,
  effervescent,
  translucent,
  glass,
  white,
  monotone,
  zen,
  rage,
  barbaric,
}

class ColorPalette {
  const ColorPalette({
    required this.bgDeep,
    required this.bgBase,
    required this.surface1,
    required this.surface2,
    required this.surface3,
    required this.borderSubtle,
    required this.borderHairline,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.accent,
    required this.accentSoft,
    required this.accentDeep,
    required this.accentGlow,
    required this.upvote,
    required this.downvote,
    required this.brightness,
  });

  final Color bgDeep;
  final Color bgBase;
  final Color surface1;
  final Color surface2;
  final Color surface3;
  final Color borderSubtle;
  final Color borderHairline;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color accent;
  final Color accentSoft;
  final Color accentDeep;
  final Color accentGlow;
  final Color upvote;
  final Color downvote;
  final Brightness brightness;
}

class ScallopConfig {
  const ScallopConfig({required this.lobes, required this.depth});

  final int lobes;
  final double depth;
}

class LacunaTheme {
  const LacunaTheme({
    required this.variant,
    required this.displayName,
    required this.tagline,
    required this.palette,
    required this.scallop,
    required this.fontName,
    required this.radiusScale,
    required this.grainOpacity,
  });

  final LacunaThemeVariant variant;
  final String displayName;
  final String tagline;
  final ColorPalette palette;
  final ScallopConfig scallop;
  final String fontName;
  final double radiusScale;
  final double grainOpacity;
}
