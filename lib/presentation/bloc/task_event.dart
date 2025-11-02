part of 'task_bloc.dart';

abstract class TaskEvent {}

class GetTasksEvent extends TaskEvent {}

class ToggleTaskCompletedEvent extends TaskEvent {
  final Task task;

  ToggleTaskCompletedEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);
}

class CreateTaskEvent extends TaskEvent {
  final Task task;

  CreateTaskEvent(this.task);
}
