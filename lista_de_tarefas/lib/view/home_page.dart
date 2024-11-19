import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (pageIndex) {
      case 0:
        page = AllTasksPage();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');

    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: page,
      );
    });
  }
}