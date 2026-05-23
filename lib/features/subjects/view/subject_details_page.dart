import 'package:flutter/material.dart';
import 'package:one_tap/core/models/user_activity_model.dart';
import 'package:one_tap/features/subjects/data/subjects_firestore_service.dart';
import 'package:one_tap/features/tasks/data/tasks_firestore_service.dart';
import '../../../../core/models/task_model.dart';
import '../../../../core/models/subject_model.dart';
import 'add_subject_page.dart';

class SubjectDetailsPage extends StatefulWidget {
  final String? subjectId;
  final String title;
  final String emoji;
  final Color badgeColor;

  const SubjectDetailsPage({
    super.key,
    required this.subjectId,
    required this.title,
    required this.emoji,
    required this.badgeColor,
  });

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  final SubjectsFirestoreService _subjectsService = SubjectsFirestoreService();
  final TasksFirestoreService _tasksService = TasksFirestoreService();
  late String currentTitle;
  late String currentEmoji;
  late Color currentBadgeColor;

  @override
  void initState() {
    super.initState();
    currentTitle = widget.title;
    currentEmoji = widget.emoji;
    currentBadgeColor = widget.badgeColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subjectTasks = globalTasks
        .where(
          (t) => widget.subjectId != null
              ? t.subjectId == widget.subjectId
              : t.subject.title == currentTitle,
        )
        .toList();
    final completedTasks = subjectTasks.where((t) => t.isDone).length;
    final totalStudyMinutes = subjectTasks.fold<int>(
      0,
      (prev, t) => prev + t.durationMinutes,
    );
    final studyHours = totalStudyMinutes ~/ 60;
    final studyMins = totalStudyMinutes % 60;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: theme.cardColor,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.textTheme.bodyLarge!.color!,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: theme.cardColor,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz,
                  color: theme.textTheme.bodyLarge!.color!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (value) async {
                  if (value == 'edit') {
                    // Find the actual subject object
                    final subjectIndex = globalSubjects.indexWhere(
                      (s) => widget.subjectId != null
                          ? s.id == widget.subjectId
                          : s.title == currentTitle,
                    );
                    if (subjectIndex != -1) {
                      final currentSubject = globalSubjects[subjectIndex];
                      final updatedSubject = await showDialog(
                        context: context,
                        builder: (context) =>
                            AddSubjectPage(subjectToEdit: currentSubject),
                      );

                      if (updatedSubject != null &&
                          updatedSubject is SubjectModel) {
                        final updatedWithId = updatedSubject.copyWith(
                          id: currentSubject.id,
                        );

                        await _subjectsService.updateSubject(updatedWithId);

                        setState(() {
                          // Update subject in global array
                          globalSubjects[subjectIndex] = updatedWithId;

                          // Update subject inside globally stored tasks
                          for (var task in globalTasks) {
                            final isSameSubject = widget.subjectId != null
                                ? task.subjectId == widget.subjectId
                                : task.subject.title == currentTitle;

                            if (isSameSubject) {
                              task.subject = updatedWithId;
                            }
                          }

                          // Update local state
                          currentTitle = updatedWithId.title;
                          currentBadgeColor = updatedWithId.color;
                          currentEmoji = updatedWithId.emoji;
                        });
                      }
                    }
                  } else if (value == 'delete') {
                    if (widget.subjectId != null) {
                      await _subjectsService.deleteSubject(widget.subjectId!);
                    }

                    setState(() {
                      // Remove subject
                      globalSubjects.removeWhere(
                        (s) => widget.subjectId != null
                            ? s.id == widget.subjectId
                            : s.title == currentTitle,
                      );
                      // Optional: also remove tasks related to this subject
                      globalTasks.removeWhere(
                        (t) => t.subject.title == currentTitle,
                      );
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: theme.textTheme.bodyLarge!.color!,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Edit Subject',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentEmoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              currentTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge!.color!,
              ),
            ),

            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: theme.textTheme.bodyMedium!.color!,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Total study',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.textTheme.bodyMedium!.color!,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: studyHours > 0
                                    ? '$studyHours'
                                    : '$studyMins',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyLarge!.color!,
                                ),
                              ),
                              TextSpan(
                                text: studyHours > 0 ? 'h ${studyMins}m' : 'm',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyLarge!.color!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.textTheme.bodyMedium!.color!,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$completedTasks',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyLarge!.color!,
                                ),
                              ),
                              TextSpan(
                                text: ' tasks',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyLarge!.color!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Tasks',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge!.color!,
              ),
            ),

            const SizedBox(height: 10),
            if (subjectTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No tasks for this subject yet.',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium!.color!,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ...subjectTasks.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () async {
                      final willBeDone = !t.isDone;
                      final updatedTask = t.copyWith(isDone: willBeDone);
                      await _tasksService.updateTask(updatedTask);

                      setState(() {
                        t.isDone = willBeDone;
                      });

                      if (willBeDone) {
                        await globalUserActivity.logActivity(DateTime.now());
                      }
                    },
                    child: _buildTaskItem(
                      context,
                      title: t.title,
                      duration: '${t.durationMinutes} min',
                      isCompleted: t.isDone,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context, {
    required String title,
    required String duration,
    required bool isCompleted,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCompleted
            ? colorScheme.primary.withValues(alpha: 0.1)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isCompleted
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            color: isCompleted
                ? colorScheme.primary
                : theme.textTheme.bodyMedium!.color!,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isCompleted
                        ? theme.textTheme.bodyMedium!.color!
                        : theme.textTheme.bodyLarge!.color!,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textTheme.bodyMedium!.color!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
