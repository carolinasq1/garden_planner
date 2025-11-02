import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter_type.dart';
import '../../domain/entities/task_sort_type.dart';
import '../../domain/use_cases/get_tasks_use_case.dart';
import '../../domain/use_cases/edit_task_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/create_task_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final CreateTaskUseCase createTaskUseCase;

  String? _currentSearchQuery;
  TaskFilterType _currentFilterType = TaskFilterType.all;
  TaskSortType _currentSortType = TaskSortType.dateCreated;
  int _currentPage = 1;
  static const int _pageSize = 10;

  TaskBloc({
    required this.getTasksUseCase,
    required this.editTaskUseCase,
    required this.deleteTaskUseCase,
    required this.createTaskUseCase,
  }) : super(TaskLoading()) {
    on<GetTasksEvent>(_onGetTasks);
    on<ToggleTaskCompletedEvent>(_onToggleTaskCompleted);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<EditTaskEvent>(_onEditTask);
    on<SearchTasksEvent>(_onSearchTasks);
    on<FilterTasksEvent>(_onFilterTasks);
    on<SortTasksEvent>(_onSortTasks);
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);

    // Automatically load tasks when BLoC is created
    add(GetTasksEvent());
  }

  Future<void> _onGetTasks(TaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    _currentSearchQuery = null;
    _currentPage = 1;
    await _refreshTasks(emit);
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await createTaskUseCase.call(event.name, event.description);
      await _refreshTasks(emit);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await editTaskUseCase.call(event.task);
      await _refreshTasks(emit);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompleted(
    ToggleTaskCompletedEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final updatedTask = event.task.copyWith(
        isCompleted: !event.task.isCompleted,
        updatedAt: DateTime.now(),
      );
      await editTaskUseCase.call(updatedTask);
      await _refreshTasks(emit);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await deleteTaskUseCase.call(event.taskId);
      await _refreshTasks(emit);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    _currentSearchQuery = event.query.trim().isEmpty
        ? null
        : event.query.trim();
    _currentPage = 1;
    await _refreshTasks(emit);
  }

  Future<void> _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    _currentFilterType = event.filterType;
    _currentPage = 1;
    await _refreshTasks(emit);
  }

  Future<void> _onSortTasks(
    SortTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    _currentSortType = event.sortType;
    _currentPage = 1;
    await _refreshTasks(emit);
  }

  Future<void> _onNextPage(NextPageEvent event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded && _currentPage < currentState.totalPages) {
      emit(TaskLoading());
      _currentPage++;
      await _refreshTasks(emit);
    }
  }

  Future<void> _onPreviousPage(
    PreviousPageEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (_currentPage > 1) {
      emit(TaskLoading());
      _currentPage--;
      await _refreshTasks(emit);
    }
  }

  Future<void> _refreshTasks(Emitter<TaskState> emit) async {
    try {
      final result = await getTasksUseCase.call(
        query: _currentSearchQuery,
        filterType: _currentFilterType,
        sortType: _currentSortType,
        page: _currentPage,
        pageSize: _pageSize,
      );

      final totalPages = (result.taskCount / _pageSize).ceil();

      emit(
        TaskLoaded(
          tasks: result.tasks,
          taskCount: result.taskCount,
          currentPage: _currentPage,
          totalPages: totalPages == 0 ? 1 : totalPages,
        ),
      );
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
