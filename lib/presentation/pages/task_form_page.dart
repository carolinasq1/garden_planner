import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../widgets/form/task_name_field.dart';
import '../widgets/form/task_description_field.dart';
import '../widgets/form/create_task_button.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final descriptionOrNull = description.isEmpty ? null : description;

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: descriptionOrNull,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      context.read<TaskBloc>().add(CreateTaskEvent(newTask));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New Task')),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TaskNameField(controller: _nameController),
              const SizedBox(height: 24),
              TaskDescriptionField(controller: _descriptionController),
              const SizedBox(height: 24),
              CreateTaskButton(onPressed: _saveTask),
            ],
          ),
        ),
      ),
    );
  }
}
