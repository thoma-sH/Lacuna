import 'dart:ui';

import 'package:first_flutter_app/shared/theme/lacuna_theme.dart';
import 'package:first_flutter_app/shared/theme/lacuna_theme_provider.dart';
import 'package:flutter/material.dart';

enum GlassThickness { thin, regular, thick }

class GlassSurface extends StatelessWidget {
  const GlassSurface({
    required this.child,
    this.thickness = GlassThickness.regular,
    this.borderRadius = 16,
    this.padding,
    this.tintOverride,
    super.key,
  });

  final Widget child;
  final GlassThickness thickness;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? tintOverride;

  double get _thicknessScale => switch (thickness) {
    GlassThickness.thin => 0.6,
    GlassThickness.regular => 1.0,
    GlassThickness.thick => 1.3,
  };

  double get _tintScale => switch (thickness) {
    GlassThickness.thin => 0.5,
    GlassThickness.regular => 1.0,
    GlassThickness.thick => 1.4,
  };

  @override
  Widget build(BuildContext context) {
    final theme = LacunaThemeScope.of(context);
    final body = padding != null ? Padding(padding: padding!, child: child) : child;

    switch (theme.surfaceStyle) {
      case SurfaceStyle.solid:
        return _SolidSurface(theme: theme, borderRadius: borderRadius, tintOverride: tintOverride, child: body);
      case SurfaceStyle.paper:
        return _PaperSurface(theme: theme, borderRadius: borderRadius, tintOverride: tintOverride, child: body);
      case SurfaceStyle.frosted:
        return _FrostedSurface(
          theme: theme,
          borderRadius: borderRadius,
          tintOverride: tintOverride,
          blurSigma: theme.blurSigma * _thicknessScale,
          tintScale: _tintScale,
          child: body,
        );
      case SurfaceStyle.liquidGlass:
        return _LiquidGlassSurface(
          theme: theme,
          borderRadius: borderRadius,
          tintOverride: tintOverride,
          blurSigma: theme.blurSigma * _thicknessScale,
          tintScale: _tintScale,
          child: body,
        );
    }
  }
}

class _SolidSurface extends StatelessWidget {
  const _SolidSurface({
    required this.theme,
    required this.borderRadius,
    required this.tintOverride,
    required this.child,
  });

  final LacunaTheme theme;
  final double borderRadius;
  final Color? tintOverride;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = theme.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tintOverride ?? p.surface1,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: p.borderSubtle, width: 0.5),
        boxShadow: theme.depthShadow > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12 * theme.depthShadow),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

class _PaperSurface extends StatelessWidget {
  const _PaperSurface({
    required this.theme,
    required this.borderRadius,
    required this.tintOverride,
    required this.child,
  });

  final LacunaTheme theme;
  final double borderRadius;
  final Color? tintOverride;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = theme.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tintOverride ?? p.surface1,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: p.borderHairline, width: 0.5),
        boxShadow: theme.depthShadow > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08 * theme.depthShadow),
                  blurRadius: 20,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

class _FrostedSurface extends StatelessWidget {
  const _FrostedSurface({
    required this.theme,
    required this.borderRadius,
    required this.tintOverride,
    required this.blurSigma,
    required this.tintScale,
    required this.child,
  });

  final LacunaTheme theme;
  final double borderRadius;
  final Color? tintOverride;
  final double blurSigma;
  final double tintScale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = theme.palette;
    final tint = tintOverride ?? p.bgDeep.withValues(alpha: 0.42 * tintScale);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: p.borderHairline, width: 0.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _LiquidGlassSurface extends StatelessWidget {
  const _LiquidGlassSurface({
    required this.theme,
    required this.borderRadius,
    required this.tintOverride,
    required this.blurSigma,
    required this.tintScale,
    required this.child,
  });

  final LacunaTheme theme;
  final double borderRadius;
  final Color? tintOverride;
  final double blurSigma;
  final double tintScale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = theme.palette;
    final isLight = p.brightness == Brightness.light;
    final tint = tintOverride ??
        (isLight
            ? Colors.white.withValues(alpha: 0.35 * tintScale)
            : Colors.white.withValues(alpha: 0.08 * tintScale));
    final specularColor = isLight
        ? Colors.white.withValues(alpha: theme.specularOpacity * 1.2)
        : Colors.white.withValues(alpha: theme.specularOpacity);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      tint.withValues(alpha: tint.a * 1.4),
                      tint,
                      tint.withValues(alpha: tint.a * 0.7),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                    width: 0.5,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      specularColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
