import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  // StatefulWidget permite atualizar a interface quando o estado muda.
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // Controla o texto digitado no campo de nova tarefa.
  final TextEditingController _taskController = TextEditingController();

  // Armazena temporariamente as datas escolhidas pelo usuário.
  DateTime? _startDate;
  DateTime? _endDate;

  // Formata a data para o padrão brasileiro: dia/mês/ano.
  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // Abre o calendário para selecionar a data de início.
  Future<void> _selectStartDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    // Se o usuário escolher uma data, atualiza a tela.
    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;

        // Se já existia uma data final e ela ficou anterior
        // à nova data inicial, limpa a data final.
        if (_endDate != null && _endDate!.isBefore(selectedDate)) {
          _endDate = null;
        }
      });
    }
  }

  // Abre o calendário para selecionar a data de fim.
  Future<void> _selectEndDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,

      // Se já existe uma data final, usa ela.
      // Caso contrário, usa a data inicial.
      // Se nenhuma existir, usa a data atual.
      initialDate: _endDate ?? _startDate ?? DateTime.now(),

      // Se já existe uma data inicial,
      // o usuário não poderá selecionar uma data final anterior.
      firstDate: _startDate ?? DateTime(2020),

      lastDate: DateTime(2100),
    );

    // Se o usuário escolher uma data, atualiza a tela.
    if (selectedDate != null) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  // Adiciona uma nova tarefa.
  void _addTask() {
    final String title = _taskController.text.trim();

    // Não permite adicionar tarefa sem título.
    if (title.isEmpty) {
      return;
    }

    // Verifica se as duas datas foram selecionadas.
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione a data de início e a data de fim.',
          ),
        ),
      );

      return;
    }

    // Impede que a data final seja anterior à data inicial.
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A data de fim não pode ser anterior à data de início.',
          ),
        ),
      );

      return;
    }

    // Envia título, data inicial e data final para o Provider.
    context.read<TaskProvider>().addTask(
      title,
      _startDate!,
      _endDate!,
    );

    // Limpa o campo de texto.
    _taskController.clear();

    // Limpa as datas depois que a tarefa é adicionada.
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  // Remove uma tarefa após a confirmação do usuário.
  Future<void> _confirmRemoveTask(
    TaskProvider taskProvider,
    Task task,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir tarefa'),
          content: const Text(
            'Tem certeza que deseja excluir esta tarefa?',
          ),
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
        const SnackBar(
          content: Text(
            'Tarefa excluída com sucesso.',
          ),
        ),
      );
    }
  }

  // Cria os cards dos contadores.
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
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
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
          // Mantém o aplicativo com formato semelhante a um celular.
          constraints: const BoxConstraints(
            maxWidth: 430,
          ),

          child: Container(
            // Espaço acima e abaixo do card.
            margin: const EdgeInsets.symmetric(
              vertical: 24,
            ),

            // Faz o conteúdo respeitar os cantos arredondados.
            clipBehavior: Clip.antiAlias,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE0D4EC),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),

            child: Column(
              children: [
                // Cabeçalho roxo.
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.fromLTRB(
                    24,
                    28,
                    24,
                    24,
                  ),

                  color: const Color(0xFF7B4BC4),

                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        // Área de cadastro da nova tarefa.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Campo de tarefa e datas.
                            Expanded(
                              child: Column(
                                children: [
                                  // Campo para digitar a nova tarefa.
                                  SizedBox(
                                    height: 50,
                                    child: TextField(
                                      controller: _taskController,

                                      decoration: InputDecoration(
                                        hintText: 'Digite uma nova tarefa',

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),

                                        // Mantém a mesma cor de borda
                                        // utilizada nos campos de data.
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD8C7EA),
                                          ),
                                        ),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD8C7EA),
                                          ),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF7B4BC4),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),

                                      onSubmitted: (_) {
                                        _addTask();
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // Seleção de data inicial e data final.
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: OutlinedButton.icon(
                                            onPressed: _selectStartDate,

                                            icon: const Icon(
                                              Icons
                                                  .calendar_today_outlined,
                                              size: 18,
                                            ),

                                            label: Text(
                                              _startDate == null
                                                  ? 'Data início'
                                                  : _formatDate(
                                                      _startDate!,
                                                    ),
                                            ),

                                            style:
                                                OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  const Color(
                                                0xFF6D4AA2,
                                              ),

                                              side: const BorderSide(
                                                color: Color(
                                                  0xFFD8C7EA,
                                                ),
                                              ),

                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: OutlinedButton.icon(
                                            onPressed: _selectEndDate,

                                            icon: const Icon(
                                              Icons.event_outlined,
                                              size: 18,
                                            ),

                                            label: Text(
                                              _endDate == null
                                                  ? 'Data fim'
                                                  : _formatDate(
                                                      _endDate!,
                                                    ),
                                            ),

                                            style:
                                                OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  const Color(
                                                0xFF6D4AA2,
                                              ),

                                              side: const BorderSide(
                                                color: Color(
                                                  0xFFD8C7EA,
                                                ),
                                              ),

                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Botão mantém o mesmo tamanho,
                            // centralizado entre as duas linhas de entrada.
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _addTask,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF6D4AA2,
                                  ),

                                  foregroundColor: Colors.white,

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                ),

                                child: const Text(
                                  'Adicionar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Cards de contadores.
                        Row(
                          children: [
                            Expanded(
                              child: _buildCounterCard(
                                value: taskProvider.totalTasks,
                                label: 'Total',
                                backgroundColor: const Color(
                                  0xFFEDE4FA,
                                ),
                                textColor: const Color(
                                  0xFF7B4BC4,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: _buildCounterCard(
                                value: taskProvider.pendingTasks,
                                label: 'Pendentes',
                                backgroundColor: const Color(
                                  0xFFFFF2D9,
                                ),
                                textColor: const Color(
                                  0xFFC98219,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: _buildCounterCard(
                                value: taskProvider.completedTasks,
                                label: 'Concluídas',
                                backgroundColor: const Color(
                                  0xFFDDF5EA,
                                ),
                                textColor: const Color(
                                  0xFF259B67,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Lista de tarefas ou estado vazio.
                        Expanded(
                          child: taskProvider.tasks.isEmpty

                              // Quando não existem tarefas,
                              // permite rolagem caso a altura da tela seja pequena.
                              ? const SingleChildScrollView(
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.assignment_outlined,
                                            size: 48,
                                            color: Color(
                                              0xFF9B72D3,
                                            ),
                                          ),

                                          SizedBox(height: 12),

                                          Text(
                                            'Nenhuma tarefa cadastrada',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.w600,
                                              color: Color(
                                                0xFF7B4BC4,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 6),

                                          Text(
                                            'Adicione sua primeira tarefa e comece a organizar seu dia.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(
                                                0xFFAA8BCB,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )

                              // Quando existem tarefas,
                              // exibe a lista normalmente.
                              : ListView.builder(
                                  itemCount:
                                      taskProvider.tasks.length,

                                  itemBuilder: (context, index) {
                                    final Task task =
                                        taskProvider.tasks[index];

                                    return TaskItem(
                                      task: task,

                                      onToggle: () {
                                        taskProvider.toggleTask(
                                          task,
                                        );
                                      },

                                      onRemove: () {
                                        _confirmRemoveTask(
                                          taskProvider,
                                          task,
                                        );
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