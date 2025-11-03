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
    on<LoadMoreTasksEvent>(_onLoadMoreTasks);

    // Automatically load tasks when BLoC is created
    add(GetTasksEvent());
  }

  Future<void> _onGetTasks(TaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    _currentSearchQuery = null;
    await _resetAndRefreshTasks(emit);
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await createTaskUseCase.call(event.name, event.description);
      await _resetAndRefreshTasks(emit);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await editTaskUseCase.call(event.task);
      await _resetAndRefreshTasks(emit);
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

      final currentState = state;
      if (currentState is TaskLoaded) {
        // Check if task still matches current filter after toggle
        final matchesFilter = _matchesFilter(updatedTask, _currentFilterType);

        if (matchesFilter) {
          final updatedTasks = currentState.tasks.map((task) {
            return task.id == updatedTask.id ? updatedTask : task;
          }).toList();

          emit(
            TaskLoaded(
              tasks: updatedTasks,
              taskCount: currentState.taskCount,
              isLoadingMore: false,
            ),
          );
        } else {
          // refresh the state list
          await _resetAndRefreshTasks(emit);
        }
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  bool _matchesFilter(Task task, TaskFilterType filterType) {
    switch (filterType) {
      case TaskFilterType.all:
        return true;
      case TaskFilterType.completed:
        return task.isCompleted;
      case TaskFilterType.incomplete:
        return !task.isCompleted;
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTaskUseCase.call(event.taskId);

      final currentState = state;
      if (currentState is TaskLoaded) {
        final updatedTasks = currentState.tasks
            .where((task) => task.id != event.taskId)
            .toList();
        final updatedCount = currentState.taskCount - 1;

        // If list is empty, remaining tasks can be on different pages
        if (updatedTasks.isEmpty) {
          await _resetAndRefreshTasks(emit);
        } else {
          emit(
            TaskLoaded(
              tasks: updatedTasks,
              taskCount: updatedCount,
              isLoadingMore: false,
            ),
          );
        }
      }
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
    await _resetAndRefreshTasks(emit);
  }

  Future<void> _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    _currentFilterType = event.filterType;
    await _resetAndRefreshTasks(emit);
  }

  Future<void> _onSortTasks(
    SortTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    _currentSortType = event.sortType;
    await _resetAndRefreshTasks(emit);
  }

  Future<void> _onLoadMoreTasks(
    LoadMoreTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;

    if (currentState is TaskLoaded &&
        currentState.tasks.length < currentState.taskCount &&
        !currentState.isLoadingMore) {
      final currentTasks = currentState.tasks;

      _currentPage++;

      emit(
        TaskLoaded(
          tasks: currentTasks,
          taskCount: currentState.taskCount,
          isLoadingMore: true,
        ),
      );

      try {
        final result = await getTasksUseCase.call(
          query: _currentSearchQuery,
          filterType: _currentFilterType,
          sortType: _currentSortType,
          page: _currentPage,
          pageSize: _pageSize,
        );

        emit(
          TaskLoaded(
            tasks: [...currentTasks, ...result.tasks],
            taskCount: result.taskCount,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  Future<void> _resetAndRefreshTasks(Emitter<TaskState> emit) async {
    _currentPage = 1;
    await _refreshTasks(emit);
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

      emit(
        TaskLoaded(
          tasks: result.tasks,
          taskCount: result.taskCount,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
