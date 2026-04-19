import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  // Dummy data for UI
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Read Chapter 4', 'subject': 'Math', 'isDone': false},
    {'title': 'Complete Assignment', 'subject': 'Physics', 'isDone': true},
    {'title': 'Prepare Presentation', 'subject': 'History', 'isDone': false},
    {'title': 'Solve Practice Test', 'subject': 'Chemistry', 'isDone': false},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12.0),
          color: task['isDone']
              ? Colors.green.withOpacity(0.05)
              : Colors.blueAccent.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: task['isDone']
                  ? Colors.green.withOpacity(0.3)
                  : Colors.blueAccent.withOpacity(0.2),
            ),
          ),
          child: CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            value: task['isDone'],
            onChanged: (bool? value) {
              setState(() {
                task['isDone'] = value ?? false;
              });
            },
            title: Text(
              task['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: task['isDone'] ? TextDecoration.lineThrough : null,
                color: task['isDone'] ? Colors.grey : Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                task['subject'],
                style: TextStyle(
                  color: task['isDone'] ? Colors.grey : Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            activeColor: Colors.green,
            checkColor: Colors.white,
            controlAffinity: ListTileControlAffinity.leading,
            secondary: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                // TODO: Show confirm delete dialog or delete task
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete task clicked!')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
