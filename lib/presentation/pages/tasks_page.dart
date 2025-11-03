import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../widgets/list/task_error_widget.dart';
import '../widgets/list/task_loading_widget.dart';
import '../widgets/list/tasks_list_content.dart';
import '../widgets/add_task_button.dart';
import '../widgets/search/task_search_bar.dart';
import '../widgets/filter_sort/task_filter_bar.dart';
import '../widgets/filter_sort/task_sort_bar.dart';
import '../widgets/weather/weather_icon_widget.dart';
import '../../core/di/injection_container.dart' as di;

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        getTasksUseCase: di.getIt(),
        editTaskUseCase: di.getIt(),
        deleteTaskUseCase: di.getIt(),
        createTaskUseCase: di.getIt(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Garden Planner'),
          scrolledUnderElevation: 0,
          bottom: const TaskSearchBar(),
          actions: const [
            WeatherIconWidget(),
          ],
        ),
        floatingActionButton: const AddTaskButton(),
        body: SafeArea(
          child: Column(
            children: [
              const TaskFilterBar(),
              const TaskSortBar(),
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    return switch (state) {
                      TaskLoading() => const TaskLoadingWidget(),
                      TaskLoaded(:final taskCount) => TasksListContent(
                        taskCount: taskCount,
                      ),
                      TaskError(message: final message) => TaskErrorWidget(
                        message: message,
                      ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
