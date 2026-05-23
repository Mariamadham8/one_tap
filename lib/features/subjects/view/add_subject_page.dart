import 'package:flutter/material.dart';
import '../../../../core/models/subject_model.dart';

class AddSubjectPage extends StatefulWidget {
  final SubjectModel? subjectToEdit;
  const AddSubjectPage({super.key, this.subjectToEdit});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedIconIndex = 0;
  int _selectedColorIndex = 0;

  final List<String> _icons = [
    '📐',
    '⚛️',
    '📜',
    '📖',
    '🧬',
    '⚗️',
    '🌍',
    '💻',
    '🎨',
    '🎵',
    '🧠',
    '📊',
  ];

  final List<Color> _colors = [
    const Color(0xFFa2c8f2), // Light Blue
    const Color(0xFFD6F3E6), // Mint
    const Color(0xFFFFE8D6), // Peach
    const Color(0xFFF3E5F5), // Lavender
    const Color(0xFFFFF9C4), // Light Yellow
    const Color(0xFFFFE4E1), // Pink
  ];

  @override
  void initState() {
    super.initState();
    if (widget.subjectToEdit != null) {
      _nameController.text = widget.subjectToEdit!.title;
      int iconIndex = _icons.indexOf(widget.subjectToEdit!.emoji);
      if (iconIndex != -1) _selectedIconIndex = iconIndex;
      int colorIndex = _colors.indexOf(widget.subjectToEdit!.color);
      if (colorIndex != -1) _selectedColorIndex = colorIndex;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // A Dialog widget that displays nicely centered above the screen
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.subjectToEdit != null
                        ? 'Edit Subject'
                        : 'New Subject',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge!.color!,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close,
                      color: theme.textTheme.bodyMedium!.color!,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Preview Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _colors[_selectedColorIndex],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.textTheme.bodyLarge!.color!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _icons[_selectedIconIndex],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preview',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.textTheme.bodyMedium!.color!,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _nameController.text.isEmpty
                                ? 'Subject name'
                                : _nameController.text,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.bodyLarge!.color!,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Name Input
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _nameController,
                onChanged: (value) => setState(() {}),
                style: TextStyle(color: theme.textTheme.bodyLarge!.color!),
                decoration: InputDecoration(
                  hintText: 'e.g. Computer Science',
                  hintStyle: TextStyle(
                    color: theme.textTheme.bodyMedium!.color!,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Icon Selector
              Text(
                'Icon',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(_icons.length, (index) {
                  final isSelected = index == _selectedIconIndex;
                  return InkWell(
                    onTap: () => setState(() => _selectedIconIndex = index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 2)
                            : Border.all(color: Colors.transparent, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          _icons[index],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),

              // Color Selector
              Text(
                'Color',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(_colors.length, (index) {
                  final isSelected = index == _selectedColorIndex;
                  return InkWell(
                    onTap: () => setState(() => _selectedColorIndex = index),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _colors[index],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 2)
                            : null,
                      ),
                      // Create inner white gap if selected
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _colors[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.trim().isEmpty) return;

                        final newSubject = SubjectModel(
                          title: _nameController.text.trim(),
                          emoji: _icons[_selectedIconIndex],
                          color: _colors[_selectedColorIndex],
                          taskCount:
                              widget.subjectToEdit?.taskCount ?? '0 tasks',
                          progress: widget.subjectToEdit?.progress ?? 0.0,
                        );
                        Navigator.pop(context, newSubject);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        widget.subjectToEdit != null
                            ? 'Save Changes'
                            : 'Add Subject',
                        style: const TextStyle(
                          fontSize: 14,
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
      ),
    );
  }
}
