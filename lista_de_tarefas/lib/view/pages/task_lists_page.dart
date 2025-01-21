import 'package:flutter/material.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/pages/page.dart';
import 'package:lista_de_tarefas/view/components/cards/task_list_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskListsPage extends StatefulWidget implements MyPage{
  const TaskListsPage({super.key, required this.label, required this.icon, this.onLoad});

  @override
  final String label;
  
  @override
  final Icon icon;

  @override
  final Function? onLoad;

  @override
  State<TaskListsPage> createState() => _TaskListsPageState();
}

class _TaskListsPageState extends State<TaskListsPage> {
  final List<int> _selectedTaskListCards = [];
  bool inSelectionMode = false;

  void _onSelected(int id, bool isSelected) {
    if (!inSelectionMode) {
      setState(() {
        inSelectionMode = true;
      });
    }
    
    if (!isSelected) {
      setState(() {
        _selectedTaskListCards.remove(id);
      });
      
    } else {
      setState(() {
        _selectedTaskListCards.add(id);
      });
    }

    if (_selectedTaskListCards.isEmpty) {
      setState(() {
        inSelectionMode = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    TodoListState state = context.watch<TodoListState>();
    AppLocalizations localization = AppLocalizations.of(context)!;

    void deleteSelected () {
      for (int id in _selectedTaskListCards) {
        state.deleteTask(id);
      }
      _selectedTaskListCards.clear();
      setState(() {
        inSelectionMode = false;
      });
    }
    
    if (state.taskLists.isEmpty) {
      return Center(child: Text(localization.noTaskLists));
    }

    String selectionMenuText = localization.nTaskListsSelected(_selectedTaskListCards.length);

    List<TaskListCard> viewTaskLists = state.taskLists.map(
      (TaskList taskList) => TaskListCard(taskList, onSelected: _onSelected, inSelectionMode: inSelectionMode)
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Barra superior do modo de seleção
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
         
        //* Lista de task lists
        Column(
          children: viewTaskLists,
        ),   
      ]
    );

  }
}