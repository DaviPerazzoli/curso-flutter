import 'package:flutter/material.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

void main() {
  runApp(const MainApp());
  TaskList list = TaskList([]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
