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
  bool wasInNotSwipablePage = false;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var state = context.read<TodoListState>();

    AppLocalizations localization = AppLocalizations.of(context)!;

    //* Lógica de páginas aninhadas
    MyPage taskListPage;
    if (isAddingTask) {
        taskListPage = NewTaskPage(
          label: localization.newTask,
          onCancel: () {
            setState(() {
              isAddingTask = false;
            });
          }
        );
      } else if (isSeeingTasks) {
        taskListPage = TasksPage(
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
        );
      } else {
        taskListPage = TaskListsPage(
          label: localization.taskLists, 
          icon: const Icon(Icons.table_rows_sharp), 
          onLoad: state.setAllTaskLists, 
          onTaskListTap: () {
            setState(() {
              isSeeingTasks = true;
            });
          },
        );
      }

    List<MyPage> pages = [
        taskListPage,
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
      try{
        _pageController.jumpToPage(value);
      // ignore: empty_catches
      } on AssertionError {
        // Ocorre um erro quando se está numa página que não faz parte do page view
      }

      pages[value].onLoad?.call();
    }

    

    //* Lógica de qual página vai aparecer
    Widget page;
    try {
      
      page = PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        children: [for (MyPage p in pages) SingleChildScrollView(child: p)],
      );
      
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
        container = SafeArea(child: Row(
          children: [menu, page],
        ));
      } else {
        
        container = SafeArea(child: page);
        
      }

      return Scaffold(
        body: container,
        bottomNavigationBar: isWide ? null : SafeArea(child: BottomNavigationBar(items: [
            for (MyPage p in pages)
              BottomNavigationBarItem(icon: p.icon,label: p.label),
          ],
          currentIndex: pageIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).hintColor,
          onTap: onDestinationSelected,
        
        ),

      ));
    });
  }
}