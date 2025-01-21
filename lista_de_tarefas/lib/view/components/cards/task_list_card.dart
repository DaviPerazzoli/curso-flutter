import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/cards/card.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TaskListCard extends StatefulWidget implements MyCard{
  const TaskListCard(this._taskList, {super.key, this.onSelected, required this.inSelectionMode, required this.onTap});

  final TaskList _taskList;

  final VoidCallback onTap;

  @override
  final Function(int, bool)? onSelected;

  @override
  final bool inSelectionMode;

  @override
  int get id => _taskList.id!;

  @override
  State<TaskListCard> createState() => _TaskListCardState();
}

class _TaskListCardState extends State<TaskListCard> {
  bool isSelected = false;

  void onCardSelected () {
    setState(() {
        isSelected = !isSelected;
    });
    widget.onSelected?.call(widget.id, isSelected);
  }

  @override
  Widget build(BuildContext context) {
    TodoListState state = context.watch<TodoListState>();

    // This is necessary when excluding task list cards
    if (!widget.inSelectionMode) {
      setState(() {
        isSelected = false;
      });
    }

    Color cardColor = isSelected ? Theme.of(context).primaryColorLight: Theme.of(context).cardColor;
    TextStyle? taskListNameStyle = Theme.of(context).textTheme.titleLarge;

    return GestureDetector(
      onLongPress: onCardSelected,
      onTap: () {
        if (widget.inSelectionMode) {
          onCardSelected();
        } else {
          state.setAllTasks(widget._taskList.id!);
          widget.onTap();
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
            color: cardColor,
            border: Border.all(color: widget._taskList.color,),
          ),
          padding: const EdgeInsets.all(16),
          //* Card content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              //* TaskList name
              Text(
                widget._taskList.name,
                style: taskListNameStyle,
              ),
            ],
          ),
        ),
      )
    );
  }
}