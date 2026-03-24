import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/problem_report.dart';

/// Marcador estilo Waze para o mapa — Sprint 7: animação de pulso ao selecionar
/// Círculo colorido com ícone branco, sombra e micro-animações
class MapMarker extends StatefulWidget {
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
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MapMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.problem.status.color;
    final double size = widget.isSelected ? 48 : 40;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: widget.isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Corpo do marcador ────────────────────────────
            ScaleTransition(
              scale: widget.isSelected ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
              child: Container(
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
                      color: color.withValues(alpha: widget.isSelected ? 0.6 : 0.4),
                      blurRadius: widget.isSelected ? 16 : 8,
                      spreadRadius: widget.isSelected ? 2 : 0,
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
                  widget.problem.type.icon,
                  color: AppColors.onPrimary,
                  size: size * 0.45,
                ),
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
