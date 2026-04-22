import 'package:flutter/material.dart';
import '../../../../core/models/task_model.dart';
import '../../../../features/tasks/view/add_task_page.dart';
import '../../../../features/tasks/view/task_timer_page.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  // globalTasks used directly

  @override
  Widget build(BuildContext context) {
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
                setState(() {
                  globalTasks.insert(0, newTask);
                });
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

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: globalTasks.length,
            itemBuilder: (context, index) {
              final task = globalTasks[index];
              return _buildTaskCard(task, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, int index) {
    bool isDone = task.isDone;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          GestureDetector(
            onTap: () {
              setState(() {
                task.isDone = !isDone;
              });
            },
            child: Icon(
              isDone
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: isDone
                  ? const Color(0xFF4C9EEB).withOpacity(0.5)
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
                        : const Color(0xFF1E293B),
                    decoration: isDone ? TextDecoration.lineThrough : null,
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
                  ],
                ),
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
                      builder: (context) =>
                          TaskTimerPage(
                            taskTitle: task.title,
                            durationMinutes: task.durationMinutes,
                          ),
                    ),
                  );
                },
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}
