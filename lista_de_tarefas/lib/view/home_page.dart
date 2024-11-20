import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/app_page.dart';
import 'package:lista_de_tarefas/view/components/tasks_page.dart';
import 'package:lista_de_tarefas/view/components/new_task_page.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  late final List<AppPage> pages;

  @override
  void initState() {
    super.initState();
    var state = context.read<TodoListState>();

    pages = [
      AppPage(
        page: const TasksPage(label: 'All tasks', icon: Icon(Icons.task)), 
        onSelected: state.setAllTasks,
        ),
      AppPage(
        page: const TasksPage(label: 'Done tasks', icon: Icon(Icons.download_done_sharp)), 
        onSelected: state.setDoneTasks,
        ),
      AppPage(page: const NewTaskPage(),),
    ];
  }


  @override
  Widget build(BuildContext context) {

    void onDestinationSelected(int value) {
      setState(() {
        pageIndex = value;
      });
      pages[value].onSelected?.call();
    }

    Widget page;
    try {
      page = SafeArea(child: SingleChildScrollView(child: pages[pageIndex].page));
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
                NavigationRailDestination(icon: p.page.icon, label: Text(p.page.label)),
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
            BottomNavigationBarItem(icon: p.page.icon,label: p.page.label),
        ],
        currentIndex: pageIndex,
        onTap: onDestinationSelected,
        
        ),

      );
    });
  }
}