import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:flutter/material.dart';

class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({required this.user, super.key});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockPosts.length,
        itemBuilder: (context, index) {
          final post = _mockPosts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [post.blobColor.withAlpha(220), post.blobColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      post.blobName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${post.author}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(post.caption),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18),
                          const SizedBox(width: 4),
                          Text(post.location),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border),
                          const SizedBox(width: 16),
                          const Icon(Icons.bookmark_border),
                          const SizedBox(width: 16),
                          const Icon(Icons.thumb_up_alt_outlined),
                          const SizedBox(width: 8),
                          const Icon(Icons.thumb_down_alt_outlined),
                          const Spacer(),
                          Text('${post.netScore} Anucal'),
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
        icon: const Icon(Icons.refresh),
        label: Text('Welcome @${user.username}'),
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
    caption: 'Rainy mood today. Quiet walk and thoughts.',
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
  });

  final String author;
  final String blobName;
  final String caption;
  final String location;
  final int netScore;
  final Color blobColor;
}
