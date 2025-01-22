import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/pages/page.dart';
import 'package:lista_de_tarefas/view/components/cards/task_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksPage extends StatefulWidget implements MyPage{
  const TasksPage({super.key, required this.label, required this.icon, this.onLoad, required this.onAddTask, required this.onCancel});

  @override
  final String label;
  
  @override
  final Icon icon;

  @override
  final Function? onLoad;

  final VoidCallback onAddTask;

  final VoidCallback onCancel;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<int> _selectedTaskCards = [];
  bool inSelectionMode = false;
  bool shouldDisplayDate = false;
  DateTime? previousDate;
  late SortByOption selectedSortByOption;
  late bool reverseSort;

  void _onSelected(int id, bool isSelected) {
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

  void _showFilters (BuildContext context, TodoListState todoListState, AppLocalizations localization) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) => 
          AlertDialog(
            contentPadding: const EdgeInsets.all(16),
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
                          child: Text(localization.select, style: Theme.of(context).textTheme.bodyMedium)
                        ),
                      items: [
                        DropdownMenuItem(
                          value: SortByOption.dueDate,
                          child: Text(localization.dueDate, style: Theme.of(context).textTheme.bodyMedium)
                        ),
                        DropdownMenuItem(
                          value: SortByOption.creationDate,
                          child: Text(localization.creationDate, style: Theme.of(context).textTheme.bodyMedium)
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

  @override
  void initState() {
    var state = context.read<TodoListState>();
    selectedSortByOption = state.selectedSortByOption;
    reverseSort = state.reverseSort;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var todoListState = context.watch<TodoListState>();
    AppLocalizations localization = AppLocalizations.of(context)!;

    void deleteSelected () {
      for (int id in _selectedTaskCards) {
        todoListState.deleteTask(id);
      }
      _selectedTaskCards.clear();
      setState(() {
        inSelectionMode = false;
      });
    }

    if (todoListState.selectedTaskList == null) {
      return Center(child: Text(localization.noTaskListSelected));
    }

    String selectionMenuText = localization.nTasksSelected(_selectedTaskCards.length);

    double iconSize = 30;

    var tasks = todoListState.selectedTaskList!.tasks;

    //* Lógica decidindo se vai mostrar a data de criação ou conclusão da tarefa
    List<Column> orderedTaskCards;
    switch (selectedSortByOption) {
      case SortByOption.dueDate:
        orderedTaskCards = _getTaskCardListByDueDate(tasks, localization);
        break;
      case SortByOption.creationDate:
        orderedTaskCards = _getTaskCardListByCreationDate(tasks, localization);
        break;
    }

    List<Widget> taskListView;
    if (todoListState.isLoading) {
      taskListView = [Center(child: LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).primaryColor, size: 30))];
    } else if (tasks.isEmpty) {
      taskListView = [Center( child: Text(localization.noTasksYet))];
    } else {
      taskListView = orderedTaskCards;
    }
    
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

        //* Barra superior com icones
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color:Theme.of(context).colorScheme.onSurface, width: 0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //* Botão voltar
              IconButton(onPressed: widget.onCancel, icon: Icon(Icons.arrow_back, size: iconSize,)),

              //* Nome da task list
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  todoListState.selectedTaskList!.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary)
                ),
              )),

              //* Botão nova task
              IconButton(onPressed: widget.onAddTask, icon: Icon(Icons.add_circle, size: iconSize)),

              //* Botão de filtragem
              IconButton(onPressed: () {_showFilters(context, todoListState, localization);}, icon: Icon(Icons.tune, size: iconSize)),
            ],
          ),
        ),

        //* Texto dizendo qual opção de ordenamento está sendo usada
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
          child: Text(
            localization.bySelected(selectedSortByOption.toString().split('.')[1]),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
         
        //* Lista de tasks
        Column(
          children: taskListView,
        ),
      ]
    );
  }

  List<Column> _getTaskCardListByDueDate (List<Task> tasks, AppLocalizations localization) {
    bool reachedNoDueDate = false;
    previousDate = null;
    return tasks.map<Column>((Task task) {

      if (task.dueDate == null) {
        previousDate = null;
        if (!reachedNoDueDate) {
          reachedNoDueDate = true;
          return Column(
            children: [
              Center(child: Text(localization.noDueDate)),
              TaskCard(task, onSelected: _onSelected, inSelectionMode: inSelectionMode),
            ],
          );
        } else {
          return Column(
            children: [
              TaskCard(task, onSelected: _onSelected, inSelectionMode: inSelectionMode),
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
            Center(child: Text(localization.dateOn(task.dueDate!)),),
          TaskCard(task, onSelected: _onSelected, inSelectionMode: inSelectionMode),
        ],
      );
    }).toList();
  }

  List<Column> _getTaskCardListByCreationDate (List<Task> tasks, AppLocalizations localization) {
    previousDate = null;
    return tasks.map<Column>((Task task) {
      shouldDisplayDate = false;

      DateTime creationDateNoTime = DateTime(task.creationDate.year, task.creationDate.month, task.creationDate.day);
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
            Center(child: Text(localization.dateOn(task.creationDate)),),
          TaskCard(task, onSelected: _onSelected, inSelectionMode: inSelectionMode),
        ],
      );
    }).toList();
  }
}