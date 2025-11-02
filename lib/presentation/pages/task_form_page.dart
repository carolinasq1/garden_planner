import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../widgets/form/task_name_field.dart';
import '../widgets/form/task_description_field.dart';
import '../widgets/form/save_task_button.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
  }

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

      if (_isEditing) {
        _updateTask(name, descriptionOrNull);
      } else {
        _createTask(name, descriptionOrNull);
      }
      Navigator.of(context).pop();
    }
  }

  void _createTask(String name, String? description) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    context.read<TaskBloc>().add(CreateTaskEvent(newTask));
  }

  void _updateTask(String name, String? description) {
    final updatedTask = widget.task!.copyWith(
      name: name,
      description: description,
      updatedAt: DateTime.now(),
    );

    context.read<TaskBloc>().add(EditTaskEvent(updatedTask));
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
        appBar: AppBar(title: Text(_isEditing ? 'Edit Task' : 'New Task')),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TaskNameField(
                controller: _nameController,
                autofocus: !_isEditing,
              ),
              const SizedBox(height: 24),
              TaskDescriptionField(controller: _descriptionController),
              const SizedBox(height: 24),
              SaveTaskButton(onPressed: _saveTask, isEditing: _isEditing),
            ],
          ),
        ),
      ),
    );
  }
}
