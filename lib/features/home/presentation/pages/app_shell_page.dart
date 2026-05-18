import 'package:first_flutter_app/features/activity/presentation/pages/traces_page.dart';
import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/explore/presentation/pages/explore_page.dart';
import 'package:first_flutter_app/features/feed/presentation/pages/home_feed_page.dart';
import 'package:first_flutter_app/features/home/presentation/widgets/lacuna_nav_bar.dart';
import 'package:first_flutter_app/features/post/presentation/pages/post_capture_page.dart';
import 'package:first_flutter_app/features/profile/presentation/pages/profile_page.dart';
import 'package:first_flutter_app/shared/theme/app_colors.dart';
import 'package:first_flutter_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Window-width breakpoint where the bottom nav becomes a left rail.
/// Per `flutter-build-responsive-layout`, decisions are based on available
/// app-window space, not device classification.
const double _expandedShellMinWidth = 900;

class AppShellPage extends StatefulWidget {
  const AppShellPage({required this.user, super.key});

  final AppUser user;

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeFeedPage(user: widget.user),
      const ExplorePage(),
      const PostCapturePage(),
      const TracesPage(),
      ProfilePage(user: widget.user),
    ];
  }

  void _select(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= _expandedShellMinWidth;
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: !isExpanded,
          body: isExpanded
              ? _ExpandedShell(
                  pages: _pages,
                  currentIndex: _currentIndex,
                  onSelect: _select,
                )
              : _CompactShell(
                  pages: _pages,
                  currentIndex: _currentIndex,
                  onSelect: _select,
                ),
        );
      },
    );
  }
}

class _CompactShell extends StatelessWidget {
  const _CompactShell({
    required this.pages,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<Widget> pages;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IndexedStack(index: currentIndex, children: pages),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: LacunaNavBar(
            currentIndex: currentIndex,
            onTap: onSelect,
          ),
        ),
      ],
    );
  }
}

class _ExpandedShell extends StatelessWidget {
  const _ExpandedShell({
    required this.pages,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<Widget> pages;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  static const _railItems = [
    _RailItem(
      icon: PhosphorIconsLight.house,
      activeIcon: PhosphorIconsFill.house,
      label: 'Home',
    ),
    _RailItem(
      icon: PhosphorIconsLight.compassRose,
      activeIcon: PhosphorIconsFill.compassRose,
      label: 'Explore',
    ),
    _RailItem(
      icon: PhosphorIconsLight.plus,
      activeIcon: PhosphorIconsFill.plusCircle,
      label: 'Post',
      isPrimary: true,
    ),
    _RailItem(
      icon: PhosphorIconsLight.heart,
      activeIcon: PhosphorIconsFill.heart,
      label: 'Activity',
    ),
    _RailItem(
      icon: PhosphorIconsLight.user,
      activeIcon: PhosphorIconsFill.user,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          _LacunaRail(
            items: _railItems,
            currentIndex: currentIndex,
            onSelect: onSelect,
          ),
          const VerticalDivider(width: 1, thickness: 0.5),
          Expanded(child: IndexedStack(index: currentIndex, children: pages)),
        ],
      ),
    );
  }
}

class _LacunaRail extends StatelessWidget {
  const _LacunaRail({
    required this.items,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<_RailItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              child: Text(
                'lacuna',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: _RailTile(
                  item: items[i],
                  isActive: currentIndex == i,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RailTile extends StatelessWidget {
  const _RailTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _RailItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = isActive
        ? (item.isPrimary ? AppColors.accent : AppColors.textPrimary)
        : AppColors.textTertiary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              Icon(
                isActive ? item.activeIcon : item.icon,
                size: 22,
                color: color,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                item.label,
                style: textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailItem {
  const _RailItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isPrimary = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isPrimary;
}
