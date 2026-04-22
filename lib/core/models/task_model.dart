import 'subject_model.dart';

class TaskModel {
  final String title;
  SubjectModel subject;
  final int durationMinutes;
  bool isDone;

  TaskModel({
    required this.title,
    required this.subject,
    required this.durationMinutes,
    this.isDone = false,
  });
}

final List<TaskModel> globalTasks = [];
