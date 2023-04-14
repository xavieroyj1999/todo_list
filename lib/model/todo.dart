class Todo {
  final int id;
  final String description;
  final int isCompleted;

  const Todo({
    required this.id,
    required this.description,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
