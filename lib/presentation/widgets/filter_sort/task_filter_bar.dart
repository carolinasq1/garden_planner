import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/task_filter_type.dart';
import '../../bloc/task_bloc.dart';

class TaskFilterBar extends StatefulWidget {
  const TaskFilterBar({super.key});

  @override
  State<TaskFilterBar> createState() => _TaskFilterBarState();
}

class _TaskFilterBarState extends State<TaskFilterBar> {
  TaskFilterType _selectedFilter = TaskFilterType.all;

  void _onFilterSelected(TaskFilterType filterType) {
    setState(() {
      _selectedFilter = filterType;
    });
    context.read<TaskBloc>().add(FilterTasksEvent(filterType));
  }

  Widget _buildFilterChip(String label, TaskFilterType filterType) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == filterType,
      onSelected: (_) => _onFilterSelected(filterType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Filter:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('All', TaskFilterType.all),
                _buildFilterChip('Completed', TaskFilterType.completed),
                _buildFilterChip('Incomplete', TaskFilterType.incomplete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
