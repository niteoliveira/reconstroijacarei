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
///
/// Este modelo define o **contrato JSON** entre o frontend e a API.
/// Os métodos `fromJson` e `toJson` documentam exatamente o formato esperado.
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

  /// Coordenadas geográficas reais (Jacareí)
  final double latitude;
  final double longitude;

  // ── Campos novos (backend) ──────────────────────────────────

  /// URL da foto anexada ao reporte (pode ser nula se sem foto)
  final String? imageUrl;

  /// Data em que o problema foi marcado como resolvido
  final DateTime? resolvedAt;

  /// Nome/ID de quem marcou como resolvido
  final String? resolvedBy;

  /// Timestamp da última atualização (status, confirmações, etc.)
  final DateTime updatedAt;

  /// Se o usuário logado atual já confirmou este problema
  /// (evita duplo voto na UI — o backend controla a lista real)
  final bool confirmedByCurrentUser;

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
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.resolvedAt,
    this.resolvedBy,
    required this.updatedAt,
    this.confirmedByCurrentUser = false,
  });

  // ── fromJson — constrói a partir do JSON da API ─────────────
  //
  // Exemplo de JSON esperado:
  // {
  //   "id": "abc-123",
  //   "type": "hole",
  //   "status": "active",
  //   "severity": "high",
  //   "title": "Buraco na Av. Nove de Julho",
  //   "description": "Buraco grande...",
  //   "address": "Av. Nove de Julho, 1245",
  //   "neighborhood": "Centro",
  //   "reportedBy": "Maria Silva",
  //   "reportedAt": "2026-03-05T14:30:00.000Z",
  //   "confirmations": 23,
  //   "latitude": -23.302,
  //   "longitude": -45.967,
  //   "imageUrl": null,
  //   "resolvedAt": null,
  //   "resolvedBy": null,
  //   "updatedAt": "2026-03-05T14:30:00.000Z",
  //   "confirmedByCurrentUser": false
  // }

  factory ProblemReport.fromJson(Map<String, dynamic> json) {
    return ProblemReport(
      id: json['id'] as String,
      type: ProblemType.values.byName(json['type'] as String),
      status: ProblemStatus.values.byName(json['status'] as String),
      severity: Severity.values.byName(json['severity'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      neighborhood: json['neighborhood'] as String,
      reportedBy: json['reportedBy'] as String,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      confirmations: json['confirmations'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
      resolvedBy: json['resolvedBy'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      confirmedByCurrentUser:
          json['confirmedByCurrentUser'] as bool? ?? false,
    );
  }

  // ── toJson — converte para JSON (resposta completa) ─────────

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'status': status.name,
      'severity': severity.name,
      'title': title,
      'description': description,
      'address': address,
      'neighborhood': neighborhood,
      'reportedBy': reportedBy,
      'reportedAt': reportedAt.toIso8601String(),
      'confirmations': confirmations,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'updatedAt': updatedAt.toIso8601String(),
      'confirmedByCurrentUser': confirmedByCurrentUser,
    };
  }

  // ── toCreateJson — corpo do POST para criar novo problema ───
  //
  // Campos como id, status, confirmations, resolvedAt, updatedAt
  // são gerados pelo backend, então não vão nesse JSON.

  Map<String, dynamic> toCreateJson() {
    return {
      'type': type.name,
      'severity': severity.name,
      'title': title,
      'description': description,
      'address': address,
      'neighborhood': neighborhood,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // ── copyWith — cria cópia com campos alterados ──────────────
  //
  // Usado para atualizar o estado sem mutação.
  // Ex: problem.copyWith(status: ProblemStatus.resolved)

  ProblemReport copyWith({
    String? id,
    ProblemType? type,
    ProblemStatus? status,
    Severity? severity,
    String? title,
    String? description,
    String? address,
    String? neighborhood,
    String? reportedBy,
    DateTime? reportedAt,
    int? confirmations,
    double? latitude,
    double? longitude,
    String? imageUrl,
    DateTime? resolvedAt,
    String? resolvedBy,
    DateTime? updatedAt,
    bool? confirmedByCurrentUser,
  }) {
    return ProblemReport(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedAt: reportedAt ?? this.reportedAt,
      confirmations: confirmations ?? this.confirmations,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      confirmedByCurrentUser:
          confirmedByCurrentUser ?? this.confirmedByCurrentUser,
    );
  }
}
