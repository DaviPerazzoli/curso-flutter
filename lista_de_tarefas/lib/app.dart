import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/locale_notifier.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'view/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleNotifier localeState = context.watch<LocaleNotifier>();

    return ChangeNotifierProvider<TodoListState>(
      create: (context) => TodoListState(),
      child: MaterialApp(
          title: 'Todo list',
          locale: localeState.locale ?? WidgetsBinding.instance.platformDispatcher.locales.first,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: const HomePage(),
      ),
    );
          
  }
}
