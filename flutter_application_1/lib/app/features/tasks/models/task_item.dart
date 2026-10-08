import 'package:flutter/material.dart';

class TaskItem {
  TaskItem({
    required this.title,
    required this.details,
    required this.time,
    required this.category,
    required this.color,
    required this.icon,
    this.isDone = false,
  });

  final String title;
  final String details;
  final String time;
  final String category;
  final Color color;
  final IconData icon;
  bool isDone;
}
