import 'problem_report.dart';

/// Estado de filtros aplicados no mapa
/// Usado pelo ProblemsProvider para filtrar a lista visível
class FilterState {
  final Set<ProblemStatus> statuses;
  final Set<ProblemType> types;
  final Set<Severity> severities;

  const FilterState({
    this.statuses = const {},
    this.types = const {},
    this.severities = const {},
  });

  /// Retorna true se nenhum filtro está ativo (mostra tudo)
  bool get isEmpty =>
      statuses.isEmpty && types.isEmpty && severities.isEmpty;

  /// Conta quantos filtros estão ativos
  int get activeCount => statuses.length + types.length + severities.length;

  /// Verifica se um problema passa nos filtros ativos
  bool matches(ProblemReport problem) {
    if (statuses.isNotEmpty && !statuses.contains(problem.status)) {
      return false;
    }
    if (types.isNotEmpty && !types.contains(problem.type)) {
      return false;
    }
    if (severities.isNotEmpty && !severities.contains(problem.severity)) {
      return false;
    }
    return true;
  }

  FilterState copyWith({
    Set<ProblemStatus>? statuses,
    Set<ProblemType>? types,
    Set<Severity>? severities,
  }) {
    return FilterState(
      statuses: statuses ?? this.statuses,
      types: types ?? this.types,
      severities: severities ?? this.severities,
    );
  }

  /// Reseta todos os filtros
  static const FilterState empty = FilterState();
}
