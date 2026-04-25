// Re-export so existing imports of `FeedPost` from this widget file
// continue to resolve. The canonical entity now lives in the domain layer.
export 'package:first_flutter_app/features/feed/domain/entities/feed_post.dart'
    show FeedPost, FeedMediaType;
