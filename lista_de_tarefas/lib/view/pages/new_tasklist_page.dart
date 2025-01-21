import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/view/components/new_tasklist_form.dart';
import 'package:lista_de_tarefas/view/pages/page.dart';

class NewTaskListPage extends StatelessWidget implements MyPage{
  const NewTaskListPage({super.key, required this.label});

  @override
  final String label;

  @override
  Icon get icon => const Icon(Icons.format_list_bulleted_add);

  @override
  final Function? onLoad = null;

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        NewTaskListForm(),
      ],
    );
  }
  

}