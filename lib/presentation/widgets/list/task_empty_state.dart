import 'package:flutter/material.dart';

class TaskEmptyState extends StatelessWidget {
  const TaskEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No tasks found',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
