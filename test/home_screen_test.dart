import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reconstroijacarei/core/theme/app_theme.dart';
import 'package:reconstroijacarei/screens/home/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders FloatingSearchBar and FABs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            home: const HomeScreen(),
          ),
        ),
      );

      // Espera o build e animações iniciais
      await tester.pump(const Duration(milliseconds: 100));

      // FloatingSearchBar deve estar presente (hint text)
      expect(find.text('Buscar endereço ou problema...'), findsOneWidget);

      // Aguarda animações de FABs
      await tester.pump(const Duration(milliseconds: 800));

      // FABs devem existir
      expect(find.byType(FloatingActionButton), findsWidgets);
    });
  });
}
