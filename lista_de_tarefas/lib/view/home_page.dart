import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/pages/new_tasklist_page.dart';
import 'package:lista_de_tarefas/view/pages/page.dart';
import 'package:lista_de_tarefas/view/pages/settings_page.dart';
import 'package:lista_de_tarefas/view/pages/task_lists_page.dart';
import 'package:lista_de_tarefas/view/pages/tasks_page.dart';
import 'package:lista_de_tarefas/view/pages/new_task_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  bool firstTimeLoading = true;
  bool isAddingTask = false;
  bool isSeeingTasks = false;

  @override
  Widget build(BuildContext context) {
    var state = context.read<TodoListState>();

    AppLocalizations localization = AppLocalizations.of(context)!;
    List<MyPage> pages = [
        TaskListsPage(
          label: localization.taskLists, 
          icon: const Icon(Icons.table_rows_sharp), 
          onLoad: state.setAllTaskLists, 
          onTaskListTap: () {
            setState(() {
              isSeeingTasks = true;
            });
          },
        ),
        NewTaskListPage(label: localization.newTaskList),
        SettingsPage(label: localization.settings)
    ];

    if(firstTimeLoading) {
      pages[0].onLoad?.call();
      firstTimeLoading = false;
    }
    
    void onDestinationSelected(int value) {
      setState(() {
        pageIndex = value;
        isAddingTask = false;
        isSeeingTasks = false;
      });
      pages[value].onLoad?.call();
    }

    //* Lógica de qual página vai aparecer
    Widget page;
    try {
      if (isAddingTask) {
        page = SafeArea( child: NewTaskPage(
          label: localization.newTask,
          onCancel: () {
            setState(() {
              isAddingTask = false;
            });
          }
        ));
      } else if (isSeeingTasks) {
        page = SafeArea( child: TasksPage(
          label: localization.allTasks, 
          icon: const Icon(Icons.task), 
          onAddTask: () {
            setState(() {
              isAddingTask = true;
            });
          },
          onCancel: () {
            setState(() {
              isSeeingTasks = false;
            });
          }
        ));
      } else {
        page = SafeArea(child: SingleChildScrollView(child: pages[pageIndex]));
      }
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
              for (MyPage p in pages)
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
            for (MyPage p in pages)
              BottomNavigationBarItem(icon: p.icon,label: p.label),
          ],
          currentIndex: pageIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).hintColor,
          onTap: onDestinationSelected,
        
        ),

      );
    });
  }
}