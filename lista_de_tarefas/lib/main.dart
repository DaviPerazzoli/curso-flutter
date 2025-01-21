import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_tarefas/locale_notifier.dart';
import 'package:provider/provider.dart';
import 'app.dart';
// import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:flutter/foundation.dart';

// TODO Acrescentar edição de tasks e tasklists
// TODO Acrescentar a funcionalidade de dar swipe pros lados pra mudar de página
// TODO Fazer a tasksPage aparecer quando o usuário clica na taskList e remover da barra de navegação
// TODO Atualizar o estilo das TaskListCard

void main() {
  // if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
  //                 defaultTargetPlatform == TargetPlatform.linux || 
  //                 defaultTargetPlatform == TargetPlatform.macOS)) {
  //   // Inicializa FFI para suportar desktop
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }

  WidgetsFlutterBinding.ensureInitialized();

  // Trava a orientação para portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleNotifier(),
      child: const MainApp()
    )
  );
  
}

