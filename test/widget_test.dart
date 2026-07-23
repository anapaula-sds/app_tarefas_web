import 'package:app_tarefas_web/main.dart';
import 'package:app_tarefas_web/providers/task_provider.dart';
import 'package:app_tarefas_web/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Cria o aplicativo com os Providers necessários para os testes.
Widget createTestApp() {
  return MultiProvider(
    providers: [
      // Provider responsável pelo estado das tarefas.
      ChangeNotifierProvider(
        create: (_) => TaskProvider(),
      ),

      // Provider responsável pelo tema claro e escuro.
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      ),
    ],
    child: const MyApp(),
  );
}

void main() {
  testWidgets(
    'deve exibir o estado inicial sem tarefas',
    (WidgetTester tester) async {
      // Renderiza o aplicativo para o teste.
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verifica o título da aplicação.
      expect(
        find.text('Minhas Tarefas'),
        findsOneWidget,
      );

      // Verifica os nomes dos contadores.
      expect(
        find.text('Total'),
        findsOneWidget,
      );

      expect(
        find.text('Pendentes'),
        findsOneWidget,
      );

      expect(
        find.text('Concluídas'),
        findsOneWidget,
      );

      // No estado inicial, os três contadores possuem valor zero.
      expect(
        find.text('0'),
        findsNWidgets(3),
      );

      // Verifica se a mensagem de lista vazia aparece.
      expect(
        find.text('Nenhuma tarefa cadastrada'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'deve adicionar uma tarefa e atualizar os contadores',
    (WidgetTester tester) async {
      // Renderiza o aplicativo para o teste.
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Digita o título da nova tarefa.
      await tester.enterText(
        find.byType(TextField),
        'Estudar Flutter',
      );

      // Abre o calendário da data de início.
      await tester.tap(
        find.text('Data início'),
      );

      await tester.pumpAndSettle();

      // Confirma a data inicial selecionada pelo calendário.
      await tester.tap(
        find.text('OK'),
      );

      await tester.pumpAndSettle();

      // Abre o calendário da data de fim.
      await tester.tap(
        find.text('Data fim'),
      );

      await tester.pumpAndSettle();

      // Confirma a data final selecionada pelo calendário.
      await tester.tap(
        find.text('OK'),
      );

      await tester.pumpAndSettle();

      // Adiciona a tarefa.
      await tester.tap(
        find.text('Adicionar'),
      );

      await tester.pumpAndSettle();

      // Verifica se a tarefa aparece na lista.
      expect(
        find.text('Estudar Flutter'),
        findsOneWidget,
      );

      // Agora existem:
      // Total = 1
      // Pendentes = 1
      // Concluídas = 0
      expect(
        find.text('1'),
        findsNWidgets(2),
      );

      expect(
        find.text('0'),
        findsOneWidget,
      );

      // A mensagem de lista vazia não deve mais aparecer.
      expect(
        find.text('Nenhuma tarefa cadastrada'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'não deve adicionar uma tarefa vazia',
    (WidgetTester tester) async {
      // Renderiza o aplicativo para o teste.
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Digita apenas espaços no campo.
      await tester.enterText(
        find.byType(TextField),
        '   ',
      );

      // Tenta adicionar a tarefa.
      await tester.tap(
        find.text('Adicionar'),
      );

      await tester.pumpAndSettle();

      // Os três contadores devem continuar zerados.
      expect(
        find.text('0'),
        findsNWidgets(3),
      );

      // A mensagem de lista vazia deve continuar aparecendo.
      expect(
        find.text('Nenhuma tarefa cadastrada'),
        findsOneWidget,
      );
    },
  );
}