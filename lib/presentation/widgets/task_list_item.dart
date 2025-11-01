import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      subtitle: task.description != null ? Text(task.description!) : null,
      leading: task.isCompleted ? const Icon(Icons.check) : null,
    );
  }
}
