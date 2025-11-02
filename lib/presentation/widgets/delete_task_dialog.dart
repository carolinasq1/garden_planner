import 'package:flutter/material.dart';

class DeleteTaskDialog extends StatelessWidget {
  final String taskName;

  const DeleteTaskDialog({super.key, required this.taskName});

  static Future<bool?> show(BuildContext context, String taskName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteTaskDialog(taskName: taskName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Task'),
      content: Text('Are you sure you want to delete "$taskName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
