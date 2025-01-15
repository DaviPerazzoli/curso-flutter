import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/page.dart';
import 'package:lista_de_tarefas/view/components/task_card.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class TasksPage extends StatefulWidget implements MyPage{
  TasksPage({super.key, required this.label, required this.icon, this.onLoad, required this.reverseSort, required this.selectedSortByOption});

  @override
  final String label;
  
  @override
  final Icon icon;

  @override
  final Function? onLoad;

  @override
  State<TasksPage> createState() => _TasksPageState();
  
  bool? reverseSort;
  
  SortByOption? selectedSortByOption;
}

class _TasksPageState extends State<TasksPage> {
  final List<int> _selectedTaskCards = [];
  bool inSelectionMode = false;
  bool shouldDisplayDate = false;
  DateTime? previousDate;
  late SortByOption selectedSortByOption = widget.selectedSortByOption ?? SortByOption.dueDate;
  late bool reverseSort = widget.reverseSort ?? false;

  @override
  Widget build(BuildContext context) {
    widget.reverseSort = reverseSort;
    widget.selectedSortByOption = selectedSortByOption;
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
      for (int id in _selectedTaskCards) {
        todoListState.deleteTask(id);
      }
      _selectedTaskCards.clear();
      setState(() {
        inSelectionMode = false;
      });
    }

    void showFilters () {
      log("Filters button clicked");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) => 
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localization.filters,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  //* Para fechar: Navigator.of(context).pop();
                  Row(
                    children: [
                      Expanded(child: Text(localization.sortBy)),
                      const SizedBox(width: 10),
                      DropdownButton(
                        value: selectedSortByOption,
                        hint: DropdownMenuItem(
                            child: Text(localization.select)
                          ),
                        items: [
                          DropdownMenuItem(
                            value: SortByOption.dueDate,
                            child: Text(localization.dueDate)
                          ),
                          DropdownMenuItem(
                            value: SortByOption.creationDate,
                            child: Text(localization.creationDate)
                          ),
                        ], 
                        onChanged: (SortByOption? opt) {
                          if (opt != null) {
                            setState(() {
                              selectedSortByOption = opt;
                            });
                          }
                        }
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            reverseSort = !reverseSort;
                          });
                        }, 
                        // Esse IconButton abaixo:
                        icon: Icon(reverseSort? Icons.arrow_drop_up: Icons.arrow_drop_down)
                      )
                    ],
                  ),

                  //* Ok button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                          foregroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary)
                        ),
                        onPressed: () {
                          todoListState.sortTasksBy(selectedSortByOption, reverseSort);
                          Navigator.of(context).pop();
                        }, 
                        child: Text(localization.ok)
                      )
                    ],
                  )
                ],
              ),
            )
          );
          
        },
      );
    }

    String selectionMenuText = localization.nTasksSelected(_selectedTaskCards.length);

    var tasks = todoListState.taskList.tasks;
    if (tasks.isEmpty) {
      return Center(
        child: Text(localization.noTasksYet),
      );
    }

    //* Lógica decidindo se vai mostrar a data de criação ou conclusão da tarefa
    bool reachedNoDueDate = false;
    List<Column> viewTaskList = tasks.map<Column>((Task task) {
      if (selectedSortByOption == SortByOption.dueDate) {
        if (task.dueDate == null) {
          previousDate = null;
          if (!reachedNoDueDate) {
            reachedNoDueDate = true;
            return Column(
              children: [
                Center(child: Text(localization.noDueDate)),
                TaskCard(task, onSelected: onSelected, inSelectionMode: inSelectionMode),
              ],
            );
          } else {
            return Column(
              children: [
                TaskCard(task, onSelected: onSelected, inSelectionMode: inSelectionMode),
              ],
            );
          }
        } else {
          shouldDisplayDate = false;

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
      } else {
        shouldDisplayDate = false;

        DateTime? creationDateNoTime = DateTime(task.creationDate.year, task.creationDate.month, task.creationDate.day);
        if (previousDate == null) {
          shouldDisplayDate = true;
        } else {
          
          if (!creationDateNoTime.isAtSameMomentAs(previousDate!)) {
            shouldDisplayDate = true;
          }
        }
        previousDate = creationDateNoTime;

        return Column(
          children: [
            if (shouldDisplayDate)
              Center(child: Text(task.readableCreationDate.split(' ')[0]),),
            TaskCard(task, onSelected: onSelected, inSelectionMode: inSelectionMode),
          ],
        );
      }
      

      
    }).toList();
    
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
        //* Barra superior com icones (por enquanto apenas filtros)
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color:Theme.of(context).shadowColor, width: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              IconButton(onPressed: showFilters, icon: const Icon(Icons.tune))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Text(localization.bySelected(selectedSortByOption.toString().split('.')[1])),
        ),
         
        //* Lista de tasks
        Column(
          children: viewTaskList,
        ) 
          
      ]
    );
  }
}