import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_tarefas/notifiers/locale_notifier.dart';
import 'package:lista_de_tarefas/notifiers/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Trava a orientação para portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleNotifier(),
      child: ChangeNotifierProvider(
        create: (context) => ThemeNotifier(),
        child: const MainApp(),
      )
    )
  );
  
}

