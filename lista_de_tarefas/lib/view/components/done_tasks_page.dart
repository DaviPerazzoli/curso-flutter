import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/view/components/app_page.dart';

class DoneTasksPage extends StatelessWidget implements AppPage{
  const DoneTasksPage({super.key});
  
  @override
  String get label => 'Done tasks';

  @override
  Icon get icon => const Icon(Icons.done);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  

}