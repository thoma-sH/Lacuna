import 'package:first_flutter_app/shared/theme/app_colors.dart';
import 'package:first_flutter_app/shared/theme/app_spacing.dart';
import 'package:first_flutter_app/shared/widgets/grain_overlay.dart';
import 'package:first_flutter_app/shared/widgets/scalloped_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostCapturePage extends StatefulWidget {
  const PostCapturePage({super.key});

  @override
  State<PostCapturePage> createState() => _PostCapturePageState();
}

class _PostCapturePageState extends State<PostCapturePage> {
  int? _selectedAlbum;
  final _captionController = TextEditingController();
  bool _locationTagged = false;

  static const _albums = <_AlbumOption>[
    _AlbumOption(name: 'Beach', color: Color(0xFF4F6B8A)),
    _AlbumOption(name: 'Concerts', color: Color(0xFF7E5A8C)),
    _AlbumOption(name: 'Vibing', color: Color(0xFF4A5568)),
    _AlbumOption(name: 'School', color: Color(0xFF6B4F8A)),
    _AlbumOption(name: 'Sad', color: Color(0xFF3A3760)),
    _AlbumOption(name: 'Roadtrip', color: Color(0xFF5C7A56)),
    _AlbumOption(name: 'Coffee', color: Color(0xFF7A5C3A)),
    _AlbumOption(name: 'Sunsets', color: Color(0xFF8C4A3A)),
  ];

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        _selectedAlbum != null ? _albums[_selectedAlbum!].color : null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: GrainOverlay()),
          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _PageHeader(),
                const SizedBox(height: AppSpacing.xl),
                _CameraBlock(selectedColor: selectedColor),
                const SizedBox(height: AppSpacing.xxl),
                _SectionLabel(label: 'post to album'),
                const SizedBox(height: AppSpacing.md),
                _AlbumPicker(
                  albums: _albums,
                  selectedIndex: _selectedAlbum,
                  onSelect: (i) {
                    HapticFeedback.lightImpact();
                    setState(
                      () => _selectedAlbum = _selectedAlbum == i ? null : i,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                _SectionLabel(label: 'caption'),
                const SizedBox(height: AppSpacing.md),
                _CaptionField(controller: _captionController),
                const SizedBox(height: AppSpacing.xl),
                _LocationRow(
                  tagged: _locationTagged,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _locationTagged = !_locationTagged);
                  },
                ),
                const SizedBox(height: AppSpacing.xxxl),
                _PostButton(
                  enabled: _selectedAlbum != null,
                  selectedColor: selectedColor,
                  onPost: () {
                    HapticFeedback.mediumImpact();
                  },
                ),
                const SizedBox(height: AppSpacing.huge + AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        0,
      ),
      child: Row(
        children: [
          Text(
            'new post',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w300,
              letterSpacing: -0.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            PhosphorIconsLight.plus,
            color: AppColors.accent,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _CameraBlock extends StatelessWidget {
  const _CameraBlock({required this.selectedColor});

  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.xl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.2, -0.3),
                    radius: 1.2,
                    colors: [
                      selectedColor != null
                          ? Color.lerp(
                                selectedColor,
                                Colors.black,
                                0.4,
                              ) ??
                              AppColors.surface2
                          : AppColors.surface2,
                      AppColors.bgDeep,
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScallopedOutlineButton(
                      onTap: () => HapticFeedback.lightImpact(),
                      size: 72,
                      borderColor: selectedColor ?? AppColors.accent,
                      child: Icon(
                        PhosphorIconsLight.camera,
                        color: selectedColor ?? AppColors.accent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'tap to open camera',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                            letterSpacing: 0.3,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'photo or video up to 60s',
                      style:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textDisabled,
                            fontSize: 10,
                          ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

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

class _AlbumPicker extends StatelessWidget {
  const _AlbumPicker({
    required this.albums,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<_AlbumOption> albums;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: albums.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final isSelected = selectedIndex == i;
          return _AlbumChip(
            album: albums[i],
            isSelected: isSelected,
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
}

class _AlbumChip extends StatelessWidget {
  const _AlbumChip({
    required this.album,
    required this.isSelected,
    required this.onTap,
  });

  final _AlbumOption album;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? album.color.withValues(alpha: 0.25)
              : AppColors.surface1,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(
            color: isSelected
                ? album.color.withValues(alpha: 0.7)
                : AppColors.borderSubtle,
            width: isSelected ? 1.0 : 0.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: album.color.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: album.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              album.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontWeight:
                    isSelected ? FontWeight.w500 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptionField extends StatelessWidget {
  const _CaptionField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(color: AppColors.borderSubtle, width: 0.5),
        ),
        child: TextField(
          controller: controller,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: 'optional caption…',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textDisabled,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.tagged, required this.onTap});

  final bool tagged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tagged
                    ? AppColors.accentDeep.withValues(alpha: 0.4)
                    : AppColors.surface1,
                shape: BoxShape.circle,
                border: Border.all(
                  color: tagged ? AppColors.accent : AppColors.borderSubtle,
                  width: 0.5,
                ),
              ),
              child: Icon(
                tagged
                    ? PhosphorIconsFill.mapPin
                    : PhosphorIconsLight.mapPin,
                color: tagged ? AppColors.accent : AppColors.textTertiary,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tagged ? 'location tagged' : 'tag location',
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: tagged
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (tagged)
                    Text(
                      'tap to remove',
                      style:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 10,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostButton extends StatelessWidget {
  const _PostButton({
    required this.enabled,
    required this.selectedColor,
    required this.onPost,
  });

  final bool enabled;
  final Color? selectedColor;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    final activeColor = selectedColor ?? AppColors.accent;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: GestureDetector(
        onTap: enabled ? onPost : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 52,
          decoration: BoxDecoration(
            color: enabled ? activeColor : AppColors.surface1,
            borderRadius: BorderRadius.circular(AppSpacing.xl),
            border: Border.all(
              color: enabled
                  ? activeColor.withValues(alpha: 0.4)
                  : AppColors.borderSubtle,
              width: 0.5,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIconsLight.paperPlaneTilt,
                color: enabled ? Colors.white : AppColors.textDisabled,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                enabled ? 'post' : 'pick an album first',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: enabled ? Colors.white : AppColors.textDisabled,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlbumOption {
  const _AlbumOption({required this.name, required this.color});

  final String name;
  final Color color;
}
