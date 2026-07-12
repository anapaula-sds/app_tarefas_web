import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/task_item.dart';
import '../providers/task_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // Controla o texto digitado no campo, permitindo que o usuário digite uma nova tarefa.
  final TextEditingController _taskController = TextEditingController();

  // Adiciona uma tarefa usando o TaskProvider.
  void _addTask() {
    final String title = _taskController.text;

    context.read<TaskProvider>().addTask(title);

    // Limpa o campo depois de adicionar.
    _taskController.clear();
  }

  @override
  void dispose() {
    // Libera o controlador quando a tela for encerrada.
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observa o Provider.
    // Quando notifyListeners() for chamado, esta tela será atualizada.
    final TaskProvider taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Tarefas')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Digite uma tarefa',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                _addTask();
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addTask,
                child: const Text('Adicionar'),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 8,
              children: [
                Text('Total: ${taskProvider.totalTasks}'),
                Text('Pendentes: ${taskProvider.pendingTasks}'),
                Text('Concluídas: ${taskProvider.completedTasks}'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: taskProvider.tasks.isEmpty
                  ? const Center(child: Text('Nenhuma tarefa cadastrada.'))
                  : ListView.builder(
                      itemCount: taskProvider.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.tasks[index];

                        return TaskItem(
                          task: task,
                          onToggle: () {
                            taskProvider.toggleTask(task);
                          },
                          onRemove: () {
                            taskProvider.removeTask(task);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
