import 'package:flutter/material.dart';

/// A reusable widget for adding new todo items
/// This widget follows the Single Responsibility Principle by only handling todo input
class AddTodoWidget extends StatefulWidget {
  final Function(String) onAddTodo;
  final bool Function(String) isDuplicate;

  const AddTodoWidget({
    super.key,
    required this.onAddTodo,
    required this.isDuplicate,
  });

  @override
  State<AddTodoWidget> createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends State<AddTodoWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Add a new todo...',
                    border: const OutlineInputBorder(),
                    errorText: _errorMessage,
                    prefixIcon: const Icon(Icons.add_task),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearInput,
                          )
                        : null,
                  ),
                  maxLength: 100,
                  textInputAction: TextInputAction.done,
                  onChanged: _onTextChanged,
                  onSubmitted: (_) => _addTodo(),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton.icon(
                onPressed: _controller.text.trim().isEmpty ? null : _addTodo,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ],
          ),
          if (_errorMessage != null)
            const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  /// Handles text changes and updates the error message
  void _onTextChanged(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _errorMessage = null;
      } else if (value.trim().length < 3) {
        _errorMessage = 'Todo must be at least 3 characters';
      } else if (widget.isDuplicate(value.trim())) {
        _errorMessage = 'This todo already exists';
      } else {
        _errorMessage = null;
      }
    });
  }

  /// Adds a new todo if the input is valid
  void _addTodo() {
    final title = _controller.text.trim();
    
    if (title.isEmpty) {
      _setError('Please enter a todo');
      return;
    }
    
    if (title.length < 3) {
      _setError('Todo must be at least 3 characters');
      return;
    }
    
    if (widget.isDuplicate(title)) {
      _setError('This todo already exists');
      return;
    }

    // Add the todo
    widget.onAddTodo(title);
    
    // Clear the input and show success feedback
    _clearInput();
    _showSuccessMessage();
  }

  /// Sets an error message and updates the UI
  void _setError(String message) {
    setState(() {
      _errorMessage = message;
    });
    _focusNode.requestFocus();
  }

  /// Clears the input field and error message
  void _clearInput() {
    setState(() {
      _controller.clear();
      _errorMessage = null;
    });
  }

  /// Shows a brief success message
  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todo added successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
}
