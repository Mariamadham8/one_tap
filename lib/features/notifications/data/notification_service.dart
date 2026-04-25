import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/app_notification_model.dart';
import '../../../core/models/task_model.dart';
import '../../../core/models/user_activity_model.dart';

class NotificationService {
  static const Set<int> _milestones = {3, 7, 14, 30, 60, 100};

  String _userScopedKey(String suffix) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    return 'notifications_${uid}_$suffix';
  }

  Future<List<AppNotificationModel>> fetchNotifications() async {
    await globalUserActivity.syncWithCurrentUser();

    final now = DateTime.now();
    final dateKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final streak = globalUserActivity.calculateStreak();
    final totalTasks = globalTasks.length;
    final completedTasks = globalTasks.where((task) => task.isDone).length;
    final pendingTasks = totalTasks - completedTasks;
    final overdueTasksCount = globalTasks
      .where((task) => !task.isDone && task.dueDate != null)
      .where((task) => task.dueDate!.isBefore(now))
      .length;

    final generated = <AppNotificationModel>[];

    if (streak > 0) {
      generated.add(
        AppNotificationModel(
          id: 'streak_$dateKey',
          title: 'Streak Alert',
          message:
              'Great consistency! You are on a $streak-day study streak. Keep it up.',
          type: AppNotificationType.streakAlert,
          createdAt: DateTime(now.year, now.month, now.day, 8, 0),
        ),
      );
    }

    if (_milestones.contains(streak)) {
      generated.add(
        AppNotificationModel(
          id: 'milestone_${streak}_$dateKey',
          title: 'Milestone',
          message:
              'Amazing work! You reached a $streak-day streak milestone. Keep your momentum.',
          type: AppNotificationType.milestone,
          createdAt: DateTime(now.year, now.month, now.day, 9, 0),
        ),
      );
    }

    if (pendingTasks > 0) {
      generated.add(
        AppNotificationModel(
          id: 'task_reminder_$dateKey',
          title: 'Task Reminder',
          message:
              'You still have $pendingTasks task${pendingTasks == 1 ? '' : 's'} pending today.',
          type: AppNotificationType.taskReminder,
          createdAt: DateTime(now.year, now.month, now.day, 14, 0),
        ),
      );
    }

    if (totalTasks > 0 && completedTasks == totalTasks) {
      generated.add(
        AppNotificationModel(
          id: 'daily_goal_$dateKey',
          title: 'Daily Goal',
          message:
              'Fantastic! You completed all tasks for today. Time to recharge.',
          type: AppNotificationType.dailyGoal,
          createdAt: DateTime(now.year, now.month, now.day, 21, 0),
        ),
      );
    }

    if (overdueTasksCount > 0) {
      generated.add(
        AppNotificationModel(
          id: 'overdue_$dateKey',
          title: 'Overdue Tasks',
          message:
              'You have $overdueTasksCount overdue task${overdueTasksCount == 1 ? '' : 's'} that need attention.',
          type: AppNotificationType.overdueTasks,
          createdAt: DateTime(now.year, now.month, now.day, 20, 0),
        ),
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final readIds = prefs.getStringList(_userScopedKey('read')) ?? const [];
    final deletedIds = prefs.getStringList(_userScopedKey('deleted')) ?? const [];

    final notifications = generated
        .where((item) => !deletedIds.contains(item.id))
        .map((item) => item.copyWith(isRead: readIds.contains(item.id)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return notifications;
  }

  Future<void> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _userScopedKey('read');
    final current = prefs.getStringList(key) ?? <String>[];

    if (!current.contains(notificationId)) {
      current.add(notificationId);
      await prefs.setStringList(key, current);
    }
  }

  Future<void> markAllAsRead(List<String> notificationIds) async {
    if (notificationIds.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final key = _userScopedKey('read');
    final current = prefs.getStringList(key) ?? <String>[];

    for (final id in notificationIds) {
      if (!current.contains(id)) {
        current.add(id);
      }
    }

    await prefs.setStringList(key, current);
  }

  Future<void> deleteNotification(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _userScopedKey('deleted');
    final current = prefs.getStringList(key) ?? <String>[];

    if (!current.contains(notificationId)) {
      current.add(notificationId);
      await prefs.setStringList(key, current);
    }
  }
}
