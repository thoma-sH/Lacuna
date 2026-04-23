import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _slateBg = Color(0xFF0F1216);
const _slateSurface = Color(0xFF161B21);
const _slateText = Color(0xFFE5E9EE);
const _slateMuted = Color(0xFF8A95A4);
const _slateFaint = Color(0xFF5A6573);

const _spaceXs = 4.0;
const _spaceSm = 8.0;
const _spaceMd = 16.0;
const _spaceLg = 24.0;
const _spaceXl = 32.0;
const _spaceXxl = 48.0;

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.user, super.key});

  final AppUser user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _anucalLabel = 'Anucal';
  bool _editingLabel = false;
  late final TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: _anucalLabel);
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _saveLabel() {
    final trimmed = _labelController.text.trim();
    setState(() {
      if (trimmed.isNotEmpty) _anucalLabel = trimmed;
      _editingLabel = false;
    });
  }

  void _startEditingLabel() {
    _labelController.text = _anucalLabel;
    setState(() => _editingLabel = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _slateBg,
      body: SafeArea(
        bottom: false,
        child: ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black],
            stops: [0.0, 0.06],
          ).createShader(rect),
          blendMode: BlendMode.dstIn,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _TopBar(
                  onLogout: () => context.read<AuthCubit>().logout(),
                ),
              ),
              SliverToBoxAdapter(
                child: _IdentityBlock(username: widget.user.username),
              ),
              SliverToBoxAdapter(
                child: _StatsRow(
                  anucalLabel: _anucalLabel,
                  onTapAnucal: _startEditingLabel,
                ),
              ),
              if (_editingLabel)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      _spaceLg,
                      _spaceMd,
                      _spaceLg,
                      0,
                    ),
                    child: TextField(
                      controller: _labelController,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _saveLabel(),
                      onTapOutside: (_) => _saveLabel(),
                      style: const TextStyle(color: _slateText, fontSize: 14),
                      cursorColor: _slateText,
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: _slateSurface,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  _spaceLg,
                  _spaceXxl,
                  _spaceLg,
                  _spaceMd,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'lacuna',
                    style: TextStyle(
                      color: _slateFaint,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.5,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  _spaceLg,
                  0,
                  _spaceLg,
                  _spaceXxl,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: _spaceMd,
                        crossAxisSpacing: _spaceMd,
                      ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _BlobTile(blob: _blobPalette[index]),
                    childCount: _blobPalette.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _blobPalette = <_Blob>[
  _Blob('Saved', Color(0xFF4A5568)),
  _Blob('Beach', Color(0xFFB8956A)),
  _Blob('Concerts', Color(0xFF7E5A8C)),
  _Blob('Vibing', Color(0xFFB85F47)),
  _Blob('School', Color(0xFF6B7A8F)),
  _Blob('Sad', Color(0xFF2D3748)),
  _Blob('Roadtrip', Color(0xFF6B8E6B)),
  _Blob('Coffee', Color(0xFFC4B89E)),
  _Blob('Sunsets', Color(0xFFD4A5A5)),
];

class _Blob {
  const _Blob(this.name, this.color);
  final String name;
  final Color color;
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_spaceSm, _spaceSm, _spaceSm, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onLogout,
            splashRadius: 20,
            icon: const Icon(
              Icons.logout_rounded,
              color: _slateFaint,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityBlock extends StatelessWidget {
  const _IdentityBlock({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_spaceLg, _spaceLg, _spaceLg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: const TextStyle(
              color: _slateText,
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: _spaceXs),
          Text(
            '@${username.toLowerCase()}',
            style: const TextStyle(
              color: _slateFaint,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.anucalLabel, required this.onTapAnucal});

  final String anucalLabel;
  final VoidCallback onTapAnucal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_spaceLg, _spaceXl, _spaceLg, 0),
      child: Row(
        children: [
          const _StatItem(value: '244', label: 'followers'),
          const SizedBox(width: _spaceXl),
          const _StatItem(value: '181', label: 'following'),
          const SizedBox(width: _spaceXl),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapAnucal,
            child: _StatItem(
              value: '3,084',
              label: anucalLabel.toLowerCase(),
              editable: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    this.editable = false,
  });

  final String value;
  final String label;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _slateText,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: _spaceXs),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _slateMuted,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
            if (editable) ...[
              const SizedBox(width: _spaceXs),
              const Icon(Icons.edit_rounded, size: 10, color: _slateFaint),
            ],
          ],
        ),
      ],
    );
  }
}

class _BlobTile extends StatelessWidget {
  const _BlobTile({required this.blob});

  final _Blob blob;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 1.1,
            colors: [
              Color.lerp(blob.color, Colors.white, 0.18) ?? blob.color,
              blob.color,
              Color.lerp(blob.color, Colors.black, 0.30) ?? blob.color,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Text(
            blob.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
