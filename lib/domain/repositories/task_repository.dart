import '../entities/task.dart';
import '../entities/task_filter_type.dart';
import '../entities/task_sort_type.dart';

abstract class TaskRepository {
  Future<Task?> getTaskById(String taskId);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<List<Task>> getTasks({
    String? query,
    TaskFilterType filterType = TaskFilterType.all,
    TaskSortType sortType = TaskSortType.dateCreated,
  });
}
