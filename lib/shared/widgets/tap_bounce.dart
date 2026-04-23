import 'package:first_flutter_app/shared/theme/app_motion.dart';
import 'package:flutter/material.dart';

class TapBounce extends StatefulWidget {
  const TapBounce({
    required this.onTap,
    required this.child,
    this.scaleTo = 0.92,
    this.behavior = HitTestBehavior.opaque,
    super.key,
  });

  final VoidCallback onTap;
  final Widget child;
  final double scaleTo;
  final HitTestBehavior behavior;

  @override
  State<TapBounce> createState() => _TapBounceState();
}

class _TapBounceState extends State<TapBounce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: AppMotion.micro,
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scaleTo).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}
