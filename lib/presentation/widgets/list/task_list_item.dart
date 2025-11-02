import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/task.dart';
import '../../bloc/task_bloc.dart';
import '../../widgets/delete_task_dialog.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        final confirmed = await DeleteTaskDialog.show(context, task.name);
        return confirmed ?? false;
      },
      onDismissed: (direction) {
        context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
      },
      child: ListTile(
        title: Text(task.name),
        subtitle: task.description != null ? Text(task.description!) : null,
        leading: Icon(
          task.isCompleted ? Icons.local_florist : Icons.local_florist_outlined,
          color: task.isCompleted ? Colors.green : Colors.grey,
        ),
        onTap: () {
          context.read<TaskBloc>().add(ToggleTaskCompletedEvent(task));
        },
      ),
    );
  }
}
