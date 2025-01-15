import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_tarefas/locale_notifier.dart';
import 'package:provider/provider.dart';
import 'app.dart';
// import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:flutter/foundation.dart';

// TODO Arrumar: Quando só tem uma tarefa, não aparece a data (as vezes)
// TODO Acrescentar a funcionalidade de dar swipe pros lados pra mudar de página
// TODO Adicionar filtro na TasksPage: apenas done, apenas undone, atrasadas, não atrasadas, etc. (Necessário remover a done tasks)
// TODO Futuramente, deixar o usuário criar páginas novas, para mostrar tarefas da forma que ele quiser (Através do filtro e escolhendo o ícone da página)

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

