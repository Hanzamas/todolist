/// Model class representing a single todo item
class TodoItem {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  const TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Creates a copy of this TodoItem with updated properties
  TodoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Creates a new TodoItem with the completed status toggled
  TodoItem toggleCompleted() {
    return copyWith(isCompleted: !isCompleted);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TodoItem(id: $id, title: $title, isCompleted: $isCompleted, createdAt: $createdAt)';
  }
}
