import 'package:todo_list/entity/create_todo.dart';
import 'package:todo_list/model/todo.dart';

import 'db_helper.dart';

class TodoService {
  Future<void> add(CreateTodo newItems) async {
    await DBHelper.database.insert('todo', newItems.toMap());
  }

  Future<void> remove(int itemId) async {
    await DBHelper.database.delete(
      'todo',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [itemId],
    );
  }

  Future<List<Todo>> getAllTodo() async {
    final List<Map<String, dynamic>> maps =
        await DBHelper.database.query('todo');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        description: maps[i]['description'],
        isCompleted: maps[i]['isCompleted'],
      );
    });
  }

  Future<void> update(Todo items) async {
    await DBHelper.database.update(
      'todo',
      items.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [items.id],
    );
  }
}
