import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reconstroijacarei/core/theme/app_theme.dart';
import 'package:reconstroijacarei/screens/search/search_screen.dart';

void main() {
  group('SearchScreen', () {
    testWidgets('renders recent searches and suggestions sections',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const SearchScreen(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 400));

      // Seções de conteúdo
      expect(find.text('Buscas Recentes'), findsOneWidget);
      expect(find.text('Sugestões'), findsOneWidget);

      // Exemplos de buscas recentes (mock)
      expect(find.text('Rua Alfredo Bueno, 155'), findsOneWidget);

      // Exemplos de sugestões (mock)
      expect(find.text('Av. Presidente Vargas, 1200'), findsOneWidget);
    });

    testWidgets('filters results when typing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const SearchScreen(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 400));

      // Digita texto no campo de busca
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Alfredo');
      await tester.pump();

      // Deve filtrar: só "Alfredo" aparece
      expect(find.text('Rua Alfredo Bueno, 155'), findsOneWidget);
      expect(find.text('Rua Alfredo Bueno, 250'), findsOneWidget);

      // Outros endereços devem sumir
      expect(find.text('Av. Presidente Vargas, 1200'), findsNothing);
    });

    testWidgets('shows empty state for no results', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const SearchScreen(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 400));

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'xyzxyzxyz');
      await tester.pump();

      expect(find.text('Nenhum resultado encontrado'), findsOneWidget);
    });
  });
}
