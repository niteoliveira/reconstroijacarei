import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reconstroijacarei/core/theme/app_theme.dart';
import 'package:reconstroijacarei/screens/profile/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('renders user name, email, and logout option',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      // Nome e email do mock user
      expect(find.text('Leonardo Oliveira'), findsOneWidget);
      expect(find.text('leonardo@email.com'), findsOneWidget);

      // Badge de contribuidor
      expect(find.text('Contribuidor Ativo'), findsOneWidget);

      // Opções de menu
      expect(find.text('Configurações'), findsOneWidget);
      expect(find.text('Ajuda'), findsOneWidget);
      expect(find.text('Sair'), findsOneWidget);

      // Versão no footer
      expect(find.text('Versão 1.0.0 • Relatório de Problemas'),
          findsOneWidget);
    });
  });
}
