import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reconstroijacarei/main.dart';

void main() {
  testWidgets('HomeScreen renders without overflow', (tester) async {
    await tester.pumpWidget(const ReconstroiJacareiApp());

    // Avança o Future.delayed de 400ms
    await tester.pump(const Duration(milliseconds: 500));

    // Avança a animação elasticOut de 600ms
    await tester.pump(const Duration(milliseconds: 700));

    // Verifica que a barra de pesquisa está presente
    expect(find.text('Buscar endereço ou problema...'), findsOneWidget);

    // Verifica que os FABs estão presentes
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.byIcon(Icons.my_location_rounded), findsOneWidget);
  });
}
