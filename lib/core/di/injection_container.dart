import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/task_local_data_source.dart';
import '../../data/datasources/task_local_data_source_impl.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/use_cases/create_task_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/edit_task_use_case.dart';
import '../../domain/use_cases/get_all_tasks_use_case.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(TaskModelAdapter());

  // Open Hive Boxes
  final taskBox = await Hive.openBox<TaskModel>('tasks');
  getIt.registerLazySingleton<Box<TaskModel>>(() => taskBox);

  // Register Data Sources
  final dataSource = TaskLocalDataSourceImpl(taskBox: taskBox);
  getIt.registerLazySingleton<TaskLocalDataSource>(() => dataSource);

  // Register Repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: getIt()),
  );

  // Register Use Cases
  getIt.registerLazySingleton(() => CreateTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllTasksUseCase(getIt()));
  getIt.registerLazySingleton(() => EditTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteTaskUseCase(getIt()));
}
