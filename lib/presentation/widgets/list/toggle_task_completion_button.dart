import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/task.dart';
import '../../bloc/task_bloc.dart';

class ToggleTaskCompletionButton extends StatelessWidget {
  final Task task;

  const ToggleTaskCompletionButton({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        task.isCompleted
            ? Icons.local_florist
            : Icons.local_florist_outlined,
        color: task.isCompleted ? Colors.green : Colors.grey,
      ),
      onPressed: () {
        context.read<TaskBloc>().add(ToggleTaskCompletedEvent(task));
      },
    );
  }
}

