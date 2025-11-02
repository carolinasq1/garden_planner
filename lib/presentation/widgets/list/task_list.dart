import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task_bloc.dart';
import 'task_list_item.dart';
import '../../../domain/entities/task.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;

  const TaskListWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TaskBloc>().add(GetTasksEvent());
      },
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskListItem(task: tasks[index]);
        },
      ),
    );
  }
}
