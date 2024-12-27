
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/page.dart';
import 'package:lista_de_tarefas/view/components/task_card.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TasksPage extends StatefulWidget implements MyPage{
  const TasksPage({super.key, required this.label, required this.icon, this.onLoad});

  @override
  final String label;
  
  @override
  final Icon icon;

  @override
  final Function? onLoad;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<int> _selectedTaskCards = [];
  bool inSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    var todoListState = context.watch<TodoListState>();

    void onSelected(int id, bool isSelected) {
      
      if (!inSelectionMode) {
        setState(() {
          inSelectionMode = true;
        });

        log('Entered selection mode');
      }
      
      if (!isSelected) {
        log('Card with being removed from list');
        setState(() {
          _selectedTaskCards.remove(id);
        });
        
      } else {
        log('Card with being added to list');
        setState(() {
          _selectedTaskCards.add(id);
        });
      }

      if (_selectedTaskCards.isEmpty) {
        setState(() {
          inSelectionMode = false;
        });
        log('Exited selection mode');
      }
      log(_selectedTaskCards.length.toString());
      log(id.toString());
    }

    void deleteSelected () {
      _selectedTaskCards.forEach((int id) {
        todoListState.deleteTask(id);
      });
      _selectedTaskCards.clear();
      setState(() {
        inSelectionMode = false;
      });
    }

    var tasks = todoListState.taskList.tasks;
    if (tasks.isEmpty) {
      return const Center(
        child: Text('Nenhuma tarefa ainda.'),
      );
    }
    
    return Column(
      children: [
        if (inSelectionMode) 
          Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_selectedTaskCards.length} tasks selected', style: const TextStyle(color: Colors.white),),
                IconButton(onPressed: deleteSelected, icon: const Icon(Icons.delete_outline), color: Colors.white),
              ],
            ),
          ),
        for (Task t in tasks)
          TaskCard(t, state: todoListState, onSelected: onSelected, inSelectionMode: inSelectionMode),
      ]
    );
  }
}