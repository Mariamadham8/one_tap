import 'subject_model.dart';

class TaskModel {
  final String? id;
  final String title;
  final String? subjectId;
  SubjectModel subject;
  final int durationMinutes;
  final DateTime? dueDate;
  bool isDone;

  TaskModel({
    this.id,
    required this.title,
    this.subjectId,
    required this.subject,
    required this.durationMinutes,
    this.dueDate,
    this.isDone = false,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? subjectId,
    SubjectModel? subject,
    int? durationMinutes,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectId: subjectId ?? this.subjectId,
      subject: subject ?? this.subject,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subjectId': subjectId,
      'subject': subject.toMap(),
      'durationMinutes': durationMinutes,
      'dueDate': dueDate?.toIso8601String(),
      'isDone': isDone,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final subjectMap = map['subject'] as Map<String, dynamic>? ?? const {};

    return TaskModel(
      id: id,
      title: map['title'] as String? ?? 'Untitled task',
      subjectId: map['subjectId'] as String?,
      subject: SubjectModel.fromMap(subjectMap),
      durationMinutes: map['durationMinutes'] as int? ?? 25,
      dueDate: _parseDueDate(map['dueDate']),
      isDone: map['isDone'] as bool? ?? false,
    );
  }

  static DateTime? _parseDueDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

final List<TaskModel> globalTasks = [];
