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
  final List<int> _times = [20, 25, 30, 35, 40, 45];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _titleController.text = widget.taskToEdit!.title;
      _selectedSubject = widget.taskToEdit!.subject;
      _selectedTime = widget.taskToEdit!.durationMinutes;
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
    return Dialog(
      backgroundColor: Colors.white,
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Row(
                  children: [
                    if (widget.isEditMode)
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'delete');
                        },
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    if (widget.isEditMode) const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF64748B),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title Input
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 11),
              decoration: InputDecoration(
                hintText: 'What do you want to study?',
                hintStyle: TextStyle(
                  color: const Color(0xFF64748B).withOpacity(0.8),
                  fontSize: 11,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF4C9EEB).withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF4C9EEB).withOpacity(0.5),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4C9EEB),
                    width: 1.2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Subject Dropdown
            const Text(
              'Subject',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF64748B),
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
                                    color: subject.color.withOpacity(0.2),
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
                                  style: const TextStyle(
                                    color: Color(0xFF1E293B),
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

            // Estimated time
            Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: Color(0xFF1E293B),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Estimated time',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
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
                          ? const Color(0xFF4C9EEB)
                          : const Color(0xFFEAF4FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$time min',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF4C9EEB),
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
                      backgroundColor: const Color(0xFFF1F5F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF4C9EEB),
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
                        subject: _selectedSubject!,
                        durationMinutes: _selectedTime,
                      );

                      Navigator.pop(context, newTask);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: const Color(0xFF90CAFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      widget.isEditMode ? 'Save Task' : 'Add Task',
                      style: const TextStyle(
                        color: Colors.white,
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
}
