import 'package:flutter/material.dart';
import 'package:todo_list/screen/home_screen.dart';
import 'package:todo_list/screen/todolist_screen.dart';
import 'package:todo_list/services/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper.initialiseDB(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MaterialApp(
            title: 'My App',
            home: HomeScreen(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
