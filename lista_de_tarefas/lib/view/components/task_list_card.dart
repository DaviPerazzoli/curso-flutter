import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/view/components/card.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TaskListCard extends StatefulWidget implements MyCard{
  const TaskListCard(this._taskList, {super.key, this.onSelected, required this.inSelectionMode});

  final TaskList _taskList;

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
            color: cardColor,
            border: Border.all(color: widget._taskList.color, width: 0.2),
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
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