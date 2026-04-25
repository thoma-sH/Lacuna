import 'package:first_flutter_app/shared/theme/app_motion.dart';
import 'package:first_flutter_app/shared/widgets/sparkle_icon.dart';
import 'package:flutter/material.dart';

class BreathingSparkle extends StatefulWidget {
  const BreathingSparkle({
    required this.color,
    required this.size,
    this.duration = const Duration(milliseconds: 4800),
    this.phaseOffset = 0.0,
    super.key,
  });

  final Color color;
  final double size;
  final Duration duration;
  final double phaseOffset;

  @override
  State<BreathingSparkle> createState() => _BreathingSparkleState();
}

class _BreathingSparkleState extends State<BreathingSparkle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: widget.duration,
      vsync: this,
      value: widget.phaseOffset.clamp(0.0, 1.0),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.78, end: 1.18).animate(
      CurvedAnimation(parent: _ctrl, curve: AppMotion.breatheCurve),
    );
    _opacity = Tween<double>(begin: 0.40, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: AppMotion.breatheCurve),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: SparkleIcon(size: widget.size, color: widget.color),
          ),
        ),
      ),
    );
  }
}
