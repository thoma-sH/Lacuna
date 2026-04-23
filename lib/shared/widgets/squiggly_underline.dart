import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SquigglyUnderline extends StatelessWidget {
  const SquigglyUnderline({
    required this.width,
    this.color,
    super.key,
  });

  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, 6),
      painter: _SquigglyPainter(color: color ?? AppColors.accent),
    );
  }
}

class _SquigglyPainter extends CustomPainter {
  const _SquigglyPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    const wavelength = 7.0;
    const amplitude = 1.8;

    path.moveTo(0, size.height / 2);
    for (var x = 0.0; x <= size.width; x++) {
      final y =
          size.height / 2 + amplitude * math.sin(x * 2 * math.pi / wavelength);
      path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SquigglyPainter old) => old.color != color;
}
