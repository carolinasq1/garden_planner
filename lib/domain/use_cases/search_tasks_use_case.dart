import '../entities/task.dart';
import '../repositories/task_repository.dart';

class SearchTasksUseCase {
  final TaskRepository repository;

  SearchTasksUseCase(this.repository);

  Future<List<Task>> call(String query) async {
    return await repository.searchTasks(query);
  }
}

