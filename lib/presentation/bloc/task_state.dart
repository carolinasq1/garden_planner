part of 'task_bloc.dart';

sealed class TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final int taskCount;
  final bool isLoadingMore;

  TaskLoaded({
    required this.tasks,
    required this.taskCount,
    this.isLoadingMore = false,
  });
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}
