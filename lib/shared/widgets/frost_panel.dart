import 'dart:ui';

import 'package:first_flutter_app/shared/theme/app_colors.dart';
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint ?? AppColors.bgDeep.withValues(alpha: 0.42),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.borderHairline,
              width: 0.5,
            ),
          ),
          child: padding != null ? Padding(padding: padding!, child: child) : child,
        ),
      ),
    );
  }
}
