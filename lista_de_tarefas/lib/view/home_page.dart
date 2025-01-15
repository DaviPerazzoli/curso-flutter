import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/components/page.dart';
import 'package:lista_de_tarefas/view/components/settings_page.dart';
import 'package:lista_de_tarefas/view/components/tasks_page.dart';
import 'package:lista_de_tarefas/view/components/new_task_page.dart';
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

  @override
  Widget build(BuildContext context) {
    var state = context.read<TodoListState>();

    AppLocalizations localization = AppLocalizations.of(context)!;
    List<MyPage> pages = [
        TasksPage(label: localization.allTasks, icon: const Icon(Icons.task), onLoad: state.setAllTasks, reverseSort: state.reverseSort, selectedSortByOption: state.selectedSortByOption),
        // TasksPage(label: localization.doneTasks, icon: const Icon(Icons.download_done_sharp), onLoad: state.setDoneTasks),
        NewTaskPage(label: localization.newTask),
        SettingsPage(label: localization.settings)
    ];

    if(firstTimeLoading) {
      pages[0].onLoad?.call();
      firstTimeLoading = false;
    }
    
    void onDestinationSelected(int value) {
      setState(() {
        pageIndex = value;
      });
      pages[value].onLoad?.call();
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