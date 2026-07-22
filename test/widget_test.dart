import 'package:app_tarefas_web/main.dart';
import 'package:app_tarefas_web/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Cria o aplicativo com o Provider necessário para os testes.
Widget createTestApp() {
  return ChangeNotifierProvider(
    create: (_) => TaskProvider(),
    child: const MyApp(),
  );
}

void main() {
  testWidgets('deve exibir o estado inicial sem tarefas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Minhas Tarefas'), findsOneWidget);
    expect(find.text('Total: 0'), findsOneWidget);
    expect(find.text('Pendentes: 0'), findsOneWidget);
    expect(find.text('Concluídas: 0'), findsOneWidget);
    expect(find.text('Nenhuma tarefa cadastrada.'), findsOneWidget);
  });

  testWidgets('deve adicionar uma tarefa e atualizar os contadores', (
    WidgetTester tester,
  ) async {
    // pumpWidget é usado para renderizar o widget na tela de teste.  
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle(); // pumpAndSettle é usado para aguardar a conclusão de todas as animações e atualizações de estado antes de prosseguir com os testes.

    // enterText é usado para simular a digitação de texto no campo de entrada.
    await tester.enterText(find.byType(TextField), 'Estudar Flutter');

    await tester.tap(find.text('Adicionar')); //tap é usado para simular o toque em um botão ou outro widget interativo.
    await tester.pumpAndSettle();

    // expect(find.text('Estudar Flutter'), findsOneWidget); // Verifica se a tarefa foi adicionada à lista; // findsOneWidget é usado para verificar se o widget foi encontrado exatamente uma vez na árvore de widgets.
    expect(find.text('Estudar Flutter'), findsOneWidget);
    expect(find.text('Total: 1'), findsOneWidget);
    expect(find.text('Pendentes: 1'), findsOneWidget);
    expect(find.text('Concluídas: 0'), findsOneWidget);
    expect(find.text('Nenhuma tarefa cadastrada.'), findsNothing);
  });

  testWidgets('não deve adicionar uma tarefa vazia', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '   ');

    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();

    expect(find.text('Total: 0'), findsOneWidget);
    expect(find.text('Pendentes: 0'), findsOneWidget);
    expect(find.text('Concluídas: 0'), findsOneWidget);
    expect(find.text('Nenhuma tarefa cadastrada.'), findsOneWidget);
  });
}
