class Task {
  final String id;
  final String name;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Task({
    required this.id,
    required this.name,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
  });
}
