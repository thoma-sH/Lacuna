import 'package:first_flutter_app/shared/widgets/glass_surface.dart';
import 'package:flutter/material.dart';

class FrostPanel extends StatelessWidget {
  const FrostPanel({
    required this.child,
    this.borderRadius = 16,
    this.blur = 14.0,
    this.tint,
    this.borderColor,
    this.padding,
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? tint;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      borderRadius: borderRadius,
      padding: padding,
      tintOverride: tint,
      child: child,
    );
  }
}
