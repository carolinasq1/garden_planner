import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<void> call(String name, String? description) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    return await repository.createTask(newTask);
  }
}
