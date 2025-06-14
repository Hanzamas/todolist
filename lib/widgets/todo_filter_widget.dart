import 'package:flutter/material.dart';
import '../models/todo_item.dart';

/// Enum for different filter options
enum TodoFilter {
  all,
  pending,
  completed,
}

/// A widget that provides filtering options for todos
/// This widget follows the Single Responsibility Principle by only handling filter UI
class TodoFilterWidget extends StatelessWidget {
  final TodoFilter selectedFilter;
  final Function(TodoFilter) onFilterChanged;
  final List<TodoItem> todos;
  final VoidCallback? onClearCompleted;

  const TodoFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.todos,
    this.onClearCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = todos.where((todo) => todo.isCompleted).length;
    final pendingCount = todos.where((todo) => !todo.isCompleted).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    context,
                    'All (${todos.length})',
                    TodoFilter.all,
                    Icons.list,
                  ),
                  const SizedBox(width: 8.0),
                  _buildFilterChip(
                    context,
                    'Pending ($pendingCount)',
                    TodoFilter.pending,
                    Icons.pending,
                  ),
                  const SizedBox(width: 8.0),
                  _buildFilterChip(
                    context,
                    'Completed ($completedCount)',
                    TodoFilter.completed,
                    Icons.check_circle,
                  ),
                ],
              ),
            ),
          ),
          
          // Clear completed button
          if (completedCount > 0 && onClearCompleted != null) ...[
            const SizedBox(width: 8.0),
            IconButton(
              onPressed: () => _showClearCompletedConfirmation(context),
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear completed todos',
              color: Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a filter chip for the given filter option
  Widget _buildFilterChip(
    BuildContext context,
    String label,
    TodoFilter filter,
    IconData icon,
  ) {
    final isSelected = selectedFilter == filter;
    
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.0,
            color: isSelected 
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4.0),
          Text(label),
        ],
      ),
      onSelected: (_) => onFilterChanged(filter),
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: isSelected 
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// Shows a confirmation dialog before clearing completed todos
  void _showClearCompletedConfirmation(BuildContext context) {
    final completedCount = todos.where((todo) => todo.isCompleted).length;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed'),
        content: Text(
          'Are you sure you want to remove all $completedCount completed todos?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onClearCompleted?.call();
              Navigator.of(context).pop();
              _showClearSuccessMessage(context, completedCount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Shows a success message after clearing completed todos
  void _showClearSuccessMessage(BuildContext context, int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count completed todos cleared!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}
