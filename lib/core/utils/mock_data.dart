import '../../domain/entities/task.dart';

List<Task> getMockTasks() {
  final now = DateTime.now();

  return [
    Task(
      id: '1',
      name: 'Plant Tomatoes',
      description: 'Plant tomato seeds',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 5)),
    ),
    Task(
      id: '2',
      name: 'Repot tomato plant',
      description: 'Repot tomato plant because it is growing too big',
      isCompleted: true,
      createdAt: now.subtract(const Duration(days: 3)),
      updatedAt: now.subtract(const Duration(days: 2)),
    ),
    Task(
      id: '3',
      name: 'Fertilize Vegetables',
      description: 'Apply compost to the cabbages',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Task(
      id: '4',
      name: 'Prune Roses',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Task(
      id: '5',
      name: 'Harvest Lettuce',
      description: 'Pick lettuce leaves',
      isCompleted: true,
      createdAt: now.subtract(const Duration(hours: 12)),
      updatedAt: now.subtract(const Duration(hours: 6)),
    ),
    Task(
      id: '6',
      name: 'Set Up Irrigation System',
      description: 'Install drip irrigation for the new beds',
      isCompleted: false,
      createdAt: now.subtract(const Duration(hours: 8)),
    ),
    Task(
      id: '7',
      name: 'Buy tomato seeds',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    Task(
      id: '8',
      name: 'Remove weeds',
      description: 'Remove weeds from the garden',
      isCompleted: false,
      createdAt: now.subtract(const Duration(hours: 2)),
    ),
    Task(
      id: '9',
      name: 'Reproduce plants',
      description: 'Reproduce plants for the garden',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 9)),
    ),
    Task(
      id: '10',
      name: 'Collect eggs',
      description: 'Collect eggs from the chickens',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Task(
      id: '11',
      name: 'Buy soil for the garden',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    Task(
      id: '12',
      name: 'Prune guava tree',
      description: 'prune guava tree so that it grows bigger',
      isCompleted: false,
      createdAt: now.subtract(const Duration(hours: 2)),
    ),
    Task(
      id: '13',
      name: 'Reproduce tomato plants',
      description: 'Reproduce tomato plants for the garden',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 9)),
    ),
    Task(
      id: '14',
      name: 'Buy pots',
      description: 'Buy pots for the tomato plants',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Task(
      id: '15',
      name: 'Water the plants',
      isCompleted: false,
      createdAt: now.subtract(const Duration(days: 4)),
    ),
  ];
}
