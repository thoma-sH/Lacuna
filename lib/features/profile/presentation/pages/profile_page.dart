import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    final blobSizes = [90.0, 70.0, 120.0, 62.0, 82.0, 74.0];
    final blobColors = [
      Colors.deepPurpleAccent,
      Colors.pinkAccent,
      Colors.blueAccent,
      Colors.teal,
      Colors.orangeAccent,
      Colors.indigoAccent,
    ];

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.username,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Followers', value: '244'),
                _StatItem(label: 'Following', value: '181'),
                GestureDetector(
                  onTap: () {
                    _labelController.text = _anucalLabel;
                    setState(() => _editingLabel = true);
                  },
                  child: _AnucalStatItem(
                    label: _anucalLabel,
                    value: '3,084',
                  ),
                ),
              ],
            ),
            if (_editingLabel) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _labelController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _saveLabel(),
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Your lacuna',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(blobSizes.length, (index) {
                  return GestureDetector(
                    onLongPress: () {},
                    child: Container(
                      width: blobSizes[index],
                      height: blobSizes[index],
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            blobColors[index],
                            blobColors[index].withAlpha(90),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Blob ${index + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _AnucalStatItem extends StatelessWidget {
  const _AnucalStatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.edit_rounded, size: 11, color: colorScheme.primary),
          ],
        ),
      ],
    );
  }
}
