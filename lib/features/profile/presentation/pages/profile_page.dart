import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.user, super.key});

  final AppUser user;

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

    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.username}'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _StatItem(label: 'Followers', value: '244'),
                _StatItem(label: 'Following', value: '181'),
                _StatItem(label: 'Anucal', value: '3,084'),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Rename Anucal label',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                hintText: 'e.g. booyas',
              ),
            ),
            const SizedBox(height: 16),
            Text('Your blobs', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
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
                          colors: [blobColors[index], blobColors[index].withAlpha(90)],
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
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label),
      ],
    );
  }
}
