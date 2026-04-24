import 'package:first_flutter_app/shared/theme/app_colors.dart';
import 'package:first_flutter_app/shared/theme/app_motion.dart';
import 'package:first_flutter_app/shared/theme/app_spacing.dart';
import 'package:first_flutter_app/shared/theme/lacuna_theme.dart';
import 'package:first_flutter_app/shared/theme/lacuna_theme_provider.dart';
import 'package:first_flutter_app/shared/theme/theme_variants.dart';
import 'package:first_flutter_app/shared/widgets/scalloped_avatar.dart';
import 'package:first_flutter_app/shared/widgets/tap_bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            SliverToBoxAdapter(child: _SectionLabel('appearance')),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            const SliverToBoxAdapter(child: _ThemePicker()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.huge + AppSpacing.xl),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          TapBounce(
            scaleTo: 0.85,
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              child: Icon(
                PhosphorIconsLight.arrowLeft,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'settings',
            style: t.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textTertiary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LacunaThemeVariant>(
      valueListenable: lacunaThemeNotifier,
      builder: (_, current, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.95,
            children: [
              for (final variant in LacunaThemeVariant.values)
                _ThemeTile(
                  theme: themeFor(variant),
                  isActive: current == variant,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    lacunaThemeNotifier.value = variant;
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.theme,
    required this.isActive,
    required this.onTap,
  });

  final LacunaTheme theme;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = theme.palette;
    final t = Theme.of(context).textTheme;
    return TapBounce(
      scaleTo: 0.94,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.short,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: p.bgBase,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(
            color: isActive
                ? p.accent
                : AppColors.borderSubtle,
            width: isActive ? 1.5 : 0.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: p.accent.withValues(alpha: 0.4),
                    blurRadius: 18,
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.md),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        p.accent.withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _ScallopPreview(theme: theme),
                        const Spacer(),
                        if (isActive)
                          Icon(
                            PhosphorIconsFill.check,
                            color: p.accent,
                            size: 16,
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      theme.displayName.toLowerCase(),
                      style: GoogleFonts.getFont(
                        theme.fontName,
                        textStyle: TextStyle(
                          color: p.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.3,
                          height: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      theme.tagline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelSmall?.copyWith(
                        color: p.textTertiary,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _Swatch(color: p.accent),
                        const SizedBox(width: 4),
                        _Swatch(color: p.surface2),
                        const SizedBox(width: 4),
                        _Swatch(color: p.textPrimary),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScallopPreview extends StatelessWidget {
  const _ScallopPreview({required this.theme});

  final LacunaTheme theme;

  @override
  Widget build(BuildContext context) {
    final p = theme.palette;
    return CustomPaint(
      size: const Size(36, 36),
      painter: _PreviewPainter(
        accent: p.accent,
        glow: p.accent.withValues(alpha: 0.4),
        lobes: theme.scallop.lobes,
        depth: theme.scallop.depth,
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  _PreviewPainter({
    required this.accent,
    required this.glow,
    required this.lobes,
    required this.depth,
  });

  final Color accent;
  final Color glow;
  final int lobes;
  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = buildScallopPath(size, lobes: lobes, depth: depth);
    canvas.drawPath(
      path,
      Paint()
        ..color = glow
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(_PreviewPainter old) =>
      old.accent != accent ||
      old.lobes != lobes ||
      old.depth != depth;
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
    );
  }
}
