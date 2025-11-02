import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/task_sort_type.dart';
import '../../bloc/task_bloc.dart';

class TaskSortBar extends StatelessWidget {
  const TaskSortBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Sort by:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          _SortDropdown(),
        ],
      ),
    );
  }
}

class _SortDropdown extends StatefulWidget {
  @override
  State<_SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<_SortDropdown> {
  TaskSortType _selectedSort = TaskSortType.dateCreated;

  final Map<TaskSortType, String> _sortOptions = {
    TaskSortType.dateCreated: 'Date Created',
    TaskSortType.alphabetical: 'Alphabetical',
    TaskSortType.completionStatus: 'Completion Status',
  };

  void _onSortSelected(TaskSortType sortType) {
    setState(() {
      _selectedSort = sortType;
    });
    context.read<TaskBloc>().add(SortTasksEvent(sortType));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButton<TaskSortType>(
        value: _selectedSort,
        isExpanded: false,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        dropdownColor: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        items: _sortOptions.entries.map((entry) {
          return DropdownMenuItem<TaskSortType>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (TaskSortType? newValue) {
          if (newValue != null) {
            _onSortSelected(newValue);
          }
        },
      ),
    );
  }
}
