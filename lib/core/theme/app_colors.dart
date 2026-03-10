import 'package:flutter/material.dart';

/// Paleta de cores do Reconstrói Jacareí
/// Inspiração visual: Waze — cores vibrantes, marcadores por status
class AppColors {
  AppColors._();

  // ── Primárias ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4A90D9);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color onPrimary = Colors.white;

  // ── Status dos problemas (marcadores estilo Waze) ─────────────────────────
  static const Color statusActive = Color(0xFFE53935); // 🔴 Ativo / urgente
  static const Color statusAnalysis = Color(0xFFFFA000); // 🟡 Em análise
  static const Color statusResolved = Color(0xFF43A047); // 🟢 Resolvido

  // ── Superfícies ────────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceCard = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E2C);

  // ── Texto ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnDark = Colors.white;

  // ── Utilitárias ────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x4D000000);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF43A047);

  // ── Mapa mock ──────────────────────────────────────────────────────────────
  static const Color mapBackground = Color(0xFFE8E8E8);
  static const Color mapGrid = Color(0xFFD5D5D5);
  static const Color mapRoad = Color(0xFFFFFFFF);
  static const Color mapWater = Color(0xFFB3D9FF);
  static const Color mapPark = Color(0xFFC8E6C9);

  // ── Gradientes ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E1E2C), Color(0xFF2D2D44)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
