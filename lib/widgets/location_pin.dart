import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Pin central animado para o Location Picker (estilo Uber)
/// Estados: idle (pulso), dragging (sobe), drop (bounce)
class LocationPin extends StatefulWidget {
  final bool isDragging;

  const LocationPin({super.key, required this.isDragging});

  @override
  State<LocationPin> createState() => _LocationPinState();
}

class _LocationPinState extends State<LocationPin>
    with TickerProviderStateMixin {
  // Animação de pulso (idle)
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  // Animação de lift/drop (arrastar)
  late final AnimationController _liftController;
  late final Animation<double> _liftAnim;
  late final Animation<double> _shadowAnim;

  @override
  void initState() {
    super.initState();

    // Pulso suave contínuo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Lift quando está arrastando
    _liftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _liftAnim = Tween<double>(begin: 0, end: -14).animate(
      CurvedAnimation(parent: _liftController, curve: Curves.easeOut),
    );
    _shadowAnim = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _liftController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant LocationPin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDragging && !oldWidget.isDragging) {
      // Começa a arrastar → levanta o pin, para o pulso
      _pulseController.stop();
      _pulseController.value = 0; // reset scale to 1.0
      _liftController.forward();
    } else if (!widget.isDragging && oldWidget.isDragging) {
      // Soltou → bounce de volta, reinicia pulso
      _liftController.reverse(from: 1.0).then((_) {
        if (mounted) {
          _pulseController.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _liftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Sombra elíptica no chão ──────────────────────────
          Positioned(
            bottom: 4,
            child: AnimatedBuilder(
              animation: _shadowAnim,
              builder: (context, child) {
                return Container(
                  width: 24 * _shadowAnim.value,
                  height: 8 * _shadowAnim.value,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6 * _shadowAnim.value,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Pin (corpo + haste) ──────────────────────────────
          AnimatedBuilder(
            animation: Listenable.merge([_liftAnim, _pulseAnim]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _liftAnim.value),
                child: ScaleTransition(
                  scale: _pulseAnim,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeça do pin
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                // Haste do pin
                CustomPaint(
                  size: const Size(12, 10),
                  painter: _PinNeedlePainter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Desenha a haste cônica abaixo do corpo do pin
class _PinNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
