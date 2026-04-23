import 'package:first_flutter_app/shared/theme/app_colors.dart';
import 'package:first_flutter_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class RailItem {
  const RailItem({required this.name, required this.color});

  final String name;
  final Color color;
}

class FollowerRail extends StatelessWidget {
  const FollowerRail({required this.items, super.key});

  final List<RailItem> items;

  static const double _height = 92;
  static const double _avatarSize = 56;
  static const double _ringWidth = 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) => _RailEntry(item: items[index]),
      ),
    );
  }
}

class _RailEntry extends StatelessWidget {
  const _RailEntry({required this.item});

  final RailItem item;

  @override
  Widget build(BuildContext context) {
    final initial = item.name.isEmpty ? '?' : item.name[0].toUpperCase();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: FollowerRail._avatarSize + FollowerRail._ringWidth * 4,
          height: FollowerRail._avatarSize + FollowerRail._ringWidth * 4,
          padding: const EdgeInsets.all(FollowerRail._ringWidth),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: item.color.withValues(alpha: 0.85),
              width: FollowerRail._ringWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: item.color.withValues(alpha: 0.25),
                blurRadius: 14,
                spreadRadius: -4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.4),
                colors: [
                  Color.lerp(item.color, Colors.white, 0.18) ?? item.color,
                  Color.lerp(item.color, Colors.black, 0.35) ?? item.color,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          item.name,
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
