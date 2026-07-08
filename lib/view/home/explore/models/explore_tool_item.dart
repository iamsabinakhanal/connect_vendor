import 'package:flutter/material.dart';

class ExploreToolItem {
  ExploreToolItem({
    required this.category,
    required this.title,
    required this.seller,
    required this.likes,
    required this.price,
    required this.icon,
    required this.colors,
  });

  final String category;
  final String title;
  final String seller;
  final String likes;
  final String price;
  final IconData icon;
  final List<Color> colors;
}
