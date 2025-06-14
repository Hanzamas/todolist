import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../widgets/todo_item_widget.dart';

/// A widget that displays a list of todos with different filter options
/// This widget follows the Single Responsibility Principle by only handling todo list display
class TodoListWidget extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(String) onToggleTodo;
  final Function(String) onDeleteTodo;
  final Function(String, String) onEditTodo;

  const TodoListWidget({
    super.key,
    required this.todos,
    required this.onToggleTodo,
    required this.onDeleteTodo,
    required this.onEditTodo,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItemWidget(
          todo: todo,
          onToggle: () => onToggleTodo(todo.id),
          onDelete: () => _showDeleteConfirmation(context, todo),
          onEdit: (newTitle) => onEditTodo(todo.id, newTitle),
        );
      },
    );
  }

  /// Builds the empty state when there are no todos
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80.0,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16.0),
          Text(
            'No todos yet!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Add your first todo to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog before deleting a todo
  void _showDeleteConfirmation(BuildContext context, TodoItem todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDeleteTodo(todo.id);
              Navigator.of(context).pop();
              _showDeleteSuccessMessage(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Shows a success message after deleting a todo
  void _showDeleteSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todo deleted successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}
