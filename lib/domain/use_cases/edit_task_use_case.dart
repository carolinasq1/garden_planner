import '../entities/task.dart';
import '../repositories/task_repository.dart';

class EditTaskUseCase {
  final TaskRepository repository;

  EditTaskUseCase(this.repository);

  Future<void> call(Task task) async {
    return await repository.updateTask(task);
  }
}
