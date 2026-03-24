import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/problem_report.dart';
import '../../../widgets/problem_status_badge.dart';
import '../../../widgets/bottom_sheet_handle.dart';

/// Bottom Sheet com detalhes de um problema existente
/// Abre ao tocar em um marcador no mapa
class ProblemDetailSheet extends StatelessWidget {
  final ProblemReport problem;

  const ProblemDetailSheet({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
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
                        problem.type.icon,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          problem.title,
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
                      ProblemStatusBadge(status: problem.status),
                      _severityBadge(problem.severity),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Info cards ─────────────────────────────────
                  _infoRow(
                    Icons.location_on_outlined,
                    AppStrings.location,
                    '${problem.address} — ${problem.neighborhood}',
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    Icons.calendar_today_outlined,
                    AppStrings.date,
                    _formatDate(problem.reportedAt),
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    Icons.person_outline_rounded,
                    AppStrings.reportedBy,
                    problem.reportedBy,
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Descrição ──────────────────────────────────
                  Text(AppStrings.description,
                      style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    problem.description,
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
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodyMedium,
                              children: [
                                TextSpan(
                                  text: '${problem.confirmations} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: AppStrings.confirmations,
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
                      onPressed: () {
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
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text(AppStrings.markResolved),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.onPrimary,
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
