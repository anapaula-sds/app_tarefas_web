import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  // Lista onde as tarefas ficam armazenadas temporariamente.
  final List<Task> _tasks = [];

  // Número usado para gerar o ID da próxima tarefa.
  int _nextId = 1;

  // Permite que a tela consulte as tarefas.
  List<Task> get tasks {
    return _tasks;
  }

  // Retorna a quantidade total de tarefas.
  int get totalTasks {
    return _tasks.length;
  }

  // Retorna a quantidade de tarefas concluídas.
  int get completedTasks {
    return _tasks.where((task) => task.isCompleted).length;
  }

  // Retorna a quantidade de tarefas pendentes.
  int get pendingTasks {
    return _tasks.where((task) => !task.isCompleted).length;
  }

  // Adiciona uma nova tarefa.
  void addTask(String title) {
    final String trimmedTitle = title.trim();

    // Não adiciona uma tarefa vazia.
    if (trimmedTitle.isEmpty) {
      return;
    }

    // Cria uma nova tarefa com um ID sequencial.
    final Task newTask = Task(id: _nextId.toString(), title: trimmedTitle);

    // Prepara o próximo ID.
    _nextId++;

    // Adiciona a tarefa à lista.
    _tasks.add(newTask);

    // Avisa à tela que a lista mudou.
    notifyListeners();
  }

  // Alterna a tarefa entre pendente e concluída.
  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  // Remove uma tarefa da lista.
  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
