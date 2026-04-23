import 'dart:math' as math;

import 'package:first_flutter_app/shared/theme/lacuna_theme_provider.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Path buildScallopPath(Size size, {int lobes = 12, double depth = 0.07}) {
  final cx = size.width / 2;
  final cy = size.height / 2;
  final r = size.shortestSide / 2;
  if (lobes <= 0 || depth <= 0) {
    return Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
  }
  final innerR = r * (1 - depth);
  final path = Path();
  const steps = 720;
  for (var i = 0; i <= steps; i++) {
    final theta = (i / steps) * 2 * math.pi - math.pi / 2;
    final rCurrent =
        innerR + (r - innerR) * 0.5 * (1 + math.cos(theta * lobes));
    final x = cx + rCurrent * math.cos(theta);
    final y = cy + rCurrent * math.sin(theta);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}

class ScallopedClipper extends CustomClipper<Path> {
  const ScallopedClipper({this.lobes = 12, this.depth = 0.07});

  final int lobes;
  final double depth;

  @override
  Path getClip(Size size) => buildScallopPath(size, lobes: lobes, depth: depth);

  @override
  bool shouldReclip(ScallopedClipper old) =>
      old.lobes != lobes || old.depth != depth;
}

class _ScallopBorderPainter extends CustomPainter {
  const _ScallopBorderPainter({
    required this.color,
    required this.glowColor,
    required this.lobes,
    required this.depth,
  });

  final Color color;
  final Color glowColor;
  final int lobes;
  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = buildScallopPath(size, lobes: lobes, depth: depth);

    canvas.drawPath(
      path,
      Paint()
        ..color = glowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_ScallopBorderPainter old) =>
      old.color != color ||
      old.glowColor != glowColor ||
      old.lobes != lobes ||
      old.depth != depth;
}

class ScallopedAvatar extends StatelessWidget {
  const ScallopedAvatar({
    required this.size,
    required this.initial,
    required this.color,
    this.borderColor,
    super.key,
  });

  final double size;
  final String initial;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final inner = size * 0.88;
    final shape = LacunaThemeScope.of(context).scallop;
    final border = borderColor ?? AppColors.accent;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _ScallopBorderPainter(
              color: border,
              glowColor: border.withValues(alpha: 0.35),
              lobes: shape.lobes,
              depth: shape.depth,
            ),
          ),
          ClipPath(
            clipper: ScallopedClipper(lobes: shape.lobes, depth: shape.depth),
            child: SizedBox.square(
              dimension: inner,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, -0.4),
                    colors: [
                      Color.lerp(color, Colors.white, 0.22) ?? color,
                      Color.lerp(color, Colors.black, 0.45) ?? color,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    initial.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: inner * 0.32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScallopedOutlineButton extends StatelessWidget {
  const ScallopedOutlineButton({
    required this.onTap,
    required this.child,
    required this.size,
    this.borderColor,
    super.key,
  });

  final VoidCallback onTap;
  final Widget child;
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final shape = LacunaThemeScope.of(context).scallop;
    final border = borderColor ?? AppColors.accent;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _ScallopBorderPainter(
            color: border,
            glowColor: Colors.transparent,
            lobes: shape.lobes,
            depth: shape.depth,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
