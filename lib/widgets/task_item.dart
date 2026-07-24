import 'package:flutter/material.dart';

import '../models/task.dart';

// Widget que representa uma tarefa na lista.
class TaskItem extends StatelessWidget {
  final Task task;

  // Quando o usuário alterna o estado da tarefa entre pendente e concluída.
  final VoidCallback onToggle;

  // Quando o usuário deseja remover a tarefa.
  final VoidCallback onRemove;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onRemove,
  });

  // Formata a data para o padrão brasileiro: dia/mês/ano.
  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o aplicativo está usando o tema escuro.
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    // Facilita a leitura do código.
    final bool isCompleted = task.isCompleted;
    final bool isOverdue = task.isOverdue;

    // -----------------------------
    // CORES DO CARD
    // -----------------------------

    final Color cardColor;
    final Color borderColor;
    final Color titleColor;
    final Color dateColor;
    final Color checkboxBorderColor;

    if (isCompleted) {
      // TAREFA CONCLUÍDA = VERDE

      cardColor = isDarkMode
          ? const Color(0xFF123326)
          : const Color(0xFFE5F7EE);

      borderColor = const Color(0xFF74D9AA);

      titleColor = const Color(0xFF259B67);

      dateColor = const Color(0xFF2E9B68);

      checkboxBorderColor = const Color(0xFF259B67);
    } else if (isOverdue) {
      // TAREFA VENCIDA = VERMELHO

      cardColor = isDarkMode
          ? const Color(0xFF351D22)
          : const Color(0xFFFDEBEC);

      borderColor = isDarkMode
          ? const Color(0xFFE07A7A)
          : const Color(0xFFE8A2A2);

      titleColor = isDarkMode
          ? const Color(0xFFFF8A80)
          : const Color(0xFFC0392B);

      dateColor = isDarkMode
          ? const Color(0xFFF1A5A5)
          : const Color(0xFFD35454);

      checkboxBorderColor = isDarkMode
          ? const Color(0xFFE07A7A)
          : const Color(0xFFD96C6C);
    } else {
      // TAREFA NORMAL

      cardColor = isDarkMode
          ? const Color(0xFF211C29)
          : const Color(0xFFFBF7FC);

      borderColor = isDarkMode
          ? const Color(0xFF6D5A80)
          : const Color(0xFFD8C7EA);

      titleColor = isDarkMode
          ? Colors.white
          : const Color(0xFF6D4AA2);

      dateColor = isDarkMode
          ? const Color(0xFFB8AFBF)
          : const Color(0xFF777777);

      checkboxBorderColor = isDarkMode
          ? const Color(0xFFD8C7EA)
          : const Color(0xFF9B72D3);
    }

    return Card(
      // Espaço entre uma tarefa e outra.
      margin: const EdgeInsets.only(
        bottom: 8,
      ),

      // Cor de fundo do card.
      color: cardColor,

      // Sombra leve.
      elevation: 2,

      shadowColor: isDarkMode
          ? const Color(0x33000000)
          : const Color(0x267B4BC4),

      // Bordas arredondadas e contorno.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          14,
        ),
        side: BorderSide(
          color: borderColor,
          width: 1,
        ),
      ),

      child: ListTile(
        // Mantém o card mais compacto.
        dense: true,

        visualDensity: const VisualDensity(
          horizontal: -1,
          vertical: -1,
        ),

        // Espaço mínimo interno vertical.
        minVerticalPadding: 5,

        // Espaço entre o conteúdo e as bordas do card.
        // O espaço superior evita que o título e a pill
        // fiquem encostados na borda.
        contentPadding: const EdgeInsets.fromLTRB(
          12, // esquerda
          6, // cima
          8, // direita
          5, // baixo
        ),

        // -----------------------------
        // CHECKBOX
        // -----------------------------

        leading: Checkbox(
          value: task.isCompleted,

          onChanged: (_) {
            onToggle();
          },

          // Deixa o checkbox circular.
          shape: const CircleBorder(),

          // Verde quando marcado.
          activeColor: const Color(
            0xFF259B67,
          ),

          checkColor: Colors.white,

          // Cor da borda do checkbox.
          side: BorderSide(
            color: checkboxBorderColor,
            width: 1.5,
          ),
        ),

        // -----------------------------
        // TÍTULO + PILL "VENCIDA"
        // -----------------------------

        title: Padding(
          // Pequeno espaço adicional acima
          // do título e da pill.
          padding: const EdgeInsets.only(
            top: 2,
          ),

          child: Row(
            children: [
              // O Expanded permite que o título
              // ocupe o espaço disponível.
              Expanded(
                child: Text(
                  task.title,

                  // Evita que títulos muito grandes
                  // empurrem a pill ou a lixeira.
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.2,

                    // Tarefa concluída ou vencida
                    // recebe texto riscado.
                    decoration: (isCompleted || isOverdue)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,

                    decorationColor: titleColor,

                    decorationThickness: 1.2,
                  ),
                ),
              ),

              // Mostra a pill somente quando
              // a tarefa estiver vencida.
              if (isOverdue) ...[
                const SizedBox(
                  width: 12,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0x55C0392B)
                        : const Color(0xFFF8D7DA),

                    borderRadius: BorderRadius.circular(
                      999,
                    ),

                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFFE07A7A)
                          : const Color(0xFFD96C6C),
                    ),
                  ),

                  child: Text(
                    'Vencida',

                    style: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFFFFB3B3)
                          : const Color(0xFFC0392B),

                      fontSize: 10,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // -----------------------------
        // DATAS
        // -----------------------------

        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 3,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Início: ${_formatDate(task.startDate)}',

                style: TextStyle(
                  fontSize: 11,
                  color: dateColor,
                ),
              ),

              const SizedBox(
                height: 1,
              ),

              Text(
                'Fim: ${_formatDate(task.endDate)}',

                style: TextStyle(
                  fontSize: 11,
                  color: dateColor,
                ),
              ),
            ],
          ),
        ),

        // -----------------------------
        // LIXEIRA
        // -----------------------------

        trailing: IconButton(
          tooltip: 'Excluir tarefa',

          onPressed: onRemove,

          icon: const Icon(
            Icons.delete_outline,

            // Vermelho para representar exclusão.
            color: Color(
              0xFFD9534F,
            ),
          ),
        ),
      ),
    );
  }
}