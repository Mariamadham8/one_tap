import 'package:flutter/material.dart';
import 'package:one_tap/core/models/user_activity_model.dart';
import 'package:one_tap/features/tasks/data/tasks_firestore_service.dart';
import '../../../../core/models/task_model.dart';
import '../../../../features/tasks/view/add_task_page.dart';
import '../../../../features/tasks/view/task_timer_page.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final TasksFirestoreService _tasksService = TasksFirestoreService();
  TaskFilter _selectedFilter = TaskFilter.all;

  void _sortTasksByCompletion() {
    final pendingTasks = globalTasks.where((task) => !task.isDone).toList();
    final completedTasks = globalTasks.where((task) => task.isDone).toList();

    globalTasks
      ..clear()
      ..addAll(pendingTasks)
      ..addAll(completedTasks);
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks();

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
          Text(
            'Tuesday, 19 April',
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF1E293B).withOpacity(0.5),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'What\'s your plan today?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),

          // Add Task Button
          InkWell(
            onTap: () async {
              final newTask = await showDialog(
                context: context,
                builder: (context) => const AddTaskPage(),
              );
              if (newTask != null && newTask is TaskModel) {
                try {
                  final savedTask = await _tasksService.addTask(
                    newTask.copyWith(subjectId: newTask.subject.id),
                  );
                  if (!mounted) return;

                  setState(() {
                    globalTasks.insert(0, savedTask);
                  });
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not save task. Please try again.'),
                    ),
                  );
                }
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF4C9EEB).withOpacity(0.5),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Color(0xFF4C9EEB), size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Add Task',
                    style: TextStyle(
                      color: Color(0xFF4C9EEB),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              _buildFilterChip(TaskFilter.all, 'All'),
              const SizedBox(width: 8),
              _buildFilterChip(TaskFilter.today, 'Today'),
              const SizedBox(width: 8),
              _buildFilterChip(TaskFilter.overdue, 'Overdue'),
            ],
          ),
          const SizedBox(height: 10),

          if (filteredTasks.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  _emptyStateText(),
                  style: TextStyle(
                    color: const Color(0xFF1E293B).withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else if (_selectedFilter == TaskFilter.all)
            ReorderableListView.builder(
              shrinkWrap: true,
              buildDefaultDragHandles: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTasks.length,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final TaskModel item = filteredTasks.removeAt(oldIndex);
                  final sourceGlobalIndex = globalTasks.indexOf(item);
                  globalTasks.removeAt(sourceGlobalIndex);

                  if (newIndex >= filteredTasks.length) {
                    globalTasks.add(item);
                  } else {
                    final targetTask = filteredTasks[newIndex];
                    final targetGlobalIndex = globalTasks.indexOf(targetTask);
                    globalTasks.insert(targetGlobalIndex, item);
                  }
                });
              },
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final globalIndex = globalTasks.indexOf(task);
                return Container(
                  key: ObjectKey(task),
                  child: _buildTaskCard(task, globalIndex),
                );
              },
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final globalIndex = globalTasks.indexOf(task);
                return _buildTaskCard(task, globalIndex, enableDrag: false);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, int index, {bool enableDrag = true}) {
    bool isDone = task.isDone;
    final isOverdue = _isTaskOverdue(task);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => AddTaskPage(taskToEdit: task),
        );

        if (result == 'delete') {
          final taskId = task.id;
          if (taskId != null && taskId.isNotEmpty) {
            await _tasksService.deleteTask(taskId);
          }

          setState(() {
            globalTasks.removeAt(index);
          });
        } else if (result != null && result is TaskModel) {
          final updatedTask = task.copyWith(
            title: result.title,
            subject: result.subject,
            subjectId: result.subject.id,
            durationMinutes: result.durationMinutes,
            dueDate: result.dueDate,
            isDone: task.isDone,
          );

          await _tasksService.updateTask(updatedTask);

          setState(() {
            globalTasks[index] = updatedTask;
          });
        }
      },
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        offset: isDone ? const Offset(0, 0.04) : Offset.zero,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          opacity: isDone ? 0.94 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFFEEF6FE)
                  : isOverdue
                  ? const Color(0xFFFFF3ED)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isOverdue
                    ? const Color(0xFFF97316).withOpacity(0.55)
                    : Colors.transparent,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (enableDrag)
                  ReorderableDragStartListener(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.drag_indicator,
                        color: Color(0xFFCBD5E1),
                        size: 20,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 4),
                if (!enableDrag) const SizedBox(width: 6),
                GestureDetector(
                  onTap: () async {
                    final willBeDone = !isDone;
                    final updatedTask = task.copyWith(isDone: willBeDone);

                    await _tasksService.updateTask(updatedTask);

                    setState(() {
                      task.isDone = willBeDone;
                    });

                    if (willBeDone) {
                      await globalUserActivity.logActivity(DateTime.now());
                    }

                    if (!mounted) return;

                    // Give a short visual feedback before moving completed tasks down.
                    await Future.delayed(const Duration(milliseconds: 180));
                    if (!mounted) return;

                    setState(() {
                      _sortTasksByCompletion();
                    });
                  },
                  child: Icon(
                    isDone
                        ? Icons.check_circle_outline
                        : Icons.radio_button_unchecked,
                    color: isDone
                        ? const Color(0xFF4C9EEB).withOpacity(0.5)
                        : isOverdue
                        ? const Color(0xFFE53935)
                        : const Color(0xFF1E293B).withOpacity(0.5),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDone
                              ? const Color(0xFF1E293B).withOpacity(0.4)
                              : isOverdue
                              ? const Color(0xFF9A3412)
                              : const Color(0xFF1E293B),
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? task.subject.color.withOpacity(0.4)
                                  : task.subject.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.subject.title,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: isDone
                                    ? const Color(0xFF1E293B).withOpacity(0.4)
                                    : const Color(0xFF1E293B).withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: isDone
                                ? const Color(0xFF1E293B).withOpacity(0.3)
                                : const Color(0xFF1E293B).withOpacity(0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${task.durationMinutes} min",
                            style: TextStyle(
                              fontSize: 9,
                              color: isDone
                                  ? const Color(0xFF1E293B).withOpacity(0.3)
                                  : const Color(0xFF1E293B).withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (task.dueDate != null) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.event_outlined,
                              size: 12,
                              color: isDone
                                  ? const Color(0xFF1E293B).withOpacity(0.3)
                                  : isOverdue
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF1E293B).withOpacity(0.4),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDueDate(task.dueDate!),
                              style: TextStyle(
                                fontSize: 9,
                                color: isDone
                                    ? const Color(0xFF1E293B).withOpacity(0.3)
                                    : isOverdue
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFF1E293B).withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (isOverdue) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Overdue',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE53935),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isDone)
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF4C9EEB),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskTimerPage(
                              taskTitle: task.title,
                              durationMinutes: task.durationMinutes,
                            ),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () async {
                      final taskId = task.id;
                      if (taskId != null && taskId.isNotEmpty) {
                        await _tasksService.deleteTask(taskId);
                      }

                      setState(() {
                        globalTasks.removeAt(index);
                      });
                    },
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  bool _isTaskOverdue(TaskModel task) {
    if (task.isDone || task.dueDate == null) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }

  bool _isTaskDueToday(TaskModel task) {
    if (task.dueDate == null) return false;

    final now = DateTime.now();
    final due = task.dueDate!;
    return due.year == now.year && due.month == now.month && due.day == now.day;
  }

  List<TaskModel> _filteredTasks() {
    switch (_selectedFilter) {
      case TaskFilter.today:
        return globalTasks.where(_isTaskDueToday).toList();
      case TaskFilter.overdue:
        return globalTasks.where(_isTaskOverdue).toList();
      case TaskFilter.all:
        return List<TaskModel>.from(globalTasks);
    }
  }

  Widget _buildFilterChip(TaskFilter filter, String label) {
    final isSelected = _selectedFilter == filter;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4C9EEB) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4C9EEB)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E293B),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _emptyStateText() {
    switch (_selectedFilter) {
      case TaskFilter.today:
        return 'No tasks due today.';
      case TaskFilter.overdue:
        return 'No overdue tasks. Great job!';
      case TaskFilter.all:
        return 'No tasks yet. Add your first task.';
    }
  }
}

enum TaskFilter { all, today, overdue }
