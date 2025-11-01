import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<Task>> getAllTasks() async {
    return await localDataSource.getAllTasks();
  }

  @override
  Future<Task?> getTaskById(String taskId) async {
    return await localDataSource.getTaskById(taskId);
  }

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
}

