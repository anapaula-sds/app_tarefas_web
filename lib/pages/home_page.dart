import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_item.dart';

class HomePage extends StatefulWidget {
  // StatefulWidget permite atualizar a interface quando o estado muda.
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  } // Esta sessão é necessária para que o estado da página seja preservado ao alternar entre telas.
}

class _HomePageState extends State<HomePage> {
  // Controla o texto digitado no campo de nova tarefa.
  final TextEditingController _taskController = TextEditingController();

  // Armazena temporariamente as datas escolhidas pelo usuário.
  DateTime? _startDate;
  DateTime? _endDate;

  // Formata a data no padrão brasileiro: dia/mês/ano.
  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // Abre o calendário para selecionar a data inicial.
  Future<void> _selectStartDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _startDate = selectedDate;

      // Limpa a data final caso ela seja anterior à nova data inicial.
      if (_endDate != null && _endDate!.isBefore(selectedDate)) {
        _endDate = null;
      }
    });
  }

  // Abre o calendário para selecionar a data final.
  Future<void> _selectEndDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _endDate = selectedDate;
    });
  }

  // Adiciona uma nova tarefa.
  void _addTask() {
    final String title = _taskController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite o nome da tarefa.')));

      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a data de início e a data de fim.'),
        ),
      );

      return;
    }

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

    context.read<TaskProvider>().addTask(title, _startDate!, _endDate!);

    _taskController.clear();

    setState(() {
      _startDate = null;
      _endDate = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa adicionada com sucesso.')),
    );
  }

  // Abre o diálogo de confirmação antes de excluir.
  Future<void> _confirmRemoveTask(TaskProvider taskProvider, Task task) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir tarefa'),
          content: const Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    taskProvider.removeTask(task);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa excluída com sucesso.')),
    );
  }

  // Cria os cards de contadores.
  Widget _buildCounterCard({
    required int value,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      height: 68,
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: textColor, fontSize: 11)),
        ],
      ),
    );
  }

  // Cria um botão de seleção de data.
  Widget _buildDateButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color foregroundColor,
  }) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          side: const BorderSide(color: Color(0xFFD8C7EA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Cria o botão para adicionar uma tarefa.
  Widget _buildAddButton({required bool fullWidth}) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _addTask,
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'Adicionar',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF259B67),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Cria o formulário de cadastro de tarefas.
  Widget _buildTaskForm({
    required Color dateButtonColor,
    required bool isDarkMode,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Em telas pequenas, os campos ficam um abaixo do outro.
        final bool isSmallScreen = constraints.maxWidth < 700;

        final Widget titleField = SizedBox(
          height: 48,
          child: TextField(
            controller: _taskController,
            onSubmitted: (_) {
              _addTask();
            },
            decoration: InputDecoration(
              hintText: 'Digite uma nova tarefa',
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF302938) : Colors.white,
              prefixIcon: const Icon(Icons.edit_outlined),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD8C7EA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF7B4BC4),
                  width: 1.5,
                ),
              ),
            ),
          ),
        );

        final Widget dateFields = Row(
          children: [
            Expanded(
              child: _buildDateButton(
                onPressed: _selectStartDate,
                icon: Icons.calendar_today_outlined,
                label: _startDate == null
                    ? 'Data início'
                    : _formatDate(_startDate!),
                foregroundColor: dateButtonColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDateButton(
                onPressed: _selectEndDate,
                icon: Icons.event_outlined,
                label: _endDate == null ? 'Data fim' : _formatDate(_endDate!),
                foregroundColor: dateButtonColor,
              ),
            ),
          ],
        );

        if (isSmallScreen) {
          return Column(
            children: [
              titleField,
              const SizedBox(height: 10),
              dateFields,
              const SizedBox(height: 10),
              _buildAddButton(fullWidth: true),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: titleField),
            const SizedBox(width: 12),
            Expanded(flex: 3, child: dateFields),
            const SizedBox(width: 12),
            _buildAddButton(fullWidth: false),
          ],
        );
      },
    );
  }

  // Cria o menu lateral.
  Widget _buildDrawer({
    required TaskProvider taskProvider,
    required ThemeProvider themeProvider,
    required bool isDarkMode,
    required Color contentColor,
  }) {
    return Drawer(
      backgroundColor: contentColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF7B4BC4),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.task_alt,
                      size: 36,
                      color: Color(0xFF7B4BC4),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'TaskRise',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Organize seu dia com facilidade',
                    style: TextStyle(color: Color(0xFFE9DDF8), fontSize: 13),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Início'),
              selected: true,
              selectedColor: const Color(0xFF7B4BC4),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: const Text('Minhas Tarefas'),
              trailing: CircleAvatar(
                radius: 13,
                backgroundColor: const Color(0xFFEDE4FA),
                child: Text(
                  taskProvider.totalTasks.toString(),
                  style: const TextStyle(
                    color: Color(0xFF7B4BC4),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.pending_actions_outlined),
              title: const Text('Pendentes'),
              trailing: Text(taskProvider.pendingTasks.toString()),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Concluídas'),
              trailing: Text(taskProvider.completedTasks.toString()),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(),

            SwitchListTile(
              secondary: Icon(
                isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),

              // Mostra o tema para o qual o usuário poderá mudar.
              title: Text(isDarkMode ? 'Tema claro' : 'Tema escuro'),

              value: isDarkMode,

              activeThumbColor: const Color(0xFF7B4BC4),

              onChanged: (_) {
                themeProvider.toggleTheme();
              },
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'TaskRise • Versão 1.0',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = context.watch<TaskProvider>();
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();

    final bool isDarkMode = themeProvider.isDarkMode;

    final Color backgroundColor = isDarkMode
        ? const Color(0xFF18141F)
        : const Color(0xFFF3ECFA);

    final Color contentColor = isDarkMode
        ? const Color(0xFF241F2C)
        : Colors.white;

    final Color primaryTextColor = isDarkMode
        ? const Color(0xFFF2ECF8)
        : const Color(0xFF4A3B57);

    final Color secondaryTextColor = isDarkMode
        ? const Color(0xFFC9BCD5)
        : const Color(0xFF776984);

    final Color dateButtonColor = isDarkMode
        ? const Color(0xFFD8C7EA)
        : const Color(0xFF6D4AA2);

    return Scaffold(
      backgroundColor: backgroundColor,

      // AppBar oficial da tela.
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4BC4),
        foregroundColor: Colors.white,
        elevation: 0,

        // O Flutter cria automaticamente o botão do Drawer.
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo fictício do aplicativo.
            CircleAvatar(
              radius: 17,
              backgroundColor: Colors.white,
              child: Icon(Icons.task_alt, color: Color(0xFF7B4BC4), size: 21),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TaskRise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Organize, Execute, Evolua!',
                  style: TextStyle(color: Color(0xFFE9DDF8), fontSize: 10),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: isDarkMode ? 'Ativar tema claro' : 'Ativar tema escuro',
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Menu lateral.
      drawer: _buildDrawer(
        taskProvider: taskProvider,
        themeProvider: themeProvider,
        isDarkMode: isDarkMode,
        contentColor: contentColor,
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Limita somente a largura do conteúdo em telas grandes.
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minhas Tarefas',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Organize seu dia, uma tarefa de cada vez.',
                    style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  ),

                  const SizedBox(height: 20),

                  // Formulário responsivo.
                  _buildTaskForm(
                    dateButtonColor: dateButtonColor,
                    isDarkMode: isDarkMode,
                  ),

                  const SizedBox(height: 20),

                  // Contadores.
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildCounterCard(
                          value: taskProvider.pendingTasks,
                          label: 'Pendentes',
                          backgroundColor: const Color(0xFFFFF2D9),
                          textColor: const Color(0xFFC98219),
                        ),
                      ),
                      const SizedBox(width: 10),
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

                  const SizedBox(height: 20),

                  // Título da lista.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Suas tarefas',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Container(
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
                            color: isDarkMode
                                ? const Color(0xFFD8C7EA)
                                : const Color(0xFF7B4BC4),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Lista de tarefas.
                  Expanded(
                    child: taskProvider.tasks.isEmpty
                        ? Center(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.assignment_outlined,
                                      size: 58,
                                      color: Color(0xFF9B72D3),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'Nenhuma tarefa cadastrada',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      'Adicione sua primeira tarefa e comece '
                                      'a organizar seu dia.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
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
        ),
      ),
    );
  }
}
