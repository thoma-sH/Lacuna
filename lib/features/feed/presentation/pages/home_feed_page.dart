import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:flutter/material.dart';

class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({required this.user, super.key});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _mockPosts.length,
        itemBuilder: (context, index) {
          final post = _mockPosts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        post.blobColor.withAlpha(220),
                        post.blobColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      post.blobName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        post.caption,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.location,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.favorite_border_rounded,
                              size: 20, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 14),
                          Icon(Icons.bookmark_border_rounded,
                              size: 20, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 14),
                          Icon(Icons.thumb_up_alt_outlined,
                              size: 20, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Icon(Icons.thumb_down_alt_outlined,
                              size: 20, color: colorScheme.onSurfaceVariant),
                          const Spacer(),
                          Text(
                            '${post.netScore} ${post.anucalLabel}',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.refresh_rounded),
        label: Text('Welcome ${user.username}'),
      ),
    );
  }
}

final _mockPosts = <_FeedPost>[
  _FeedPost(
    author: 'sarah',
    blobName: 'Vibing',
    caption: 'Golden hour with friends and city lights.',
    location: 'Rogers, Arkansas',
    netScore: 241,
    blobColor: Colors.pinkAccent,
  ),
  _FeedPost(
    author: 'milo',
    blobName: 'Beach',
    caption: 'Short surf clip and some waves to clear the mind.',
    location: 'Santa Monica, California',
    netScore: 189,
    blobColor: Colors.lightBlue,
  ),
  _FeedPost(
    author: 'ivy',
    blobName: 'Sad',
    caption: 'Rainy mood today. Quiet walk and audio thoughts.',
    location: 'Seattle, Washington',
    netScore: 94,
    blobColor: Colors.deepPurple,
  ),
];

class _FeedPost {
  const _FeedPost({
    required this.author,
    required this.blobName,
    required this.caption,
    required this.location,
    required this.netScore,
    required this.blobColor,
    this.anucalLabel = 'Anucal',
  });

  final String author;
  final String blobName;
  final String caption;
  final String location;
  final int netScore;
  final Color blobColor;
  final String anucalLabel;
}
