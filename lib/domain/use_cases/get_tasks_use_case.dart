import '../entities/task_filter_type.dart';
import '../entities/task_sort_type.dart';
import '../entities/tasks_result.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<TasksResult> call({
    String? query,
    TaskFilterType filterType = TaskFilterType.all,
    TaskSortType sortType = TaskSortType.dateCreated,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await repository.getTasks(
      query: query,
      filterType: filterType,
      sortType: sortType,
      page: page,
      pageSize: pageSize,
    );
  }
}
