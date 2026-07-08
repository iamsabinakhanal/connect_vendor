import 'package:flutter/material.dart';

class DemoChat {
  DemoChat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.color,
  });

  final String name;
  String lastMessage;
  String time;
  int unread;
  final Color color;
}
