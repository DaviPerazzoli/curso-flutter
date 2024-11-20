import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/page.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TasksPage extends StatelessWidget implements MyPage{
  const TasksPage({super.key, required this.label, required this.icon});

  @override
  final String label;
  @override
  final Icon icon;

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