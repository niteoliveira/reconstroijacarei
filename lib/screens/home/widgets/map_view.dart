import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_problems.dart';
import '../../../models/problem_report.dart';
import '../../../widgets/map_marker.dart';

/// Widget do mapa simulado estilo Waze
/// Container cinza com ruas, áreas e marcadores posicionados
/// Sprint 8: suporte a modo de seleção com pan (arrastar)
class MapView extends StatelessWidget {
  final String? selectedProblemId;
  final ValueChanged<ProblemReport>? onMarkerTap;

  // ── Sprint 8: Location Picker ──────────────────────────────
  final bool isSelectionMode;
  final Offset mapOffset;
  final ValueChanged<Offset>? onPanUpdate;
  final VoidCallback? onPanStart;
  final VoidCallback? onPanEnd;

  const MapView({
    super.key,
    this.selectedProblemId,
    this.onMarkerTap,
    this.isSelectionMode = false,
    this.mapOffset = Offset.zero,
    this.onPanUpdate,
    this.onPanStart,
    this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          // Pan só funciona em modo seleção
          onPanStart: isSelectionMode ? (_) => onPanStart?.call() : null,
          onPanUpdate: isSelectionMode
              ? (details) => onPanUpdate?.call(details.delta)
              : null,
          onPanEnd: isSelectionMode ? (_) => onPanEnd?.call() : null,
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: AppColors.mapBackground,
            child: Stack(
              children: [
                // ── Fundo do mapa com ruas (deslocável) ──────────
                Transform.translate(
                  offset: mapOffset,
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: _MapPainter(),
                  ),
                ),

                // ── Marcadores (ocultos em modo seleção) ─────────
                if (!isSelectionMode)
                  ...mockProblems.map((problem) {
                    final left =
                        problem.relativeX * constraints.maxWidth - 20;
                    final top =
                        problem.relativeY * constraints.maxHeight - 48;

                    return Positioned(
                      left: left.clamp(0, constraints.maxWidth - 48),
                      top: top.clamp(0, constraints.maxHeight - 56),
                      child: MapMarker(
                        problem: problem,
                        isSelected: problem.id == selectedProblemId,
                        onTap: () => onMarkerTap?.call(problem),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pinta ruas e áreas simulando um mapa estilo Waze
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.mapRoad
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final thinRoadPaint = Paint()
      ..color = AppColors.mapRoad
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final waterPaint = Paint()..color = AppColors.mapWater;
    final parkPaint = Paint()..color = AppColors.mapPark;

    // ── Área de parque ──────────────────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.05,
          size.height * 0.1,
          size.width * 0.18,
          size.height * 0.15,
        ),
        const Radius.circular(8),
      ),
      parkPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.7,
          size.height * 0.75,
          size.width * 0.2,
          size.height * 0.12,
        ),
        const Radius.circular(8),
      ),
      parkPaint,
    );

    // ── Corpo d'água (rio) ──────────────────────────────
    final riverPath = Path()
      ..moveTo(0, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.92,
        size.width * 0.5,
        size.height * 0.88,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.84,
        size.width,
        size.height * 0.9,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(riverPath, waterPaint);

    // ── Ruas principais (horizontais) ───────────────────
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );

    // ── Ruas principais (verticais) ─────────────────────
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height * 0.82),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width * 0.65, size.height * 0.82),
      roadPaint,
    );

    // ── Ruas secundárias ────────────────────────────────
    canvas.drawLine(
      Offset(0, size.height * 0.42),
      Offset(size.width * 0.3, size.height * 0.42),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.42),
      Offset(size.width, size.height * 0.42),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.65, size.height * 0.7),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.3),
      Offset(size.width * 0.48, size.height * 0.55),
      thinRoadPaint,
    );

    // ── Rua diagonal ────────────────────────────────────
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.3),
      Offset(size.width * 0.85, size.height * 0.55),
      thinRoadPaint,
    );

    // ── Rotatória ───────────────────────────────────────
    canvas.drawCircle(
      Offset(size.width * 0.48, size.height * 0.55),
      14,
      Paint()..color = AppColors.mapRoad,
    );
    canvas.drawCircle(
      Offset(size.width * 0.48, size.height * 0.55),
      6,
      Paint()..color = AppColors.mapBackground,
    );

    // ── Grade sutil ─────────────────────────────────────
    final gridPaint = Paint()
      ..color = AppColors.mapGrid.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
