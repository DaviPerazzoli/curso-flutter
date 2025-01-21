import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/cards/card.dart';
import 'package:lista_de_tarefas/view/components/edit_task_form.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskCard extends StatefulWidget implements MyCard{
  final Task _task;

  @override
  final Function(int, bool)? onSelected;

  @override
  final bool inSelectionMode;

  const TaskCard(this._task,{super.key, this.onSelected, required this.inSelectionMode});

  @override
  int get id => _task.id!;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isSelected = false;
  late bool isDone;
  bool isExpanded = false;

  void onCardSelected () {
    setState(() {
        isSelected = !isSelected;
    });
    widget.onSelected?.call(widget.id, isSelected);
  }

  void showTaskDetails () {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    TodoListState state = context.watch<TodoListState>();
    isDone = widget._task.done;

    void onDonePressed() {
      widget._task.done = !widget._task.done;
      state.updateTask(widget._task);
      setState(() {
        isDone = widget._task.done;
      });
    }

    // This is necessary when excluding task cards
    if (!widget.inSelectionMode) {
      setState(() {
        isSelected = false;
      });
    }

    Color cardColor;

    if (isSelected) {
      cardColor = Theme.of(context).primaryColorLight;
    } else if (widget._task.isLate) {
      cardColor = const Color.fromARGB(255, 248, 190, 186);
    } else {
      cardColor = Theme.of(context).cardColor;
    }

    Color doneIconColor = isDone ? Colors.green : Theme.of(context).primaryColorLight;
    TextStyle? taskTitleStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? taskDetailsStyle = Theme.of(context).textTheme.bodyMedium;
    
    return GestureDetector(
      onLongPress: onCardSelected,
      onTap: () {
        if(widget.inSelectionMode) {
          onCardSelected();
        }
      },
      //* Padding outside the card
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        //* Card
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: kElevationToShadow[4],
            color: cardColor
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          //* Card content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  //* Task title
                  Expanded(
                    child: Text(
                      widget._task.title,
                      style: taskTitleStyle,
                    ),
                  ),

                  IconButton(onPressed: () {_showEditTaskDialog(context);}, icon: const Icon(Icons.edit)),
                  //* Done/undone button
                  IconButton(onPressed: onDonePressed, icon: Icon(Icons.done, color: doneIconColor)),
                ],
              ),

              //* Task details (animated rolldown)
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget._task.description != null)
                        Text(widget._task.description!, style: taskDetailsStyle,),
                  
                      Text('${AppLocalizations.of(context)!.creationDate}: ${widget._task.readableCreationDate}', style: taskDetailsStyle),
                      if (widget._task.dueDate != null)
                        Text('${AppLocalizations.of(context)!.dueDate}: ${widget._task.readableDueDate}', style: taskDetailsStyle?.merge(TextStyle(color: widget._task.isLate? Colors.red : taskDetailsStyle.color))),
                    ],
                  ),
                ), 
                crossFadeState: isExpanded? CrossFadeState.showSecond : CrossFadeState.showFirst, 
                firstCurve: Curves.easeIn,
                secondCurve: Curves.easeIn,
                duration: const Duration(milliseconds: 200)
              ),
              
              //* Show task details button (animated rotation)
              GestureDetector(
                onTap: showTaskDetails,
                child: AnimatedRotation(
                  turns: isExpanded? 0.5 : 0, 
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _showEditTaskDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: EditTaskForm(
          task: widget._task, 
          onSubmit: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}