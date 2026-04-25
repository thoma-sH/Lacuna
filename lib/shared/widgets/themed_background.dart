import 'dart:math' as math;

import 'package:first_flutter_app/shared/theme/lacuna_theme.dart';
import 'package:first_flutter_app/shared/theme/lacuna_theme_provider.dart';
import 'package:first_flutter_app/shared/widgets/grain_overlay.dart';
import 'package:flutter/material.dart';

class ThemedBackground extends StatelessWidget {
  const ThemedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = LacunaThemeScope.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: RepaintBoundary(
        key: ValueKey(theme.variant),
        child: _buildFor(theme),
      ),
    );
  }

  Widget _buildFor(LacunaTheme theme) {
    switch (theme.backgroundMode) {
      case BackgroundMode.flat:
        return ColoredBox(color: theme.palette.bgBase);
      case BackgroundMode.gradient:
        return _GradientBackground(theme: theme);
      case BackgroundMode.orbs:
        return _OrbsBackground(theme: theme);
      case BackgroundMode.aurora:
        return _AuroraBackground(theme: theme);
      case BackgroundMode.noise:
        return _NoiseBackground(theme: theme);
      case BackgroundMode.iosGlass:
        return _IOSGlassBackground(theme: theme);
    }
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground({required this.theme});

  final LacunaTheme theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.bgGradient,
            ),
          ),
        ),
        const Positioned.fill(child: GrainOverlay(opacity: 0.06)),
      ],
    );
  }
}

class _OrbsBackground extends StatefulWidget {
  const _OrbsBackground({required this.theme});

  final LacunaTheme theme;

  @override
  State<_OrbsBackground> createState() => _OrbsBackgroundState();
}

class _OrbsBackgroundState extends State<_OrbsBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(
        milliseconds: (18000 / widget.theme.motionScale).round(),
      ),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.theme.palette;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: p.bgDeep),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) {
            final t = _ctrl.value * 2 * math.pi;
            return Stack(
              fit: StackFit.expand,
              children: [
                _Orb(
                  color: p.accent.withValues(alpha: 0.28),
                  alignment: Alignment(
                    0.6 * math.sin(t),
                    -0.4 + 0.2 * math.cos(t * 0.7),
                  ),
                  scale: 1.6,
                ),
                _Orb(
                  color: p.accentDeep.withValues(alpha: 0.22),
                  alignment: Alignment(
                    -0.7 + 0.3 * math.cos(t * 0.5),
                    0.5 + 0.2 * math.sin(t * 0.8),
                  ),
                  scale: 1.4,
                ),
              ],
            );
          },
        ),
        const Positioned.fill(child: GrainOverlay(opacity: 0.06)),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.color,
    required this.alignment,
    required this.scale,
  });

  final Color color;
  final Alignment alignment;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: scale * 0.9,
        heightFactor: scale * 0.9,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0), Colors.transparent],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuroraBackground extends StatefulWidget {
  const _AuroraBackground({required this.theme});

  final LacunaTheme theme;

  @override
  State<_AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<_AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(
        milliseconds: (22000 / widget.theme.motionScale).round(),
      ),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.theme.palette;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.theme.bgGradient,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) {
            final t = _ctrl.value * 2 * math.pi;
            return Stack(
              fit: StackFit.expand,
              children: [
                _AuroraRibbon(
                  color: p.accent.withValues(alpha: 0.18),
                  phase: t,
                  top: 0.1,
                ),
                _AuroraRibbon(
                  color: p.accentDeep.withValues(alpha: 0.14),
                  phase: t + math.pi / 2,
                  top: 0.35,
                ),
                _AuroraRibbon(
                  color: p.accentSoft.withValues(alpha: 0.12),
                  phase: t + math.pi,
                  top: 0.6,
                ),
              ],
            );
          },
        ),
        const Positioned.fill(child: GrainOverlay(opacity: 0.06)),
      ],
    );
  }
}

class _AuroraRibbon extends StatelessWidget {
  const _AuroraRibbon({
    required this.color,
    required this.phase,
    required this.top,
  });

  final Color color;
  final double phase;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.3 * math.sin(phase), top * 2 - 1),
      child: FractionallySizedBox(
        widthFactor: 1.8,
        heightFactor: 0.45,
        child: Transform.rotate(
          angle: 0.12 * math.sin(phase * 0.7),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0),
                radius: 0.7,
                colors: [color, color.withValues(alpha: 0), Colors.transparent],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoiseBackground extends StatelessWidget {
  const _NoiseBackground({required this.theme});

  final LacunaTheme theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.bgGradient,
            ),
          ),
        ),
        const Positioned.fill(child: GrainOverlay(opacity: 0.08)),
      ],
    );
  }
}

class _IOSGlassBackground extends StatefulWidget {
  const _IOSGlassBackground({required this.theme});

  final LacunaTheme theme;

  @override
  State<_IOSGlassBackground> createState() => _IOSGlassBackgroundState();
}

class _IOSGlassBackgroundState extends State<_IOSGlassBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  static const _orbColors = <Color>[
    Color(0xFFFFB39E),
    Color(0xFFC5B5F0),
    Color(0xFFB8E5D0),
    Color(0xFF9FCBFF),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(
        milliseconds: (26000 / widget.theme.motionScale).round(),
      ),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.theme.bgGradient,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) {
            final t = _ctrl.value * 2 * math.pi;
            return Stack(
              fit: StackFit.expand,
              children: [
                _GlassOrb(
                  color: _orbColors[0].withValues(alpha: 0.55),
                  alignment: Alignment(
                    -0.55 + 0.3 * math.sin(t),
                    -0.55 + 0.18 * math.cos(t * 0.8),
                  ),
                  scale: 1.45,
                ),
                _GlassOrb(
                  color: _orbColors[1].withValues(alpha: 0.50),
                  alignment: Alignment(
                    0.55 + 0.25 * math.cos(t * 0.7),
                    -0.25 + 0.22 * math.sin(t * 0.9),
                  ),
                  scale: 1.65,
                ),
                _GlassOrb(
                  color: _orbColors[2].withValues(alpha: 0.45),
                  alignment: Alignment(
                    -0.4 + 0.32 * math.sin(t * 0.6),
                    0.6 + 0.2 * math.cos(t * 1.1),
                  ),
                  scale: 1.35,
                ),
                _GlassOrb(
                  color: _orbColors[3].withValues(alpha: 0.50),
                  alignment: Alignment(
                    0.65 + 0.22 * math.cos(t * 1.2),
                    0.45 + 0.25 * math.sin(t * 0.5),
                  ),
                  scale: 1.55,
                ),
              ],
            );
          },
        ),
        const Positioned.fill(child: GrainOverlay(opacity: 0.04)),
      ],
    );
  }
}

class _GlassOrb extends StatelessWidget {
  const _GlassOrb({
    required this.color,
    required this.alignment,
    required this.scale,
  });

  final Color color;
  final Alignment alignment;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: scale,
        heightFactor: scale,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0), Colors.transparent],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
