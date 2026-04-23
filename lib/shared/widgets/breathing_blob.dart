import 'package:first_flutter_app/shared/theme/app_motion.dart';
import 'package:flutter/material.dart';

class BreathingBlob extends StatefulWidget {
  const BreathingBlob({
    required this.color,
    required this.size,
    this.glowIntensity = 0.45,
    super.key,
  });

  final Color color;
  final double size;
  final double glowIntensity;

  @override
  State<BreathingBlob> createState() => _BreathingBlobState();
}

class _BreathingBlobState extends State<BreathingBlob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: AppMotion.breathe,
      vsync: this,
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: AppMotion.breatheCurve),
    );
    _opacity = Tween<double>(begin: 0.78, end: 1.0).animate(
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
        builder: (_, _) => Transform.scale(
          scale: _scale.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: widget.glowIntensity),
                    blurRadius: widget.size * 1.2 * _scale.value,
                    spreadRadius: widget.size * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
