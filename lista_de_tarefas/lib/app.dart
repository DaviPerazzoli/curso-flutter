import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'view/home_page.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TodoListState state = TodoListState();
    return ChangeNotifierProvider(
      create: (context) => state,
      child: MaterialApp(
          title: 'Todo List App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            useMaterial3: true,
          ),
          home: const HomePage(),
      ),
    );
          
  }
}
