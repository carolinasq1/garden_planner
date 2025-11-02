import 'package:flutter/material.dart';
import 'tasks_list.dart';
import 'empty_tasks.dart';
import 'task_count_display.dart';

class TasksListContent extends StatelessWidget {
  final int taskCount;

  const TasksListContent({
    super.key,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    if (taskCount == 0) {
      return const EmptyTasks();
    } else {
      return Column(
        children: [
          Expanded(
            child: TasksList(),
          ),
          TaskCountDisplay(taskCount: taskCount),
        ],
      );
    }
  }
}
