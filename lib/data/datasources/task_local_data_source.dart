import '../../domain/entities/task.dart';

abstract class TaskLocalDataSource {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(String taskId);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
