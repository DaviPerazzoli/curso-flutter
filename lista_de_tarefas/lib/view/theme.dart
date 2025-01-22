import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData.from(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.amber,             // Mantém o âmbar como cor principal
    onPrimary: Colors.black,           // Texto nos elementos primários em preto para contraste com o âmbar
    secondary: Colors.tealAccent,      // Um laranja profundo para elementos secundários, oferecendo destaque
    onSecondary: Colors.black,         // Texto nos elementos secundários em preto
    error: Color.fromARGB(255, 85, 23, 34),          // Cor de erro escura, uma variação de vermelho mais discreta
    onError: Colors.black,             // Texto em erros em preto
    surface: Color(0xFF1F1F1F),        // Um cinza muito escuro para superfícies
    onSurface: Colors.white,           // Texto nas superfícies em branco
  ),
  useMaterial3: true,
);