import 'package:hive/hive.dart';
import '../models/task_model.dart';
import '../../domain/entities/task.dart';
import 'task_local_data_source.dart';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskModel> taskBox;

  TaskLocalDataSourceImpl({required this.taskBox});

  @override
  Future<List<Task>> getAllTasks() async {
    final taskModels = taskBox.values.toList();
    return taskModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Task?> getTaskById(String taskId) async {
    final taskModel = taskBox.get(taskId);
    if (taskModel == null) return null;
    return taskModel.toEntity();
  }

  @override
  Future<void> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await taskBox.put(task.id, taskModel);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await taskBox.put(task.id, taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await taskBox.delete(taskId);
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    final allTasks = await getAllTasks();
    final lowerCaseQuery = query.toLowerCase().trim();

    if (lowerCaseQuery.isEmpty) {
      return allTasks;
    }

    return allTasks.where((task) {
      final nameMatch = task.name.toLowerCase().contains(lowerCaseQuery);
      final descriptionMatch =
          task.description?.toLowerCase().contains(lowerCaseQuery) ?? false;
      return nameMatch || descriptionMatch;
    }).toList();
  }
}
