import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../pages/task_form_page.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final bloc = BlocProvider.of<TaskBloc>(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                BlocProvider.value(value: bloc, child: const TaskFormPage()),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
