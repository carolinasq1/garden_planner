part of 'task_bloc.dart';

abstract class TaskEvent {}

class GetTasksEvent extends TaskEvent {}

class RefreshTasksEvent extends TaskEvent {}
