import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter_type.dart';
import '../../domain/entities/task_sort_type.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Task?> getTaskById(String taskId) async {
    return await localDataSource.getTaskById(taskId);
  }

  @override
  Future<void> createTask(Task task) async {
    return await localDataSource.createTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    return await localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    return await localDataSource.deleteTask(taskId);
  }

  @override
  Future<List<Task>> getTasks({
    String? query,
    TaskFilterType filterType = TaskFilterType.all,
    TaskSortType sortType = TaskSortType.dateCreated,
  }) async {
    // Get base tasks (either all tasks or search results)
    final tasks = query != null && query.isNotEmpty
        ? await localDataSource.searchTasks(query)
        : await localDataSource.getAllTasks();

    // Apply filter
    final filteredTasks = _applyFilter(tasks, filterType);

    // Apply sort
    final sortedTasks = _applySort(filteredTasks, sortType);

    return sortedTasks;
  }

  List<Task> _applyFilter(List<Task> tasks, TaskFilterType filterType) {
    switch (filterType) {
      case TaskFilterType.all:
        return tasks;
      case TaskFilterType.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilterType.incomplete:
        return tasks.where((task) => !task.isCompleted).toList();
    }
  }

  List<Task> _applySort(List<Task> tasks, TaskSortType sortType) {
    final sortedTasks = List<Task>.from(tasks);
    switch (sortType) {
      case TaskSortType.dateCreated:
        sortedTasks.sort((a, b) {
          // Sort by creation date, newest first
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case TaskSortType.alphabetical:
        sortedTasks.sort((a, b) {
          // Sort alphabetically by name
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case TaskSortType.completionStatus:
        sortedTasks.sort((a, b) {
          // Sort by completion status (incomplete first, then completed)
          if (a.isCompleted == b.isCompleted) {
            // If same status, sort by creation date
            return b.createdAt.compareTo(a.createdAt);
          }
          return a.isCompleted ? 1 : -1;
        });
        break;
    }
    return sortedTasks;
  }
}
