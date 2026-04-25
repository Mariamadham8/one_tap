import 'package:flutter/material.dart';

class SubjectModel {
  final String? id;
  final String title;
  final String emoji;
  final Color color;
  final String taskCount;
  final double progress;

  SubjectModel({
    this.id,
    required this.title,
    required this.emoji,
    required this.color,
    this.taskCount = '0 tasks',
    this.progress = 0.0,
  });

  SubjectModel copyWith({
    String? id,
    String? title,
    String? emoji,
    Color? color,
    String? taskCount,
    double? progress,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      taskCount: taskCount ?? this.taskCount,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'emoji': emoji,
      'colorValue': color.value,
      'taskCount': taskCount,
      'progress': progress,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return SubjectModel(
      id: id,
      title: map['title'] as String? ?? 'Untitled',
      emoji: map['emoji'] as String? ?? '📘',
      color: Color(map['colorValue'] as int? ?? const Color(0xFFa2c8f2).value),
      taskCount: map['taskCount'] as String? ?? '0 tasks',
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

final List<SubjectModel> globalSubjects = [];
