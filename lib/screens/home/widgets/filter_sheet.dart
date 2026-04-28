import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/problem_report.dart';
import '../../../providers/problems_provider.dart';
import '../../../widgets/bottom_sheet_handle.dart';

/// Bottom Sheet com filtros de status, tipo e gravidade
/// Conectado ao filterProvider via Riverpod
class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.75,
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
                  const BottomSheetHandle(),
                  const SizedBox(height: 4),

                  // ── Título + Limpar ────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filtrar Problemas',
                          style: AppTextStyles.heading3),
                      if (!filter.isEmpty)
                        TextButton(
                          onPressed: () {
                            ref.read(filterProvider.notifier).clearAll();
                          },
                          child: Text(
                            'Limpar tudo',
                            style: AppTextStyles.labelLarge
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Status ─────────────────────────────────────
                  Text('Status', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ProblemStatus.values.map((status) {
                      final isSelected =
                          filter.statuses.contains(status);
                      return FilterChip(
                        label: Text(status.label),
                        avatar: Icon(status.icon,
                            size: 16,
                            color: isSelected
                                ? AppColors.onPrimary
                                : status.color),
                        selected: isSelected,
                        onSelected: (_) {
                          ref
                              .read(filterProvider.notifier)
                              .toggleStatus(status);
                        },
                        selectedColor: status.color,
                        backgroundColor: AppColors.surface,
                        checkmarkColor: AppColors.onPrimary,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? status.color
                                : AppColors.divider,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Tipo de Problema ────────────────────────────
                  Text('Tipo de Problema',
                      style: AppTextStyles.labelLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ProblemType.values.map((type) {
                      final isSelected = filter.types.contains(type);
                      return FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(type.icon,
                                size: 16,
                                color: isSelected
                                    ? AppColors.onPrimary
                                    : AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(type.label),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          ref
                              .read(filterProvider.notifier)
                              .toggleType(type);
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        checkmarkColor: AppColors.onPrimary,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Gravidade ──────────────────────────────────
                  Text('Gravidade', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Severity.values.map((severity) {
                      final isSelected =
                          filter.severities.contains(severity);
                      return FilterChip(
                        label: Text(severity.label),
                        selected: isSelected,
                        onSelected: (_) {
                          ref
                              .read(filterProvider.notifier)
                              .toggleSeverity(severity);
                        },
                        selectedColor: severity.color,
                        backgroundColor: AppColors.surface,
                        checkmarkColor: AppColors.onPrimary,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? severity.color
                                : AppColors.divider,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ── Botão Aplicar ──────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        filter.isEmpty
                            ? 'Mostrar todos'
                            : 'Aplicar (${filter.activeCount} filtros)',
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
}
