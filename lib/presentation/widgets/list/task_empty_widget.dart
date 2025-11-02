import 'package:flutter/material.dart';

class TaskEmptyWidget extends StatelessWidget {
  const TaskEmptyWidget({super.key});

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
