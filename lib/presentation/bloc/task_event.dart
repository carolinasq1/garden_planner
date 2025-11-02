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
  final String name;
  final String? description;

  CreateTaskEvent(this.name, this.description);
}

class EditTaskEvent extends TaskEvent {
  final Task task;

  EditTaskEvent(this.task);
}

class SearchTasksEvent extends TaskEvent {
  final String query;

  SearchTasksEvent(this.query);
}

class FilterTasksEvent extends TaskEvent {
  final TaskFilterType filterType;

  FilterTasksEvent(this.filterType);
}
