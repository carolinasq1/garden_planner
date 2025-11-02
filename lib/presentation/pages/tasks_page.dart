import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../widgets/list/task_list.dart';
import '../widgets/list/task_empty_state.dart';
import '../widgets/list/task_error_state.dart';
import '../widgets/list/task_loading_state.dart';
import '../widgets/add_task_button.dart';
import '../../core/di/injection_container.dart' as di;

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        getAllTasksUseCase: di.getIt(),
        editTaskUseCase: di.getIt(),
        deleteTaskUseCase: di.getIt(),
        createTaskUseCase: di.getIt(),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Garden Tasks')),
        floatingActionButton: const AddTaskButton(),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return switch (state) {
              TaskLoading() => const TaskLoadingState(),
              TaskLoaded(tasks: final tasks) =>
                tasks.isEmpty
                    ? const TaskEmptyState()
                    : TaskListWidget(tasks: tasks),
              TaskError(message: final message) => TaskErrorState(
                message: message,
              ),
            };
          },
        ),
      ),
    );
  }
}
