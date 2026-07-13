import 'package:flutter/material.dart';

import '../models/task.dart';

// Widget que representa uma tarefa na lista.
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            onToggle();
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
