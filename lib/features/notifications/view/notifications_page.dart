import 'package:flutter/material.dart';

import '../../../core/models/app_notification_model.dart';
import '../data/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;
  List<AppNotificationModel> _notifications = [];

  int get _unreadCount => _notifications.where((item) => !item.isRead).length;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    final notifications = await _notificationService.fetchNotifications();
    if (!mounted) return;

    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  Future<void> _openNotification(AppNotificationModel notification) async {
    if (!notification.isRead) {
      await _notificationService.markAsRead(notification.id);
    }

    if (!mounted) return;

    setState(() {
      _notifications = _notifications
          .map(
            (item) =>
                item.id == notification.id ? item.copyWith(isRead: true) : item,
          )
          .toList();
    });
  }

  Future<void> _markAllAsRead() async {
    final unreadIds = _notifications
        .where((item) => !item.isRead)
        .map((item) => item.id)
        .toList();

    await _notificationService.markAllAsRead(unreadIds);
    if (!mounted) return;

    setState(() {
      _notifications = _notifications
          .map((item) => item.copyWith(isRead: true))
          .toList();
    });
  }

  Future<void> _deleteNotification(AppNotificationModel notification) async {
    await _notificationService.deleteNotification(notification.id);
    if (!mounted) return;

    setState(() {
      _notifications.removeWhere((item) => item.id == notification.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Color(0xFF4C9EEB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF4C9EEB),
        onRefresh: _loadNotifications,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4C9EEB)),
              )
            : _notifications.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 120),
                  Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF75B9F0),
                    size: 64,
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'No notifications right now',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Center(
                    child: Text(
                      'You are all caught up.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  final visual = _visualStyle(notification.type);

                  return Dismissible(
                    key: ValueKey(notification.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    onDismissed: (_) => _deleteNotification(notification),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _openNotification(notification),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: notification.isRead
                              ? Colors.white
                              : const Color(0xFF4C9EEB).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: notification.isRead
                                ? const Color(0xFFE5E7EB)
                                : const Color(0xFF4C9EEB).withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: visual.color.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                visual.icon,
                                color: visual.color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notification.title,
                                          style: TextStyle(
                                            color: const Color(0xFF1E293B),
                                            fontWeight: notification.isRead
                                                ? FontWeight.w600
                                                : FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (!notification.isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF4C9EEB),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.message,
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 12,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatTimestamp(notification.createdAt),
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemCount: _notifications.length,
              ),
      ),
    );
  }

  _NotificationVisualStyle _visualStyle(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.streakAlert:
        return const _NotificationVisualStyle(
          icon: Icons.local_fire_department_rounded,
          color: Color(0xFFF59E0B),
        );
      case AppNotificationType.milestone:
        return const _NotificationVisualStyle(
          icon: Icons.emoji_events_rounded,
          color: Color(0xFF4C9EEB),
        );
      case AppNotificationType.taskReminder:
        return const _NotificationVisualStyle(
          icon: Icons.schedule_rounded,
          color: Color(0xFF6366F1),
        );
      case AppNotificationType.dailyGoal:
        return const _NotificationVisualStyle(
          icon: Icons.rocket_launch_rounded,
          color: Color(0xFF10B981),
        );
      case AppNotificationType.overdueTasks:
        return const _NotificationVisualStyle(
          icon: Icons.warning_amber_rounded,
          color: Color(0xFFF97316),
        );
    }
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final differenceDays = today.difference(date).inDays;

    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    if (differenceDays == 0) {
      return 'Today, $hour:$minute $period';
    }

    if (differenceDays == 1) {
      return 'Yesterday, $hour:$minute $period';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}, $hour:$minute $period';
  }
}

class _NotificationVisualStyle {
  final IconData icon;
  final Color color;

  const _NotificationVisualStyle({required this.icon, required this.color});
}
