import 'package:first_flutter_app/shared/widgets/breathing_sparkle.dart';
import 'package:flutter/material.dart';

class SparkleCluster extends StatelessWidget {
  const SparkleCluster({
    required this.size,
    required this.color,
    super.key,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.25,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: size * 0.18,
            child: BreathingSparkle(
              color: color,
              size: size * 0.62,
              duration: const Duration(milliseconds: 4800),
              phaseOffset: 0.0,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: BreathingSparkle(
              color: color,
              size: size * 0.36,
              duration: const Duration(milliseconds: 5200),
              phaseOffset: 0.45,
            ),
          ),
          Positioned(
            right: size * 0.06,
            bottom: 0,
            child: BreathingSparkle(
              color: color,
              size: size * 0.22,
              duration: const Duration(milliseconds: 4400),
              phaseOffset: 0.78,
            ),
          ),
        ],
      ),
    );
  }
}
