import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter_type.dart';
import '../../domain/entities/task_sort_type.dart';
import '../../domain/entities/tasks_result.dart';

abstract class TaskLocalDataSource {
  Future<void> createTask(Task task);
  Future<TasksResult> getTasksPaginated({
    String? query,
    required TaskFilterType filterType,
    required TaskSortType sortType,
    required int page,
    required int pageSize,
  });
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
