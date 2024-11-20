import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/all_tasks_page.dart';
import 'package:lista_de_tarefas/view/components/done_tasks_page.dart';
import 'package:lista_de_tarefas/view/components/new_task_page.dart';
import 'package:lista_de_tarefas/view/components/app_page.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  final List<AppPage> pages = const [
    AllTasksPage(),
    DoneTasksPage(),
    NewTaskPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TodoListState>();
    void onDestinationSelected(int value) {
      setState(() {
        pageIndex = value;
      });
      if (value == 0) {
        state.setAllTasks();
      } else if (value == 1) {
        // TODO change the action
        state.addTask(Task.create(title: 'novanova1',description: 'descricao', dueDate: DateTime.now()));
      }
    }

    Widget page;
    try {
      page = SafeArea(child: SingleChildScrollView(child: pages[pageIndex]));
    } on IndexError {
      throw UnimplementedError('No widget for $pageIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      Widget container;
      bool isWide = constraints.maxWidth >= 600; 

      if (isWide){
        Widget menu = SafeArea(
          child: NavigationRail(
            extended: isWide,
            destinations: [
              for (AppPage p in pages)
                NavigationRailDestination(icon: p.icon, label: Text(p.label)),
            ],
            selectedIndex: pageIndex,
            onDestinationSelected: onDestinationSelected,
          ),
        );
        container = Row(
          children: [menu, page],
        );
      } else {
        
        container = page;
        
      }

      return Scaffold(
        body: container,
        bottomNavigationBar: isWide ? null : BottomNavigationBar(items: [
          for (AppPage p in pages)
            BottomNavigationBarItem(icon: p.icon,label: p.label),
        ],
        currentIndex: pageIndex,
        onTap: onDestinationSelected,
        
        ),

      );
    });
  }
}