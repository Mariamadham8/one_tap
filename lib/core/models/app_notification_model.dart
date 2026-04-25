enum AppNotificationType {
  streakAlert,
  milestone,
  taskReminder,
  dailyGoal,
  overdueTasks,
}

class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final AppNotificationType type;
  final DateTime createdAt;
  final bool isRead;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    AppNotificationType? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
