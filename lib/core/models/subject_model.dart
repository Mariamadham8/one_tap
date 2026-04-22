import 'package:flutter/material.dart';

class SubjectModel {
  final String title;
  final String emoji;
  final Color color;
  final String taskCount;
  final double progress;

  SubjectModel({
    required this.title,
    required this.emoji,
    required this.color,
    this.taskCount = '0 tasks',
    this.progress = 0.0,
  });
}

final List<SubjectModel> globalSubjects = [];
