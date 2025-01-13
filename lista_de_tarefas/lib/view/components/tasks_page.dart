import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/page.dart';
import 'package:lista_de_tarefas/view/components/task_card.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    AppLocalizations localization = AppLocalizations.of(context)!;

    void onSelected(int id, bool isSelected) {
      
      if (!inSelectionMode) {
        setState(() {
          inSelectionMode = true;
        });
      }
      
      if (!isSelected) {
        setState(() {
          _selectedTaskCards.remove(id);
        });
        
      } else {
        setState(() {
          _selectedTaskCards.add(id);
        });
      }

      if (_selectedTaskCards.isEmpty) {
        setState(() {
          inSelectionMode = false;
        });
      }
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

    String selectionMenuText = localization.nTasksSelected(_selectedTaskCards.length);

    var tasks = todoListState.taskList.tasks;
    if (tasks.isEmpty) {
      return Center(
        child: Text(localization.noTasksYet),
      );
    }

    List<Column> viewTaskList = tasks.map<Column>((Task task) {
      if (tasks.indexOf(task) == 0 && task.dueDate == null) {
        return Column(
          children: [
            Center(child: Text(localization.noDueDate)),
            TaskCard(task, onSelected: onSelected, inSelectionMode: inSelectionMode),
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
          TaskCard(task, onSelected: onSelected, inSelectionMode: inSelectionMode),
        ],
      );
    }).toList();
    
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
                Text(selectionMenuText, 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize
                  ),
                ),
                IconButton(onPressed: deleteSelected, icon: const Icon(Icons.delete_outline), color: Colors.white),
              ],
            ),
          ), 
          crossFadeState: inSelectionMode? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Column(
          children: viewTaskList,
        ) 
          
      ]
    );
  }
}