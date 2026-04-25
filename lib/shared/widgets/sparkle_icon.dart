import 'package:flutter/material.dart';

class SparkleIcon extends StatelessWidget {
  const SparkleIcon({
    required this.size,
    required this.color,
    this.concavity = 0.92,
    super.key,
  });

  final double size;
  final Color color;
  final double concavity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _SparklePainter(color: color, concavity: concavity),
    );
  }
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({required this.color, required this.concavity});

  final Color color;
  final double concavity;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.shortestSide / 2;
    final c = r * (1 - concavity);
    final path = Path()
      ..moveTo(cx, cy - r)
      ..quadraticBezierTo(cx + c, cy - c, cx + r, cy)
      ..quadraticBezierTo(cx + c, cy + c, cx, cy + r)
      ..quadraticBezierTo(cx - c, cy + c, cx - r, cy)
      ..quadraticBezierTo(cx - c, cy - c, cx, cy - r)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_SparklePainter old) =>
      old.color != color || old.concavity != concavity;
}
