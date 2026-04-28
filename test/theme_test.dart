import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reconstroijacarei/core/theme/app_colors.dart';
import 'package:reconstroijacarei/core/theme/app_text_styles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppColors', () {
    test('primary colors are defined', () {
      expect(AppColors.primary.toARGB32(), isNonZero);
      expect(AppColors.primaryLight.toARGB32(), isNonZero);
      expect(AppColors.primaryDark.toARGB32(), isNonZero);
    });

    test('status colors match Waze-style spec', () {
      expect((AppColors.statusActive.r * 255).round(), greaterThan(200));
      expect((AppColors.statusAnalysis.g * 255).round(), greaterThan(100));
      expect((AppColors.statusResolved.g * 255).round(), greaterThan(100));
    });

    test('surface and text colors are defined', () {
      expect(AppColors.surface.toARGB32(), isNonZero);
      expect(AppColors.surfaceCard.toARGB32(), isNonZero);
      expect(AppColors.textPrimary.toARGB32(), isNonZero);
      expect(AppColors.textSecondary.toARGB32(), isNonZero);
    });
  });

  group('AppTextStyles', () {
    // Google Fonts precisa de rede em testes, então testamos
    // apenas com allowRuntimeFetching = false e usando
    // um widget pump para que o fallback funcione
    testWidgets('heading styles render in a widget', (tester) async {
      GoogleFonts.config.allowRuntimeFetching = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('H1', style: AppTextStyles.heading1),
                Text('H2', style: AppTextStyles.heading2),
                Text('H3', style: AppTextStyles.heading3),
                Text('Body', style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ),
      );

      // Se renderizou sem crash, os estilos estão OK
      expect(find.text('H1'), findsOneWidget);
      expect(find.text('H2'), findsOneWidget);
      expect(find.text('H3'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });
  });
}
