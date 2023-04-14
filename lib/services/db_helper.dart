import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static late Database database;

  static Future<void> initialiseDB() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE Table Todo(id INTEGER PRIMARY KEY, description TEXT, isCompleted INTEGER)',
        );
      },
      version: 1,
    );
  }
}
