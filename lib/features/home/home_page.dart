import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_tap/features/notifications/data/notification_service.dart';
import 'package:one_tap/features/notifications/view/notifications_page.dart';
import 'package:one_tap/features/subjects/data/subjects_firestore_service.dart';
import 'package:one_tap/features/tasks/data/tasks_firestore_service.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/task_model.dart';

import '../../../../features/tasks/view/tasks_view.dart';
import '../../../../features/profile/view/profile_page.dart';
import '../../../../features/subjects/view/add_subject_page.dart';
import '../../../../features/subjects/view/subject_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomeDashboardView(),
    const TasksView(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(bottom: false, child: _pages[_selectedIndex]),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4C9EEB).withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_outlined,
                  Icons.home_rounded,
                  'Home',
                ),
                _buildNavItem(
                  1,
                  Icons.check_box_outlined,
                  Icons.check_box,
                  'Today',
                ),
                _buildNavItem(2, Icons.person_outline, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4C9EEB) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.white : Colors.grey.shade500,
              size: 22,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeDashboardView extends StatefulWidget {
  const _HomeDashboardView();

  @override
  State<_HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<_HomeDashboardView> {
  final SubjectsFirestoreService _subjectsService = SubjectsFirestoreService();
  final TasksFirestoreService _tasksService = TasksFirestoreService();
  final NotificationService _notificationService = NotificationService();
  bool _isLoadingSubjects = true;
  int _unreadNotificationsCount = 0;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  String get _displayName {
    final name = _currentUser?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;

    final email = _currentUser?.email?.trim();
    if (email != null && email.isNotEmpty) return email.split('@').first;

    return 'User';
  }

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    _loadTasks();
    _refreshUnreadNotificationCount();
  }

  Future<void> _loadSubjects() async {
    try {
      final fetchedSubjects = await _subjectsService.fetchSubjects();
      if (!mounted) return;

      setState(() {
        globalSubjects
          ..clear()
          ..addAll(fetchedSubjects);
        _isLoadingSubjects = false;
      });
      await _refreshUnreadNotificationCount();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingSubjects = false;
      });
    }
  }

  Future<void> _addSubject(SubjectModel newSubject) async {
    try {
      final savedSubject = await _subjectsService.addSubject(newSubject);
      if (!mounted) return;

      setState(() {
        globalSubjects.insert(0, savedSubject);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save subject. Please try again.'),
        ),
      );
    }
  }

  Future<void> _loadTasks() async {
    try {
      final fetchedTasks = await _tasksService.fetchTasks();
      if (!mounted) return;

      setState(() {
        globalTasks
          ..clear()
          ..addAll(fetchedTasks);
      });
      await _refreshUnreadNotificationCount();
    } catch (_) {
      // Keep local list as-is on load failure.
    }
  }

  Future<void> _refreshUnreadNotificationCount() async {
    final notifications = await _notificationService.fetchNotifications();
    if (!mounted) return;

    setState(() {
      _unreadNotificationsCount = notifications.where((n) => !n.isRead).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalTasks = globalTasks.length;
    final int completedTasksCount = globalTasks.where((t) => t.isDone).length;
    final double progressScore = totalTasks == 0
        ? 0.0
        : completedTasksCount / totalTasks;
    final int progressPercent = (progressScore * 100).toInt();

    final int completedMinutes = globalTasks
        .where((t) => t.isDone)
        .fold<int>(0, (prev, t) => prev + t.durationMinutes);
    final int focusHours = completedMinutes ~/ 60;
    final int focusMins = completedMinutes % 60;
    final String focusText = focusHours > 0
        ? '${focusHours}h ${focusMins}m'
        : '${focusMins}m';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
        top: 12.0,
        bottom: 120.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good evening',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_displayName 👋',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      color: const Color(0xFF4C9EEB),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                        await _refreshUnreadNotificationCount();
                      },
                    ),
                    if (_unreadNotificationsCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              _unreadNotificationsCount > 9
                                  ? '9+'
                                  : '$_unreadNotificationsCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4C9EEB), Color(0xFF75B9F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Today\'s progress',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$progressPercent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Keep going!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressScore,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white.withOpacity(0.8),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tasks',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedTasksCount done',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 22,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.white.withOpacity(0.8),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Focus',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            focusText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          const Text(
            'Subjects',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),

          GridView.extent(
            maxCrossAxisExtent: 140,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
            children: [
              InkWell(
                onTap: () async {
                  final newSubject = await showDialog(
                    context: context,
                    builder: (context) => const AddSubjectPage(),
                  );
                  if (newSubject != null && newSubject is SubjectModel) {
                    await _addSubject(newSubject);
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF4C9EEB).withOpacity(0.3),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF4C9EEB),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'New subject',
                        style: TextStyle(
                          color: Color(0xFF4C9EEB),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoadingSubjects)
                const Center(child: CircularProgressIndicator())
              else
                ...globalSubjects.map((s) {
                  final subjectTasks = globalTasks
                      .where(
                        (t) => s.id != null
                            ? t.subjectId == s.id
                            : t.subject.title == s.title,
                      )
                      .toList();
                  final completedCount = subjectTasks
                      .where((t) => t.isDone)
                      .length;
                  final computedProgress = subjectTasks.isEmpty
                      ? 0.0
                      : (completedCount / subjectTasks.length);
                  return _buildSubjectCard(
                    context: context,
                    subjectId: s.id,
                    title: s.title,
                    taskCount: '${subjectTasks.length} tasks',
                    progress: computedProgress,
                    emoji: s.emoji,
                    color: s.color,
                  );
                }),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildSubjectCard({
    required BuildContext context,
    required String? subjectId,
    required String title,
    required String taskCount,
    required double progress,
    required String emoji,
    required Color color,
  }) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectDetailsPage(
              subjectId: subjectId,
              title: title,
              emoji: emoji,
              badgeColor: color,
            ),
          ),
        );
        setState(() {}); // Rebuild after returning from SubjectDetailsPage
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              taskCount,
              style: TextStyle(
                color: const Color(0xFF1E293B).withOpacity(0.6),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 9,
                    color: const Color(0xFF1E293B).withOpacity(0.6),
                  ),
                ),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: 9,
                    color: const Color(0xFF1E293B).withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF4C9EEB)),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
