import 'package:flutter/material.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  final TaskModel? taskToEdit;
  bool get isEditMode => taskToEdit != null;

  const AddTaskPage({super.key, this.taskToEdit});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  SubjectModel? _selectedSubject;
  int _selectedTime = 25;
  DateTime? _selectedDueDate;
  final List<int> _times = [20, 25, 30, 35, 40, 45];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _titleController.text = widget.taskToEdit!.title;

      final taskSubjectId = widget.taskToEdit!.subjectId;
      if (taskSubjectId != null && taskSubjectId.isNotEmpty) {
        final index = globalSubjects.indexWhere((s) => s.id == taskSubjectId);
        if (index != -1) {
          _selectedSubject = globalSubjects[index];
        }
      }

      _selectedSubject ??= widget.taskToEdit!.subject;
      _selectedTime = widget.taskToEdit!.durationMinutes;
      _selectedDueDate = widget.taskToEdit!.dueDate;
    } else if (globalSubjects.isNotEmpty) {
      _selectedSubject = globalSubjects.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor:
          theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 18.0,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEditMode ? 'Edit Task' : 'New Task',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge!.color!,
                  ),
                ),
                Row(
                  children: [
                    if (widget.isEditMode)
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'delete');
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                          size: 20,
                        ),
                      ),
                    if (widget.isEditMode) const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: theme.textTheme.bodyMedium!.color!,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title Input
            Text(
              'Title',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge!.color!,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontSize: 11,
                color: theme.textTheme.bodyLarge!.color!,
              ),
              decoration: InputDecoration(
                hintText: 'What do you want to study?',
                hintStyle: TextStyle(
                  color: theme.textTheme.bodyMedium!.color!.withValues(
                    alpha: 0.8,
                  ),
                  fontSize: 11,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.2,
                  ),
                ),
                filled: true,
                fillColor: theme.cardColor,
              ),
            ),
            const SizedBox(height: 10),

            // Subject Dropdown
            Text(
              'Subject',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge!.color!,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: DropdownButtonHideUnderline(
                child: globalSubjects.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Please add a subject first from Home',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      )
                    : DropdownButton<SubjectModel>(
                        value: _selectedSubject,
                        isExpanded: true,
                        dropdownColor: theme.cardColor,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.textTheme.bodyMedium!.color!,
                          size: 18,
                        ),
                        items: globalSubjects.map((SubjectModel subject) {
                          return DropdownMenuItem<SubjectModel>(
                            value: subject,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: subject.color.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    subject.emoji,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  subject.title,
                                  style: TextStyle(
                                    color: theme.textTheme.bodyLarge!.color!,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (SubjectModel? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedSubject = newValue;
                            });
                          }
                        },
                      ),
              ),
            ),
            const SizedBox(height: 10),

            // Due date
            Text(
              'Due date',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge!.color!,
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () async {
                final initialDate = _selectedDueDate ?? DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (picked == null) return;

                setState(() {
                  _selectedDueDate = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    23,
                    59,
                    59,
                  );
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 16,
                      color: theme.textTheme.bodyMedium!.color!,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedDueDate == null
                            ? 'No due date selected'
                            : _formatDate(_selectedDueDate!),
                        style: TextStyle(
                          fontSize: 11,
                          color: _selectedDueDate == null
                              ? theme.textTheme.bodyMedium!.color!
                              : theme.textTheme.bodyLarge!.color!,
                        ),
                      ),
                    ),
                    if (_selectedDueDate != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDueDate = null;
                          });
                        },
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: theme.textTheme.bodyMedium!.color!,
                        ),
                      )
                    else
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 16,
                        color: theme.textTheme.bodyMedium!.color!,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Estimated time
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: theme.textTheme.bodyLarge!.color!,
                ),
                const SizedBox(width: 4),
                Text(
                  'Estimated time',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge!.color!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 10.0,
              children: _times.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$time min',
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) return;
                      if (_selectedSubject == null) return;

                      final newTask = TaskModel(
                        title: _titleController.text.trim(),
                        subjectId: _selectedSubject!.id,
                        subject: _selectedSubject!,
                        durationMinutes: _selectedTime,
                        dueDate: _selectedDueDate,
                      );

                      Navigator.pop(context, newTask);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      widget.isEditMode ? 'Save Task' : 'Add Task',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
