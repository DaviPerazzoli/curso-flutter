import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/notifiers/locale_notifier.dart';
import 'package:lista_de_tarefas/notifiers/theme_notifier.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:lista_de_tarefas/view/theme.dart';
import 'view/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleNotifier localeState = context.watch<LocaleNotifier>();
    ThemeNotifier themeState = context.watch<ThemeNotifier>();

    return ChangeNotifierProvider<TodoListState>(
      create: (context) => TodoListState(),
      child: MaterialApp(
          title: 'ToDo List',
          locale: localeState.locale ?? WidgetsBinding.instance.platformDispatcher.locales.first,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeState.themeMode,
          home: const HomePage(),
      ),
    );
          
  }
}
