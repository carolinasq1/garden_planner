import 'package:flutter/material.dart';

class TaskLoadingState extends StatelessWidget {
  const TaskLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

