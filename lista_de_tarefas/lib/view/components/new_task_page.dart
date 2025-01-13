import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/new_task_form.dart';
import 'package:lista_de_tarefas/view/components/page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTaskPage extends StatelessWidget implements MyPage{
  const NewTaskPage({super.key, required this.label});
  
  @override
  final String label;

  @override
  Icon get icon => const Icon(Icons.add_circle);

  @override
  final Function? onLoad = null;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TodoListState>();

    return Column(
      children: [
        const NewTaskForm(),
        ElevatedButton.icon(
          onPressed: state.deleteAllTasks,
          label: Text(AppLocalizations.of(context)!.deleteAllTasks),
          icon: const Icon(Icons.delete_forever),
          ),

      ],
    );
  }
  

}