
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
  bool shouldDisplayDate = false;
  DateTime? previousDate;

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
      for (var id in _selectedTaskCards) {
        todoListState.deleteTask(id);
      }
      _selectedTaskCards.clear();
      setState(() {
        inSelectionMode = false;
      });
    }

    String selectionMenuText = _selectedTaskCards.length > 1 ? '${_selectedTaskCards.length} tasks selected' : '${_selectedTaskCards.length} task selected';

    var tasks = todoListState.taskList.tasks;
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks yet'),
      );
    }
    
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectionMenuText, style: const TextStyle(color: Colors.white),),
                IconButton(onPressed: deleteSelected, icon: const Icon(Icons.delete_outline), color: Colors.white),
              ],
            ),
          ), 
          crossFadeState: inSelectionMode? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Column(
          children: tasks.map((Task task) {
            if (tasks.indexOf(task) == 0 && task.dueDate == null) {
              return Column(
                children: [
                  const Center(child: Text('No due date')),
                  TaskCard(task, state: todoListState, onSelected: onSelected, inSelectionMode: inSelectionMode),
                ],
              );
            }
            shouldDisplayDate = false;

            if (task.dueDate != null) {
              DateTime? dueDateNoTime = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
              if (previousDate == null) {
                shouldDisplayDate = true;
              } else {
                
                if (!dueDateNoTime.isAtSameMomentAs(previousDate!)) {
                  shouldDisplayDate = true;
                }
               
              }
              previousDate = dueDateNoTime;
            }

            return Column(
              children: [
                if (shouldDisplayDate)
                  Center(child: Text(task.readableDueDate.split(' ')[0]),),
                TaskCard(task, state: todoListState, onSelected: onSelected, inSelectionMode: inSelectionMode),
              ],
            );
          }).toList(),
        ) 
          
      ]
    );
  }
}