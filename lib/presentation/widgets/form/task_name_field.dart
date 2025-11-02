import 'package:flutter/material.dart';

class TaskNameField extends StatelessWidget {
  final TextEditingController controller;

  const TaskNameField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Name *',
        hintText: 'Enter task name',
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.sentences,
      autofocus: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name is required';
        }
        return null;
      },
    );
  }
}

