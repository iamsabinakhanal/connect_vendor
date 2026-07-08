import 'package:flutter/material.dart';

class CommunityPost {
  CommunityPost({
    required this.id,
    required this.category,
    required this.categoryIcon,
    required this.title,
    required this.description,
    required this.image,
    required this.views,
    required this.likes,
    required this.comments,
    required this.communityName,
    required this.communityInitial,
    required this.communityColor,
  });

  final int id;
  final String category;
  final IconData categoryIcon;
  final String title;
  final String description;
  final IconData image;
  final String views;
  final int likes;
  final int comments;
  final String communityName;
  final String communityInitial;
  final Color communityColor;
}
