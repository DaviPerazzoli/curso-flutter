import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/app_page.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class AllTasksPage extends StatelessWidget implements AppPage{
  const AllTasksPage({super.key});

  @override
  String get label => 'All tasks';

  @override
  Icon get icon => const Icon(Icons.task);

  @override
  Widget build(BuildContext context) {
    var todoListState = context.watch<TodoListState>();

    var tasks = todoListState.taskList.tasks;
    if (tasks.isEmpty) {
      return Center(
        child: Text('Nenhuma tarefa disponível.'),
      );
    }
    
    return Column(
      children: [
        for (Task t in tasks)
          Text('${t.id.toString()} / ${t.title} / ${t.creationDate.toIso8601String()} / ${t.done.toString()}'),
      ]
      
        
    );
  }
  
  
  

}