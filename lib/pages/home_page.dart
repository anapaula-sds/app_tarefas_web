import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  // stateful widget para permitir a atualização da interface quando o estado muda.
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState(); // Retorna o estado associado a este widget. _HomePageState é uma classe privada que gerencia o estado da HomePage.
  }
}

class _HomePageState extends State<HomePage> {
  // TextEditingController é usado para controlar o texto digitado no campo de entrada. Ele permite acessar e modificar o texto do TextField.
  final TextEditingController _taskController = TextEditingController();

  // Adiciona uma nova tarefa.
  void _addTask() {
    final String title = _taskController.text.trim();

    if (title.isEmpty) {
      return;
    }

    context.read<TaskProvider>().addTask(
      title,
    ); // Adiciona a tarefa ao TaskProvider, que gerencia o estado das tarefas. context.read<TaskProvider>() permite acessar o TaskProvider sem escutar mudanças de estado.
    _taskController.clear();
  }

  // Remove uma tarefa após a confirmação do usuário. Future<void> é usado porque a função envolve uma operação assíncrona (exibição de diálogo).
  Future<void> _confirmRemoveTask(TaskProvider taskProvider, Task task) async {
    final bool? confirmed = await showDialog<bool>( // showDialog é usado para exibir um diálogo de confirmação. Ele retorna um Future que completa com o valor selecionado pelo usuário (true para confirmar, false para cancelar).
      context: context,
      builder: (context) {
        return AlertDialog( // AlertDialog é um widget que exibe uma caixa de diálogo com título, conteúdo e ações. Ele é usado aqui para perguntar ao usuário se ele tem certeza de que deseja excluir a tarefa.
          title: const Text('Excluir tarefa'),
          content: const Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      taskProvider.removeTask(task);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa excluída com sucesso.')),
      );
    }
  }

  Widget _buildCounterCard({
    required int value,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Libera o controlador quando a tela é encerrada.
    _taskController
        .dispose(); // dispose() é chamado quando o widget é removido da árvore de widgets, garantindo que os recursos sejam liberados corretamente.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observa as mudanças feitas no TaskProvider. context.watch<TaskProvider>() permite que o widget seja reconstruído sempre que o estado do TaskProvider mudar, garantindo que a interface esteja sempre atualizada com os dados mais recentes.
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

            // Column principal do card. Todos os elementos do card são filhos desta coluna.
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
                        Row(
                          children: [
                            Expanded(
                              // Cria um card para mostrar o total de tarefas. _buildCounterCard é um método que cria um card estilizado para exibir contadores de tarefas.
                              child: _buildCounterCard(
                                value: taskProvider.totalTasks,
                                label: 'Total',
                                backgroundColor: const Color(0xFFEDE4FA),
                                textColor: const Color(0xFF7B4BC4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCounterCard(
                                value: taskProvider.pendingTasks,
                                label: 'Pendentes',
                                backgroundColor: const Color(0xFFFFF2D9),
                                textColor: const Color(0xFFC98219),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCounterCard(
                                value: taskProvider.completedTasks,
                                label: 'Concluídas',
                                backgroundColor: const Color(0xFFDDF5EA),
                                textColor: const Color(0xFF259B67),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child:
                              taskProvider
                                  .tasks
                                  .isEmpty // Verifica se a lista de tarefas está vazia. Se estiver, exibe uma mensagem informando que não há tarefas cadastradas. Caso contrário, exibe a lista de tarefas usando ListView.builder.
                              ? const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // Define o tamanho da coluna com base no conteúdo, evitando que ocupe todo o espaço disponível.
                                    children: [
                                      Icon(
                                        Icons.assignment_outlined,
                                        size: 56,
                                        color: Color(0xFF9B72D3),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Nenhuma tarefa cadastrada',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF7B4BC4),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Adicione sua primeira tarefa e comece a organizar seu dia.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFAA8BCB),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  // ListView.builder é usado para criar uma lista de tarefas de forma eficiente, construindo apenas os itens visíveis na tela.
                                  itemCount: taskProvider
                                      .tasks
                                      .length, // Define o número de itens na lista com base na quantidade de tarefas no TaskProvider.
                                  itemBuilder: (context, index) {
                                    // Constrói cada item da lista com base no índice fornecido. O itemBuilder é chamado para cada índice da lista, permitindo criar widgets personalizados para cada tarefa.
                                    final task = taskProvider.tasks[index];

                                    return TaskItem(
                                      task: task,
                                      onToggle: () {
                                        taskProvider.toggleTask(task);
                                      },
                                      onRemove: () {
                                        _confirmRemoveTask(taskProvider, task); // Chama o método para confirmar a remoção da tarefa, exibindo um diálogo de confirmação antes de removê-la do TaskProvider.
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
