import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
// import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:flutter/foundation.dart';

// TODO Acrescentar a funcionalidade de dar swipe pros lados pra mudar de página
// TODO Mudar o TaskCard: deixar mais bonito e mudar como funiona o done: colocar um icone, que muda de cor e de imagem conforme está feita ou não
// TODO Quando uma tarefa está atrasada, mudar seu estilo

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

  runApp(const MainApp());
  
}

