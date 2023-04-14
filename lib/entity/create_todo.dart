class CreateTodo {
  final String description;
  final int isCompleted;

  CreateTodo({required this.description, required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
