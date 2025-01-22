import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/view/components/forms/new_task_form.dart';
import 'package:lista_de_tarefas/view/pages/page.dart';

class NewTaskPage extends StatelessWidget implements MyPage{
  const NewTaskPage({super.key, required this.label, required this.onCancel});

  final VoidCallback onCancel;
  
  @override
  final String label;

  @override
  Icon get icon => const Icon(Icons.add_circle);

  @override
  final Function? onLoad = null;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color:Theme.of(context).shadowColor, width: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              //* Botão para voltar
              IconButton(onPressed: onCancel, icon: const Icon(Icons.arrow_back)),
            ],
          ),
        ),
        NewTaskForm(onSubmit: onCancel),
        // ElevatedButton.icon(
        //   onPressed: state.deleteAllTasks,
        //   label: Text(AppLocalizations.of(context)!.deleteAllTasks, style: const TextStyle(fontSize: 16),),
        //   icon: const Icon(Icons.delete_forever, size: 30),
        //   ),
      ],
    );
  }
  

}