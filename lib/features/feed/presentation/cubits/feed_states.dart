import 'package:first_flutter_app/features/feed/domain/entities/feed_post.dart';

sealed class FeedState {
  const FeedState();
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  const FeedLoaded({
    required this.posts,
    required this.hasMore,
    required this.isLoadingMore,
    required this.cursor,
  });

  final List<FeedPost> posts;
  final bool hasMore;
  final bool isLoadingMore;
  final DateTime? cursor;

  FeedLoaded copyWith({
    List<FeedPost>? posts,
    bool? hasMore,
    bool? isLoadingMore,
    DateTime? cursor,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      cursor: cursor ?? this.cursor,
    );
  }
}

class FeedFailure extends FeedState {
  const FeedFailure(this.message);
  final String message;
}
