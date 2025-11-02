import 'package:flutter/material.dart';

class CreateTaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateTaskButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Create Task'),
    );
  }
}

