import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/use_cases/get_all_tasks_use_case.dart';
import '../../domain/use_cases/edit_task_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/create_task_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final CreateTaskUseCase createTaskUseCase;

  TaskBloc({
    required this.getAllTasksUseCase,
    required this.editTaskUseCase,
    required this.deleteTaskUseCase,
    required this.createTaskUseCase,
  }) : super(TaskLoading()) {
    on<GetTasksEvent>(_onGetTasks);
    on<ToggleTaskCompletedEvent>(_onToggleTaskCompleted);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<EditTaskEvent>(_onEditTask);

    // Automatically load tasks when BLoC is created
    add(GetTasksEvent());
  }

  Future<void> _onGetTasks(TaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasksUseCase.call();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompleted(
    ToggleTaskCompletedEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final updatedTask = event.task.copyWith(
        isCompleted: !event.task.isCompleted,
        updatedAt: DateTime.now(),
      );
      await editTaskUseCase.call(updatedTask);
      // Refresh the list
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTaskUseCase.call(event.taskId);
      // Refresh the list
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await createTaskUseCase.call(event.task);
      // Refresh the list
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await editTaskUseCase.call(event.task);
      // Refresh the list
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
