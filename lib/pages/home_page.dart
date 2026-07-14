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
          // Limita a largura máxima do card.
          constraints: const BoxConstraints(maxWidth: 430),
          child: Container(
            // Cria espaço acima e abaixo do card.
            margin: const EdgeInsets.symmetric(vertical: 24),

            // Faz o conteúdo interno respeitar os cantos arredondados.
            clipBehavior: Clip.antiAlias,

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

            // Column principal do card.
            child: Column(
              children: [
                // Cabeçalho roxo.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  color: const Color(0xFF7B4BC4),
                  child: const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha o texto à esquerda.
                    children: [
                      Text(
                        'Minhas Tarefas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Organize seu dia, uma tarefa de cada vez',
                        style: TextStyle(
                          color: Color(0xFFE9DDF8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Área branca abaixo do cabeçalho.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _taskController,
                                decoration: const InputDecoration(
                                  hintText: 'Digite uma nova tarefa',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                onSubmitted: (_) {
                                  _addTask();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _addTask,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6D4AA2),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Adicionar',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
