import 'package:flutter/material.dart';

class SaveTaskButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEditing;

  const SaveTaskButton({
    super.key,
    required this.onPressed,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(isEditing ? 'Update Task' : 'Create Task'),
    );
  }
}
