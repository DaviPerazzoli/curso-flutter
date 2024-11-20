import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/app_page.dart';
import 'package:provider/provider.dart';

class NewTaskPage extends StatelessWidget implements AppPage{
  const NewTaskPage({super.key});

  @override
  String get label => 'New task';

  @override
  Icon get icon => const Icon(Icons.add_circle);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TodoListState>();

    return ElevatedButton.icon(
      onPressed: state.deleteAllTasks,
      label: const Text('Delete all tasks'),
      icon: const Icon(Icons.delete_forever),
      );
  }
  

}