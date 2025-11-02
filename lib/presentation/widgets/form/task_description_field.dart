import 'package:flutter/material.dart';

class TaskDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const TaskDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter task description',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      minLines: 3,
      keyboardType: TextInputType.multiline,
    );
  }
}

