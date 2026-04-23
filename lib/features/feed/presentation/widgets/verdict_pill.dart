import 'package:first_flutter_app/shared/theme/app_colors.dart';
import 'package:first_flutter_app/shared/theme/app_motion.dart';
import 'package:first_flutter_app/shared/theme/app_spacing.dart';
import 'package:first_flutter_app/shared/widgets/tap_bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum FitVote { none, fits, doesntFit }

class VerdictPill extends StatelessWidget {
  const VerdictPill({
    required this.vote,
    required this.fitsCount,
    required this.doesntFitCount,
    required this.themeColor,
    required this.onFits,
    required this.onDoesntFit,
    super.key,
  });

  final FitVote vote;
  final int fitsCount;
  final int doesntFitCount;
  final Color themeColor;
  final VoidCallback onFits;
  final VoidCallback onDoesntFit;

  int get _total => fitsCount + doesntFitCount;
  int get _percentFits =>
      _total == 0 ? 0 : ((fitsCount / _total) * 100).round();

  @override
  Widget build(BuildContext context) {
    final fitsActive = vote == FitVote.fits;
    final noActive = vote == FitVote.doesntFit;
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.borderHairline, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Side(
            icon: noActive
                ? PhosphorIconsFill.x
                : PhosphorIconsLight.x,
            active: noActive,
            activeColor: AppColors.downvote,
            onTap: () {
              HapticFeedback.lightImpact();
              onDoesntFit();
            },
          ),
          _CenterReadout(
            percentFits: _percentFits,
            total: _total,
            themeColor: themeColor,
            vote: vote,
          ),
          _Side(
            icon: fitsActive
                ? PhosphorIconsFill.check
                : PhosphorIconsLight.check,
            active: fitsActive,
            activeColor: themeColor,
            onTap: () {
              HapticFeedback.mediumImpact();
              onFits();
            },
          ),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapBounce(
      scaleTo: 0.8,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.short,
        curve: Curves.easeOutCubic,
        width: 44,
        height: 38,
        decoration: BoxDecoration(
          color: active
              ? activeColor.withValues(alpha: 0.18)
              : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.45),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: AppMotion.short,
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            icon,
            key: ValueKey(active),
            color: active ? activeColor : AppColors.textSecondary,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _CenterReadout extends StatelessWidget {
  const _CenterReadout({
    required this.percentFits,
    required this.total,
    required this.themeColor,
    required this.vote,
  });

  final int percentFits;
  final int total;
  final Color themeColor;
  final FitVote vote;

  @override
  Widget build(BuildContext context) {
    final color = switch (vote) {
      FitVote.fits => themeColor,
      FitVote.doesntFit => AppColors.downvote,
      FitVote.none => AppColors.textSecondary,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: AppMotion.short,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              height: 1.0,
            ),
            child: Text(total == 0 ? '—' : '$percentFits%'),
          ),
          const SizedBox(height: 2),
          Text(
            'fits',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 8.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
