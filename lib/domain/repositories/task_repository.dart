import '../entities/task.dart';
import '../entities/task_filter_type.dart';
import '../entities/task_sort_type.dart';
import '../entities/tasks_result.dart';

abstract class TaskRepository {
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<TasksResult> getTasks({
    String? query,
    TaskFilterType filterType = TaskFilterType.all,
    TaskSortType sortType = TaskSortType.dateCreated,
    int page = 1,
    int pageSize = 10,
  });
}
