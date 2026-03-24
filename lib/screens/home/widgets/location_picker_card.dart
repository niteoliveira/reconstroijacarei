import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Card inferior do Location Picker (estilo Uber)
/// Mostra endereço atual, permite buscar e confirmar o local
class LocationPickerCard extends StatelessWidget {
  final String currentAddress;
  final bool isDragging;
  final VoidCallback onConfirm;
  final VoidCallback onSearchTap;

  const LocationPickerCard({
    super.key,
    required this.currentAddress,
    required this.isDragging,
    required this.onConfirm,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ────────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Título + Subtítulo ────────────────────────────────
          Text(
            'Selecione o local do problema',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 4),
          Text(
            'Arraste o mapa para ajustar o ponto',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 20),

          // ── Campo de endereço (tappable) ──────────────────────
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: isDragging
                        ? AppColors.textHint
                        : AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isDragging
                          ? Text(
                              'Identificando endereço...',
                              key: const ValueKey('loading'),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textHint,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Text(
                              currentAddress,
                              key: ValueKey(currentAddress),
                              style: AppTextStyles.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Botão confirmar ───────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isDragging ? null : onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                textStyle: AppTextStyles.buttonLarge,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Confirmar Local'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
