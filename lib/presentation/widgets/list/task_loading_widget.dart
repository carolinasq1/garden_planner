import 'package:flutter/material.dart';

class TaskLoadingWidget extends StatelessWidget {
  const TaskLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

