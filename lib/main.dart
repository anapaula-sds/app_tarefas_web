import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart'; // Importa o TaskProvider para gerenciar o estado das tarefas.

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ), // Envolve o MyApp com ChangeNotifierProvider para fornecer o TaskProvider a toda a árvore de widgets.
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Tarefas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Meu App de Tarefas',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
