class Task {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime startDate;
  final DateTime endDate;

  Task({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });// Criada a classe Task com os atributos id, title, isCompleted, startDate e endDate. O atributo isCompleted é inicializado como false por padrão.
   // Verifica se a tarefa está vencida.
  bool get isOverdue { // isOverdue é um getter que retorna true se a tarefa estiver vencida e false caso contrário.
    final DateTime now = DateTime.now();

    // Considera apenas o dia, mês e ano.
    final DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime endDay = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    // A tarefa está vencida quando:
    // 1. ainda não foi concluída;
    // 2. a data final já passou.
    return !isCompleted && endDay.isBefore(today);
  }
}