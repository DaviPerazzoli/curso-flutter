import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_tarefas/locale_notifier.dart';
import 'package:provider/provider.dart';
import 'app.dart';
// import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:flutter/foundation.dart';

// TODO Acrescentar a funcionalidade de dar swipe pros lados pra mudar de página
// TODO Adicionar filtro na TasksPage: apenas done, apenas undone, atrasadas, não atrasadas, etc. (Necessário remover a done tasks)
// TODO Ideia: Futuramente, deixar o usuário criar páginas novas, para mostrar tarefas da forma que ele quiser (Através do filtro e escolhendo o ícone da página)
// TODO Outra ideia, talvez mais interessante: Deixar o usuário criar quantas taskLists ele quiser: Uma de alimentação, treino, escola, etc.
// TODO Outra ideia: Criar categorias pras tasks pro usuário filtrar por categoria

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

