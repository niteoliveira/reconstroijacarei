import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/problem_report.dart';
import '../../../widgets/bottom_sheet_handle.dart';

/// Bottom Sheet para reportar um novo problema
/// Sprint 8: recebe endereço do location picker
class ReportProblemSheet extends StatefulWidget {
  final String initialAddress;

  const ReportProblemSheet({
    super.key,
    this.initialAddress = 'R. Barão de Jacarehy, 200 — Centro',
  });

  @override
  State<ReportProblemSheet> createState() => _ReportProblemSheetState();
}

class _ReportProblemSheetState extends State<ReportProblemSheet> {
  ProblemType? _selectedType;
  Severity _selectedSeverity = Severity.medium;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                  const SizedBox(height: 4),

                  // ── Título ────────────────────────────────────
                  Center(
                    child: Text(
                      AppStrings.reportTitle,
                      style: AppTextStyles.heading3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Endereço detectado (mock) ─────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.detectedAddress,
                                style: AppTextStyles.labelSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.initialAddress,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Fecha o sheet → volta ao picker
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.edit_location_alt_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Tipo de problema ──────────────────────────
                  Text(AppStrings.problemType, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ProblemType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              type.icon,
                              size: 16,
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(type.label),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = selected ? type : null;
                          });
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
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
                          horizontal: 8,
                          vertical: 6,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Gravidade ─────────────────────────────────
                  Text(AppStrings.severity, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 10),
                  _buildSeveritySelector(),
                  const SizedBox(height: 24),

                  // ── Descrição ─────────────────────────────────
                  Text(AppStrings.description, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Descreva o problema com detalhes...',
                      hintStyle: AppTextStyles.searchHint,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Botões ────────────────────────────────────
                  Row(
                    children: [
                      // Cancelar
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(AppStrings.cancel),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Confirmar
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _selectedType != null
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Row(
                                          children: [
                                            Icon(Icons.send_rounded,
                                                color: Colors.white, size: 20),
                                            SizedBox(width: 10),
                                            Text(AppStrings.reportSent),
                                          ],
                                        ),
                                        backgroundColor: AppColors.primary,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        margin: const EdgeInsets.all(16),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                : null,
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: const Text(AppStrings.confirm),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildSeveritySelector() {
    return Row(
      children: Severity.values.map((severity) {
        final isSelected = _selectedSeverity == severity;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedSeverity = severity),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: severity != Severity.high ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? severity.color.withValues(alpha: 0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? severity.color
                      : AppColors.divider,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _severityIcon(severity),
                    color: isSelected
                        ? severity.color
                        : AppColors.textHint,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    severity.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? severity.color
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _severityIcon(Severity severity) {
    switch (severity) {
      case Severity.low:
        return Icons.arrow_downward_rounded;
      case Severity.medium:
        return Icons.remove_rounded;
      case Severity.high:
        return Icons.arrow_upward_rounded;
    }
  }
}
