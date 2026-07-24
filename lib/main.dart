import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider responsável pelo estado das tarefas.
        ChangeNotifierProvider(
          create: (context) => TaskProvider(),
        ),

        // Provider responsável pelo tema claro e escuro.
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Observa o ThemeProvider.
    // Quando o tema mudar, o MaterialApp será reconstruído.
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Tarefas',

      // Tema claro.
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B4BC4),
          brightness: Brightness.light,
        ),
      ),

      // Tema escuro.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B4BC4),
          brightness: Brightness.dark,
        ),
      ),

      // Define qual tema deve ser usado.
      themeMode: themeProvider.themeMode,

      home: const HomePage(),
    );
  }
}