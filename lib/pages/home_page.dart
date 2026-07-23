import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
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
          content: Text('Selecione a data de início e a data de fim.'),
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
    context.read<TaskProvider>().addTask(title, _startDate!, _endDate!);

    // Limpa o campo de texto.
    _taskController.clear();

    // Limpa as datas depois que a tarefa é adicionada.
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  // Remove uma tarefa após a confirmação do usuário.
  Future<void> _confirmRemoveTask(TaskProvider taskProvider, Task task) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
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

  // Cria os cards dos contadores.
  Widget _buildCounterCard({
    required int value,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      // Altura reduzida para deixar os contadores mais compactos.
      height: 64,
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
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: textColor, fontSize: 11)),
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

    // Observa as mudanças feitas no ThemeProvider.
    // Quando o tema muda, a HomePage é reconstruída.
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    // Verifica se o tema escuro está ativo.
    final bool isDarkMode = themeProvider.isDarkMode;

    // Cor do fundo externo do aplicativo.
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF18141F)
        : const Color(0xFFF3ECFA);

    // Cor da área principal do aplicativo.
    final Color contentColor = isDarkMode
        ? const Color(0xFF241F2C)
        : Colors.white;

    // Cor da borda externa do aplicativo.
    final Color borderColor = isDarkMode
        ? const Color(0xFF3A3147)
        : const Color(0xFFE0D4EC);

    // Cor do texto e dos ícones dos botões de data.
    final Color dateButtonColor = isDarkMode
        ? const Color(0xFFD8C7EA)
        : const Color(0xFF6D4AA2);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: Center(
        child: ConstrainedBox(
          // Mantém o aplicativo com formato semelhante a um celular.
          constraints: const BoxConstraints(maxWidth: 430),

          child: Container(
            // Espaço acima e abaixo do card.
            margin: const EdgeInsets.symmetric(vertical: 24),

            // Faz o conteúdo respeitar os cantos arredondados.
            clipBehavior: Clip.antiAlias,

            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
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

                  // Padding reduzido para deixar o cabeçalho mais compacto.
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 18),

                  color: const Color(0xFF7B4BC4),

                  // Linha com título e botão de troca de tema.
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minhas Tarefas',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              'Organize seu dia, uma tarefa de cada vez',
                              style: TextStyle(
                                color: Color(0xFFE9DDF8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Botão que alterna entre tema claro e escuro.
                      IconButton(
                        tooltip: isDarkMode
                            ? 'Ativar tema claro'
                            : 'Ativar tema escuro',

                        onPressed: () {
                          themeProvider.toggleTheme();
                        },

                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0x26FFFFFF),

                          foregroundColor: Colors.white,

                          hoverColor: const Color(0x40FFFFFF),

                          highlightColor: const Color(0x33FFFFFF),

                          side: const BorderSide(color: Color(0x66FFFFFF)),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          // Botão de tema reduzido proporcionalmente.
                          fixedSize: const Size(40, 40),
                        ),

                        icon: Icon(
                          isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Área abaixo do cabeçalho.
                Expanded(
                  child: Padding(
                    // Reduz o espaço interno geral da área de conteúdo.
                    padding: const EdgeInsets.all(20),

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
                                    // Altura reduzida de 50 para 44.
                                    height: 44,

                                    child: TextField(
                                      controller: _taskController,

                                      decoration: InputDecoration(
                                        hintText: 'Digite uma nova tarefa',

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 11,
                                            ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD8C7EA),
                                          ),
                                        ),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFD8C7EA),
                                          ),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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

                                  // Espaço menor entre o campo e as datas.
                                  const SizedBox(height: 4),

                                  // Seleção de data inicial e data final.
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          // Altura reduzida.
                                          height: 44,

                                          child: OutlinedButton.icon(
                                            onPressed: _selectStartDate,

                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              size: 18,
                                            ),

                                            label: Text(
                                              _startDate == null
                                                  ? 'Data início'
                                                  : _formatDate(_startDate!),
                                            ),

                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: dateButtonColor,

                                              side: const BorderSide(
                                                color: Color(0xFFD8C7EA),
                                              ),

                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: SizedBox(
                                          // Altura reduzida.
                                          height: 44,

                                          child: OutlinedButton.icon(
                                            onPressed: _selectEndDate,

                                            icon: const Icon(
                                              Icons.event_outlined,
                                              size: 18,
                                            ),

                                            label: Text(
                                              _endDate == null
                                                  ? 'Data fim'
                                                  : _formatDate(_endDate!),
                                            ),

                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: dateButtonColor,

                                              side: const BorderSide(
                                                color: Color(0xFFD8C7EA),
                                              ),

                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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

                            // Botão Adicionar com destaque de ação positiva.
                            SizedBox(
                              // Mantém alinhamento, mas fica mais compacto.
                              height: 44,

                              child: ElevatedButton(
                                onPressed: _addTask,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF259B67),

                                  foregroundColor: Colors.white,

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
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

                        // Espaço reduzido antes dos contadores.
                        const SizedBox(height: 18),

                        // Cards de contadores.
                        Row(
                          children: [
                            Expanded(
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

                        // Espaço reduzido antes do título da lista.
                        const SizedBox(height: 16),

                        // Cabeçalho da área onde as tarefas são exibidas.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Suas tarefas',
                              style: TextStyle(
                                // Título levemente menor.
                                fontSize: 15,
                                fontWeight: FontWeight.w700,

                                color: isDarkMode
                                    ? const Color(0xFFF2ECF8)
                                    : const Color(0xFF4A3B57),
                              ),
                            ),

                            // Pill que mostra a quantidade de tarefas.
                            Container(
                              // Pill mais compacta.
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color(0xFF3A3147)
                                    : const Color(0xFFEDE4FA),

                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                taskProvider.totalTasks == 1
                                    ? '1 tarefa'
                                    : '${taskProvider.totalTasks} tarefas',

                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,

                                  color: isDarkMode
                                      ? const Color(0xFFD8C7EA)
                                      : const Color(0xFF7B4BC4),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Espaço menor entre o título e a lista.
                        const SizedBox(height: 10),

                        // Lista de tarefas ou estado vazio.
                        Expanded(
                          child: taskProvider.tasks.isEmpty
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
                                            color: Color(0xFF9B72D3),
                                          ),

                                          SizedBox(height: 12),

                                          Text(
                                            'Nenhuma tarefa cadastrada',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF7B4BC4),
                                            ),
                                          ),

                                          SizedBox(height: 6),

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
                                    ),
                                  ),
                                )
                              // Quando existem tarefas,
                              // exibe a lista normalmente.
                              : ListView.builder(
                                  itemCount: taskProvider.tasks.length,

                                  itemBuilder: (context, index) {
                                    final Task task = taskProvider.tasks[index];

                                    return TaskItem(
                                      task: task,

                                      onToggle: () {
                                        taskProvider.toggleTask(task);
                                      },

                                      onRemove: () {
                                        _confirmRemoveTask(taskProvider, task);
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
