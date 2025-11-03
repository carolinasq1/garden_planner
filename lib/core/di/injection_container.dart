import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/task_local_data_source.dart';
import '../../data/datasources/task_local_data_source_impl.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/datasources/weather_remote_data_source_impl.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/use_cases/create_task_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/edit_task_use_case.dart';
import '../../domain/use_cases/get_tasks_use_case.dart';
import '../../domain/use_cases/get_weather_use_case.dart';
import '../../presentation/bloc/weather_bloc.dart';
import '../utils/mock_data.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  final taskBox = await Hive.openBox<TaskModel>('tasks');
  getIt.registerLazySingleton<Box<TaskModel>>(() => taskBox);

  // Register data sources
  final dataSource = TaskLocalDataSourceImpl(taskBox: taskBox);
  getIt.registerLazySingleton<TaskLocalDataSource>(() => dataSource);

  // Register repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dio: getIt()),
  );

  // Register use cases
  getIt.registerLazySingleton(() => CreateTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTasksUseCase(getIt()));
  getIt.registerLazySingleton(() => EditTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => GetWeatherUseCase(getIt()));

  // Register dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerFactory<WeatherBloc>(
    () => WeatherBloc(getWeatherUseCase: getIt()),
  );

  // Add mock data if box is empty
  if (taskBox.isEmpty) {
    final mockTasks = getMockTasks();
    for (final task in mockTasks) {
      await dataSource.createTask(task);
    }
  }
}
