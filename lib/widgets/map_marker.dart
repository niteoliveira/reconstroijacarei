import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/problem_report.dart';

/// Marcador estilo Waze para o mapa
/// Círculo colorido com ícone branco e sombra
class MapMarker extends StatelessWidget {
  final ProblemReport problem;
  final VoidCallback? onTap;
  final bool isSelected;

  const MapMarker({
    super.key,
    required this.problem,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = problem.status.color;
    final double size = isSelected ? 48 : 40;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Corpo do marcador ────────────────────────────
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surfaceCard,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                problem.type.icon,
                color: AppColors.onPrimary,
                size: size * 0.45,
              ),
            ),

            // ── Seta do marcador ────────────────────────────
            CustomPaint(
              size: const Size(12, 8),
              painter: _MarkerArrowPainter(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Desenha a seta triangular abaixo do marcador
class _MarkerArrowPainter extends CustomPainter {
  final Color color;

  _MarkerArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MarkerArrowPainter oldDelegate) =>
      color != oldDelegate.color;
}
