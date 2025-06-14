import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../services/todo_service.dart';
import '../widgets/add_todo_widget.dart';
import '../widgets/todo_list_widget.dart';
import '../widgets/todo_stats_widget.dart';
import '../widgets/todo_filter_widget.dart';

/// The main screen of the todo application
/// This screen follows the Single Responsibility Principle by only handling screen layout and state management
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoService _todoService = TodoService();
  TodoFilter _selectedFilter = TodoFilter.all;

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _getFilteredTodos();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Todo List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          if (_todoService.todoCount > 0)
            IconButton(
              onPressed: _showAppInfo,
              icon: const Icon(Icons.info_outline),
              tooltip: 'App info',
            ),
        ],
      ),
      body: Column(
        children: [
          // Statistics section
          TodoStatsWidget(
            totalTodos: _todoService.todoCount,
            completedTodos: _todoService.completedCount,
            pendingTodos: _todoService.pendingCount,
          ),

          // Filter section
          if (_todoService.todoCount > 0)
            TodoFilterWidget(
              selectedFilter: _selectedFilter,
              onFilterChanged: _onFilterChanged,
              todos: _todoService.todos,
              onClearCompleted: _todoService.completedCount > 0 
                  ? _clearCompleted 
                  : null,
            ),

          // Todo list section
          Expanded(
            child: TodoListWidget(
              todos: filteredTodos,
              onToggleTodo: _toggleTodo,
              onDeleteTodo: _deleteTodo,
              onEditTodo: _editTodo,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AddTodoWidget(
        onAddTodo: _addTodo,
        isDuplicate: _todoService.todoExists,
      ),
    );
  }
  /// Returns todos filtered based on the selected filter
  List<TodoItem> _getFilteredTodos() {
    switch (_selectedFilter) {
      case TodoFilter.pending:
        return _todoService.todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return _todoService.todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
        return _todoService.todos;
    }
  }

  /// Handles filter changes
  void _onFilterChanged(TodoFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  /// Adds a new todo
  void _addTodo(String title) {
    setState(() {
      _todoService.addTodo(title);
    });
  }

  /// Toggles the completion status of a todo
  void _toggleTodo(String id) {
    setState(() {
      _todoService.toggleTodoStatus(id);
    });
  }

  /// Deletes a todo
  void _deleteTodo(String id) {
    setState(() {
      _todoService.removeTodo(id);
    });
  }

  /// Edits a todo's title
  void _editTodo(String id, String newTitle) {
    setState(() {
      final success = _todoService.updateTodoTitle(id, newTitle);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todo updated successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
          ),
        );
      }
    });
  }

  /// Clears all completed todos
  void _clearCompleted() {
    setState(() {
      _todoService.clearCompleted();
    });
  }

  /// Shows app information dialog
  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Todo List App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A simple and intuitive todo list application.'),
            SizedBox(height: 16.0),
            Text('Features:'),
            Text('• Add new todos'),
            Text('• Mark todos as complete'),
            Text('• Edit existing todos'),
            Text('• Delete todos'),
            Text('• Filter by status'),
            Text('• View progress statistics'),
            SizedBox(height: 16.0),
            Text(
              'Built with Flutter using clean, modular architecture.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
