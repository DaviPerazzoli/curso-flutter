import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TaskCard extends StatefulWidget {
  final int id;
  final Task _task;
  final TodoListState state;
  final Function(int, bool)? onSelected;
  final bool inSelectionMode;

  TaskCard(this._task,{super.key, required this.state, this.onSelected, required this.inSelectionMode}): id = _task.id!;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    void onChanged(bool? value) {
      widget._task.done = value!;
      widget.state.updateTask(widget._task);
    }

    void onCardSelected () {
      setState(() {
          isSelected = !isSelected;
      });
      widget.onSelected?.call(widget.id, isSelected);
    }

    Color cardColor = isSelected ? const Color.fromARGB(121, 225, 190, 231) : Colors.transparent;
    
    return GestureDetector(
      onLongPress: onCardSelected,
      onTap: () {
        if(widget.inSelectionMode) {
          onCardSelected();
        }
      },
      child: Container(
        color: cardColor,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(value: widget._task.done, onChanged: onChanged, ),
            Expanded(child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget._task.id}. ${widget._task.title}'),
                Text(widget._task.description!),
              ],
            ),
            ),
          ],
        ),

      )
    );
    
  }
}