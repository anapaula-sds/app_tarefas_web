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
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        // Checkbox para marcar a tarefa como concluída ou pendente.
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            onToggle();
          },
        ),

        // Título da tarefa.
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),

        // Informações adicionais da tarefa.
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Início: ${_formatDate(task.startDate)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Fim: ${_formatDate(task.endDate)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                ),
              ),

              // Exibe o aviso somente quando a tarefa estiver vencida.
              if (task.isOverdue) ...[
                const SizedBox(height: 4),

                const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Color(0xFFC0392B),
                    ),

                    SizedBox(width: 4),

                    Text(
                      'Tarefa vencida',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFC0392B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Botão para excluir a tarefa.
        trailing: IconButton(
          onPressed: onRemove,
          icon: const Icon(
            Icons.delete_outline,
          ),
        ),
      ),
    );
  }
}