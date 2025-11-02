import '../entities/task.dart';
import '../entities/task_filter_type.dart';
import '../entities/task_sort_type.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<Task>> call({
    String? query,
    TaskFilterType filterType = TaskFilterType.all,
    TaskSortType sortType = TaskSortType.dateCreated,
  }) async {
    return await repository.getTasks(
      query: query,
      filterType: filterType,
      sortType: sortType,
    );
  }
}
