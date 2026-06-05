import 'package:flutter/material.dart';
import 'package:proyecto_123/features/tasks/data/models/task_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final Function(bool?) onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: task.completed 
          ? colorScheme.surfaceContainerHighest.withOpacity(0.5) 
          : colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: task.completed ? Colors.transparent : colorScheme.outlineVariant,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: task.completed,
            onChanged: onToggle,
            activeColor: colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? colorScheme.outline : colorScheme.onSurface,
            fontWeight: task.completed ? FontWeight.normal : FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_sweep_outlined, color: colorScheme.error),
          onPressed: onDelete,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }
}
