import '../models/todo_item.dart';

/// Service class that manages todo items
/// This class follows the Single Responsibility Principle by only handling todo data
class TodoService {
  final List<TodoItem> _todos = [];

  /// Returns a copy of all todos to prevent external modification
  List<TodoItem> get todos => List.unmodifiable(_todos);

  /// Returns the number of todos
  int get todoCount => _todos.length;

  /// Returns the number of completed todos
  int get completedCount => _todos.where((todo) => todo.isCompleted).length;

  /// Returns the number of pending todos
  int get pendingCount => _todos.where((todo) => !todo.isCompleted).length;

  /// Adds a new todo item
  /// Returns true if successful, false if title is empty
  bool addTodo(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return false;
    }

    final newTodo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: trimmedTitle,
      createdAt: DateTime.now(),
    );

    _todos.add(newTodo);
    return true;
  }

  /// Removes a todo item by ID
  /// Returns true if the item was found and removed, false otherwise
  bool removeTodo(String id) {
    final initialLength = _todos.length;
    _todos.removeWhere((todo) => todo.id == id);
    return _todos.length < initialLength;
  }

  /// Toggles the completed status of a todo item
  /// Returns true if the item was found and updated, false otherwise
  bool toggleTodoStatus(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return false;
    }

    _todos[index] = _todos[index].toggleCompleted();
    return true;
  }

  /// Updates the title of a todo item
  /// Returns true if successful, false if todo not found or title is empty
  bool updateTodoTitle(String id, String newTitle) {
    final trimmedTitle = newTitle.trim();
    if (trimmedTitle.isEmpty) {
      return false;
    }

    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return false;
    }

    _todos[index] = _todos[index].copyWith(title: trimmedTitle);
    return true;
  }

  /// Removes all completed todos
  /// Returns the number of todos that were removed
  int clearCompleted() {
    final initialLength = _todos.length;
    _todos.removeWhere((todo) => todo.isCompleted);
    return initialLength - _todos.length;
  }

  /// Checks if a todo with the given title already exists
  bool todoExists(String title) {
    final trimmedTitle = title.trim().toLowerCase();
    return _todos.any((todo) => todo.title.toLowerCase() == trimmedTitle);
  }
}
