import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const ReconstroiJacareiApp());
}

class ReconstroiJacareiApp extends StatelessWidget {
  const ReconstroiJacareiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
