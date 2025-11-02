import 'package:flutter/material.dart';

class TaskCountDisplay extends StatelessWidget {
  final int taskCount;

  const TaskCountDisplay({super.key, required this.taskCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Text(
          '$taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}

