import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Status possíveis de um problema
enum ProblemStatus {
  active,
  analysis,
  resolved;

  String get label {
    switch (this) {
      case ProblemStatus.active:
        return 'Ativo';
      case ProblemStatus.analysis:
        return 'Em Análise';
      case ProblemStatus.resolved:
        return 'Resolvido';
    }
  }

  Color get color {
    switch (this) {
      case ProblemStatus.active:
        return AppColors.statusActive;
      case ProblemStatus.analysis:
        return AppColors.statusAnalysis;
      case ProblemStatus.resolved:
        return AppColors.statusResolved;
    }
  }

  IconData get icon {
    switch (this) {
      case ProblemStatus.active:
        return Icons.warning_rounded;
      case ProblemStatus.analysis:
        return Icons.search_rounded;
      case ProblemStatus.resolved:
        return Icons.check_circle_rounded;
    }
  }
}

/// Tipos de problema
enum ProblemType {
  hole('Buraco', Icons.circle_outlined),
  crack('Rachadura', Icons.broken_image_outlined),
  unevenness('Desnível', Icons.trending_up_rounded),
  signage('Sinalização', Icons.signpost_outlined),
  other('Outro', Icons.more_horiz_rounded);

  const ProblemType(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Nível de gravidade
enum Severity {
  low('Baixa'),
  medium('Média'),
  high('Alta');

  const Severity(this.label);
  final String label;

  Color get color {
    switch (this) {
      case Severity.low:
        return AppColors.statusResolved;
      case Severity.medium:
        return AppColors.statusAnalysis;
      case Severity.high:
        return AppColors.statusActive;
    }
  }
}

/// Modelo de dados de um problema reportado
class ProblemReport {
  final String id;
  final ProblemType type;
  final ProblemStatus status;
  final Severity severity;
  final String title;
  final String description;
  final String address;
  final String neighborhood;
  final String reportedBy;
  final DateTime reportedAt;
  final int confirmations;

  /// Posição relativa no mapa mock (0.0 a 1.0)
  final double relativeX;
  final double relativeY;

  const ProblemReport({
    required this.id,
    required this.type,
    required this.status,
    required this.severity,
    required this.title,
    required this.description,
    required this.address,
    required this.neighborhood,
    required this.reportedBy,
    required this.reportedAt,
    required this.confirmations,
    required this.relativeX,
    required this.relativeY,
  });
}
