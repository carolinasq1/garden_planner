import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart';
import 'tasks_list.dart';
import 'empty_tasks.dart';
import 'task_count_display.dart';
import 'tasks_pagination_controls.dart';

class TasksListContent extends StatelessWidget {
  final List<Task> tasks;
  final int taskCount;
  final int currentPage;
  final int totalPages;

  const TasksListContent({
    super.key,
    required this.tasks,
    required this.taskCount,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    if (taskCount == 0) {
      return const EmptyTasks();
    } else {
      return Column(
        children: [
          Expanded(child: TasksList(tasks: tasks)),
          TaskCountDisplay(taskCount: taskCount),
          if (totalPages > 1)
            TasksPaginationControls(
              currentPage: currentPage,
              totalPages: totalPages,
            ),
        ],
      );
    }
  }
}
