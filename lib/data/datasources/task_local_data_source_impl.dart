import 'package:hive/hive.dart';
import '../models/task_model.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter_type.dart';
import '../../domain/entities/task_sort_type.dart';
import '../../domain/entities/tasks_result.dart';
import 'task_local_data_source.dart';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskModel> taskBox;

  TaskLocalDataSourceImpl({required this.taskBox});

  @override
  Future<void> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await taskBox.put(task.id, taskModel);
  }

  @override
  Future<TasksResult> getTasksPaginated({
    String? query,
    required TaskFilterType filterType,
    required TaskSortType sortType,
    required int page,
    required int pageSize,
  }) async {
    // Get all tasks from Hive
    final allTasks = taskBox.values.map((model) => model.toEntity()).toList();

    // Apply filters, querie and sort
    final searchResults = query != null && query.isNotEmpty
        ? _applySearch(allTasks, query)
        : allTasks;

    final filteredTasks = _applyFilter(searchResults, filterType);
    final taskCount = filteredTasks.length;

    final sortedTasks = _applySort(filteredTasks, sortType);

    // Apply pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    final paginatedTasks = startIndex >= sortedTasks.length
        ? <Task>[]
        : sortedTasks.sublist(
            startIndex,
            endIndex > sortedTasks.length ? sortedTasks.length : endIndex,
          );

    return TasksResult(tasks: paginatedTasks, taskCount: taskCount);
  }

  List<Task> _applySearch(List<Task> tasks, String query) {
    final lowerCaseQuery = query.toLowerCase().trim();
    return tasks.where((task) {
      final nameMatch = task.name.toLowerCase().contains(lowerCaseQuery);
      final descriptionMatch =
          task.description?.toLowerCase().contains(lowerCaseQuery) ?? false;
      return nameMatch || descriptionMatch;
    }).toList();
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

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await taskBox.put(task.id, taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await taskBox.delete(taskId);
  }
}
