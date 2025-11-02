import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../widgets/list/task_list.dart';
import '../widgets/list/task_empty_widget.dart';
import '../widgets/list/task_error_widget.dart';
import '../widgets/list/task_loading_widget.dart';
import '../widgets/add_task_button.dart';
import '../../core/di/injection_container.dart' as di;
import '../widgets/search/task_search_bar.dart';

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
        searchTasksUseCase: di.getIt(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Garden Tasks'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: const TaskSearchBar(),
            ),
          ),
        ),
        floatingActionButton: const AddTaskButton(),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return switch (state) {
              TaskLoading() => const TaskLoadingWidget(),
              TaskLoaded(tasks: final tasks) =>
                tasks.isEmpty
                    ? const TaskEmptyWidget()
                    : TaskListWidget(tasks: tasks),
              TaskError(message: final message) => TaskErrorWidget(
                message: message,
              ),
            };
          },
        ),
      ),
    );
  }
}
