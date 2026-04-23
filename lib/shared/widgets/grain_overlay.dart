import 'dart:math';

import 'package:flutter/material.dart';

class GrainOverlay extends StatelessWidget {
  const GrainOverlay({this.opacity = 0.04, this.density = 4500, super.key});

  final double opacity;
  final int density;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GrainPainter(opacity: opacity, density: density),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  _GrainPainter({required this.opacity, required this.density});

  final double opacity;
  final int density;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(7);
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < density; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      final shade = rng.nextDouble();
      final isLight = shade > 0.5;
      paint.color = (isLight ? Colors.white : Colors.black).withValues(
        alpha: opacity * (0.5 + rng.nextDouble() * 0.5),
      );
      canvas.drawCircle(Offset(dx, dy), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GrainPainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.density != density;
}
