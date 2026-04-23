import 'package:flutter/material.dart';

class FeedPost {
  const FeedPost({
    required this.author,
    required this.blobName,
    required this.themeDescription,
    required this.caption,
    required this.location,
    required this.timeAgo,
    required this.blobColor,
    required this.aspectRatio,
    required this.fitsCount,
    required this.doesntFitCount,
    required this.commentCount,
    required this.imageUrl,
  });

  final String author;
  final String blobName;
  final String themeDescription;
  final String caption;
  final String location;
  final String timeAgo;
  final Color blobColor;
  final double aspectRatio;
  final int fitsCount;
  final int doesntFitCount;
  final int commentCount;
  final String imageUrl;
}
