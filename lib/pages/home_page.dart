import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // Controla o texto digitado no campo.
  final TextEditingController _taskController = TextEditingController();

  // Adiciona uma nova tarefa.
  void _addTask() {
    final String title = _taskController.text.trim();

    if (title.isEmpty) {
      return;
    }

    context.read<TaskProvider>().addTask(title);
    _taskController.clear();
  }

  @override
  void dispose() {
    // Libera o controlador quando a tela é encerrada.
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observa as mudanças feitas no TaskProvider.
    final TaskProvider taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE0D4EC)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Minhas Tarefas',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D4AA2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Adicionar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                        ? const Center(
                            child: Text('Nenhuma tarefa cadastrada.'),
                          )
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
          ),
        ),
      ),
    );
  }
}
