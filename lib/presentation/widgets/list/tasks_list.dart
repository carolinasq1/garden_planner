import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task_bloc.dart';
import 'task_list_item.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // fetch more tasks when reaching the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TaskBloc>().add(LoadMoreTasksEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TaskBloc>().add(GetTasksEvent());
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        buildWhen: (previous, current) => current is TaskLoaded,
        builder: (context, state) {
          final loadedState = state as TaskLoaded;
          final tasks = loadedState.tasks;

          return ListView.builder(
            controller: _scrollController,
            itemCount: tasks.length + (loadedState.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == tasks.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return TaskListItem(
                  key: ValueKey(tasks[index].id),
                  task: tasks[index],
                );
              }
            },
          );
        },
      ),
    );
  }
}
