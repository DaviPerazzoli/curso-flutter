import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TaskCard extends StatelessWidget {
  final Task _task;
  final TodoListState state;
  final Function? onParentLoad;

  const TaskCard(this._task,{super.key, required this.state, this.onParentLoad});

  @override
  Widget build(BuildContext context) {
    void onChanged(bool? value) {
      _task.done = value!;
      state.updateTask(_task);
      onParentLoad?.call();
    }
    
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Checkbox(value: _task.done, onChanged: onChanged, ),
          Expanded(child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_task.id}. ${_task.title}'),
              Text(_task.description!),
            ],
          ),
          ),
        ],
      ),

    );
    
  }

}