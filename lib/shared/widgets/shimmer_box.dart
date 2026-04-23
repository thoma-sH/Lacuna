import 'package:first_flutter_app/shared/theme/app_colors.dart';
import 'package:first_flutter_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
    this.tint,
    super.key,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? tint;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1100),
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
    final base = widget.tint ?? AppColors.surface1;
    final highlight = Color.lerp(base, AppColors.textTertiary, 0.18) ?? base;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => ClipRRect(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(AppSpacing.sm),
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _ShimmerPainter(
              progress: _ctrl.value,
              base: base,
              highlight: highlight,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({
    required this.progress,
    required this.base,
    required this.highlight,
  });

  final double progress;
  final Color base;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [base, highlight, base],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment(-1.5 + progress * 3, 0),
      end: Alignment(-0.5 + progress * 3, 0),
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = gradient.createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.progress != progress;
}
