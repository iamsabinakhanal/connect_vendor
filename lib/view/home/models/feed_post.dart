import 'package:flutter/material.dart';

class FeedPost {
  const FeedPost({
    required this.id,
    required this.vendorName,
    required this.vendorInitial,
    required this.communityName,
    required this.title,
    required this.description,
    required this.mediaIcons,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isLiked,
    required this.isSaved,
    required this.commentsList,
    required this.timeAgo,
  });

  final String id;
  final String vendorName;
  final String vendorInitial;
  final String communityName;
  final String title;
  final String description;
  final List<IconData> mediaIcons;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isSaved;
  final List<String> commentsList;
  final String timeAgo;

  FeedPost copyWith({
    String? id,
    String? vendorName,
    String? vendorInitial,
    String? communityName,
    String? title,
    String? description,
    List<IconData>? mediaIcons,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isSaved,
    List<String>? commentsList,
    String? timeAgo,
  }) {
    return FeedPost(
      id: id ?? this.id,
      vendorName: vendorName ?? this.vendorName,
      vendorInitial: vendorInitial ?? this.vendorInitial,
      communityName: communityName ?? this.communityName,
      title: title ?? this.title,
      description: description ?? this.description,
      mediaIcons: mediaIcons ?? this.mediaIcons,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      commentsList: commentsList ?? this.commentsList,
      timeAgo: timeAgo ?? this.timeAgo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vendorName': vendorName,
      'vendorInitial': vendorInitial,
      'communityName': communityName,
      'title': title,
      'description': description,
      'mediaIcons': mediaIcons.map((icon) => icon.codePoint).toList(),
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'commentsList': commentsList,
      'timeAgo': timeAgo,
    };
  }

  factory FeedPost.fromMap(Map<String, dynamic> map) {
    final dynamic rawMedia = map['mediaIcons'];
    final List<IconData> parsedIcons = rawMedia is List
        ? rawMedia
              .map((value) {
                if (value is int) {
                  return IconData(value, fontFamily: 'MaterialIcons');
                }
                return null;
              })
              .whereType<IconData>()
              .toList()
        : <IconData>[];

    final dynamic rawComments = map['commentsList'];
    final List<String> parsedComments = rawComments is List
        ? rawComments.map((value) => value.toString()).toList()
        : <String>[];

    return FeedPost(
      id: map['id']?.toString() ?? '',
      vendorName: map['vendorName']?.toString() ?? '',
      vendorInitial: map['vendorInitial']?.toString() ?? '',
      communityName: map['communityName']?.toString() ?? 'Public',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      mediaIcons: parsedIcons,
      likes: map['likes'] is int ? map['likes'] as int : 0,
      comments: map['comments'] is int ? map['comments'] as int : 0,
      shares: map['shares'] is int ? map['shares'] as int : 0,
      isLiked: map['isLiked'] == true,
      isSaved: map['isSaved'] == true,
      commentsList: parsedComments,
      timeAgo: map['timeAgo']?.toString() ?? 'Just now',
    );
  }
}
