import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/problem_report.dart';
import '../../../providers/problems_provider.dart';
import '../../../widgets/problem_status_badge.dart';
import '../../../widgets/bottom_sheet_handle.dart';

/// Bottom Sheet com detalhes de um problema existente
/// Abre ao tocar em um marcador no mapa
class ProblemDetailSheet extends ConsumerWidget {
  final ProblemReport problem;

  const ProblemDetailSheet({super.key, required this.problem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pega a versão atualizada do problema (pode ter sido alterado pelo provider)
    final problems = ref.watch(problemsProvider);
    final currentProblem = problems.firstWhere(
      (p) => p.id == problem.id,
      orElse: () => problem,
    );

    final isResolved = currentProblem.status == ProblemStatus.resolved;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Handle ────────────────────────────────────
                  const BottomSheetHandle(),
                  const SizedBox(height: 8),

                  // ── Tipo + Status ─────────────────────────────
                  Row(
                    children: [
                      Icon(
                        currentProblem.type.icon,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          currentProblem.title,
                          style: AppTextStyles.heading3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Badges ────────────────────────────────────
                  Wrap(
                    spacing: 8,
                    children: [
                      ProblemStatusBadge(status: currentProblem.status),
                      _severityBadge(currentProblem.severity),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Info cards ─────────────────────────────────
                  _infoRow(
                    Icons.location_on_outlined,
                    AppStrings.location,
                    '${currentProblem.address} — ${currentProblem.neighborhood}',
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    Icons.calendar_today_outlined,
                    AppStrings.date,
                    _formatDate(currentProblem.reportedAt),
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    Icons.person_outline_rounded,
                    AppStrings.reportedBy,
                    currentProblem.reportedBy,
                  ),

                  // ── Info de resolução (se resolvido) ───────────
                  if (currentProblem.resolvedAt != null) ...[
                    const SizedBox(height: 12),
                    _infoRow(
                      Icons.check_circle_outline_rounded,
                      'Resolvido em',
                      '${_formatDate(currentProblem.resolvedAt!)}${currentProblem.resolvedBy != null ? ' por ${currentProblem.resolvedBy}' : ''}',
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Descrição ──────────────────────────────────
                  Text(AppStrings.description,
                      style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    currentProblem.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Banner de confirmações ─────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: currentProblem.confirmedByCurrentUser
                          ? AppColors.success.withValues(alpha: 0.08)
                          : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: currentProblem.confirmedByCurrentUser
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          currentProblem.confirmedByCurrentUser
                              ? Icons.check_circle_rounded
                              : Icons.people_outline_rounded,
                          color: currentProblem.confirmedByCurrentUser
                              ? AppColors.success
                              : AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodyMedium,
                              children: [
                                TextSpan(
                                  text: '${currentProblem.confirmations} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        currentProblem.confirmedByCurrentUser
                                            ? AppColors.success
                                            : AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: currentProblem.confirmedByCurrentUser
                                      ? 'pessoas confirmaram • Você já confirmou'
                                      : AppStrings.confirmations,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Botão "Marcar como Resolvido" ──────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isResolved
                          ? null
                          : () {
                              ref
                                  .read(problemsProvider.notifier)
                                  .markResolved(currentProblem.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(Icons.check_circle_rounded,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 10),
                                      Text(AppStrings.markedResolved),
                                    ],
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                      icon: Icon(isResolved
                          ? Icons.check_circle_rounded
                          : Icons.check_circle_outline_rounded),
                      label: Text(isResolved
                          ? 'Já resolvido'
                          : AppStrings.markResolved),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.onPrimary,
                        disabledBackgroundColor:
                            AppColors.success.withValues(alpha: 0.3),
                        disabledForegroundColor:
                            AppColors.onPrimary.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _severityBadge(Severity severity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: severity.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: severity.color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        severity.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: severity.color,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
