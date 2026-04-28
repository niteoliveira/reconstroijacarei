import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(
    // ProviderScope envolve todo o app — necessário para Riverpod funcionar
    const ProviderScope(
      child: ReconstroiJacareiApp(),
    ),
  );
}

class ReconstroiJacareiApp extends StatelessWidget {
  const ReconstroiJacareiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
