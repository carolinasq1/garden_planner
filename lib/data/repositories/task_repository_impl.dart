import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter_type.dart';
import '../../domain/entities/task_sort_type.dart';
import '../../domain/entities/tasks_result.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

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
  Future<TasksResult> getTasks({
    String? query,
    TaskFilterType filterType = TaskFilterType.all,
    TaskSortType sortType = TaskSortType.dateCreated,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await localDataSource.getTasksPaginated(
      query: query,
      filterType: filterType,
      sortType: sortType,
      page: page,
      pageSize: pageSize,
    );
  }
}
