import 'package:flutter/material.dart';
import '../models/todo_item.dart';

/// A reusable widget that displays a single todo item
/// This widget follows the Single Responsibility Principle by only handling todo item display
class TodoItemWidget extends StatelessWidget {
  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2.0,
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
          activeColor: Colors.green,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            color: todo.isCompleted 
                ? Colors.grey 
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: todo.isCompleted 
                ? FontWeight.normal 
                : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _formatDate(todo.createdAt),
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!todo.isCompleted)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context),
                tooltip: 'Edit todo',
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete todo',
            ),
          ],
        ),
      ),
    );
  }

  /// Formats the date in a user-friendly way
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Shows a dialog to edit the todo title
  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: todo.title);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter todo title',
            border: OutlineInputBorder(),
          ),
          maxLength: 100,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onEdit(value.trim());
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                onEdit(newTitle);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
