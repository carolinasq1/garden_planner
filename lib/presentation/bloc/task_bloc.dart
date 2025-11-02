import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter_type.dart';
import '../../domain/use_cases/get_all_tasks_use_case.dart';
import '../../domain/use_cases/edit_task_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/create_task_use_case.dart';
import '../../domain/use_cases/search_tasks_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final SearchTasksUseCase searchTasksUseCase;

  String? _currentSearchQuery;
  TaskFilterType _currentFilterType = TaskFilterType.all;

  TaskBloc({
    required this.getAllTasksUseCase,
    required this.editTaskUseCase,
    required this.deleteTaskUseCase,
    required this.createTaskUseCase,
    required this.searchTasksUseCase,
  }) : super(TaskLoading()) {
    on<GetTasksEvent>(_onGetTasks);
    on<ToggleTaskCompletedEvent>(_onToggleTaskCompleted);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<EditTaskEvent>(_onEditTask);
    on<SearchTasksEvent>(_onSearchTasks);
    on<FilterTasksEvent>(_onFilterTasks);

    // Automatically load tasks when BLoC is created
    add(GetTasksEvent());
  }

  Future<void> _onGetTasks(TaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      _currentSearchQuery = null;
      final tasks = await getAllTasksUseCase.call();
      final filteredTasks = _applyFilter(tasks);
      emit(TaskLoaded(filteredTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await createTaskUseCase.call(event.name, event.description);
      _refreshTasksList();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await editTaskUseCase.call(event.task);
      _refreshTasksList();
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
      _refreshTasksList();
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
      _refreshTasksList();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _refreshTasksList() {
    if (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty) {
      add(SearchTasksEvent(_currentSearchQuery!));
    } else {
      add(GetTasksEvent());
    }
  }

  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      _currentSearchQuery = event.query.trim().isEmpty
          ? null
          : event.query.trim();
      final tasks = await searchTasksUseCase.call(event.query);
      final filteredTasks = _applyFilter(tasks);
      emit(TaskLoaded(filteredTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    _currentFilterType = event.filterType;
    _refreshTasksList();
  }

  List<Task> _applyFilter(List<Task> tasks) {
    switch (_currentFilterType) {
      case TaskFilterType.all:
        return tasks;
      case TaskFilterType.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilterType.incomplete:
        return tasks.where((task) => !task.isCompleted).toList();
    }
  }
}
