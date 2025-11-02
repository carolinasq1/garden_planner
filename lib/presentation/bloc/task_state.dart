part of 'task_bloc.dart';

sealed class TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final int taskCount;
  final int currentPage;
  final int totalPages;

  TaskLoaded({
    required this.tasks,
    required this.taskCount,
    required this.currentPage,
    required this.totalPages,
  });
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}
