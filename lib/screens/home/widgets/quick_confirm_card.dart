import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/problem_report.dart';

/// Card de confirmação rápida flutuante no rodapé do mapa
/// Pergunta se um problema próximo ainda persiste
class QuickConfirmCard extends StatelessWidget {
  final ProblemReport problem;
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  final VoidCallback? onDismiss;

  const QuickConfirmCard({
    super.key,
    required this.problem,
    this.onYes,
    this.onNo,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 72), // espaço para os FABs
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Linha superior: tipo + confirmações + fechar ────
          Row(
            children: [
              // Ícone do tipo
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: problem.status.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  problem.type.icon,
                  size: 16,
                  color: problem.status.color,
                ),
              ),
              const SizedBox(width: 10),

              // Tipo + contagem
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: problem.type.label,
                        style: AppTextStyles.labelLarge,
                      ),
                      TextSpan(
                        text: ': ${problem.confirmations}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botão fechar
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Pergunta ───────────────────────────────────────
          Text(
            '${problem.title} — ${AppStrings.quickConfirmQuestion}',
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // ── Botões Sim / Não ───────────────────────────────
          Row(
            children: [
              // Sim
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: onYes,
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text(AppStrings.yes),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusResolved,
                      foregroundColor: AppColors.onPrimary,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Não
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: onNo,
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: const Text(AppStrings.no),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusActive,
                      foregroundColor: AppColors.onPrimary,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
