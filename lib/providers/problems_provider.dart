import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/problem_report.dart';
import '../models/filter_state.dart';
import '../data/mock_problems.dart';

/// Provider de filtros ativos
final filterProvider =
    StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

/// Provider da lista completa de problemas (fonte de verdade)
final problemsProvider =
    StateNotifierProvider<ProblemsNotifier, List<ProblemReport>>((ref) {
  return ProblemsNotifier();
});

/// Provider derivado: problemas filtrados para exibir no mapa
final filteredProblemsProvider = Provider<List<ProblemReport>>((ref) {
  final problems = ref.watch(problemsProvider);
  final filter = ref.watch(filterProvider);

  if (filter.isEmpty) return problems;
  return problems.where((p) => filter.matches(p)).toList();
});

// ── Filter Notifier ──────────────────────────────────────────

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState.empty);

  void toggleStatus(ProblemStatus status) {
    final updated = Set<ProblemStatus>.from(state.statuses);
    if (updated.contains(status)) {
      updated.remove(status);
    } else {
      updated.add(status);
    }
    state = state.copyWith(statuses: updated);
  }

  void toggleType(ProblemType type) {
    final updated = Set<ProblemType>.from(state.types);
    if (updated.contains(type)) {
      updated.remove(type);
    } else {
      updated.add(type);
    }
    state = state.copyWith(types: updated);
  }

  void toggleSeverity(Severity severity) {
    final updated = Set<Severity>.from(state.severities);
    if (updated.contains(severity)) {
      updated.remove(severity);
    } else {
      updated.add(severity);
    }
    state = state.copyWith(severities: updated);
  }

  void clearAll() {
    state = FilterState.empty;
  }
}

// ── Problems Notifier ────────────────────────────────────────

class ProblemsNotifier extends StateNotifier<List<ProblemReport>> {
  ProblemsNotifier() : super(List.from(mockProblems));

  /// Adiciona um novo problema (mock — depois chama API)
  void addProblem(ProblemReport problem) {
    state = [problem, ...state];
  }

  /// Marca um problema como resolvido
  void markResolved(String id, {String resolvedBy = 'Você'}) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            status: ProblemStatus.resolved,
            resolvedAt: DateTime.now(),
            resolvedBy: resolvedBy,
            updatedAt: DateTime.now(),
          )
        else
          p,
    ];
  }

  /// Confirma que o problema persiste
  void confirmProblem(String id) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            confirmations: p.confirmations + 1,
            confirmedByCurrentUser: true,
            updatedAt: DateTime.now(),
          )
        else
          p,
    ];
  }

  /// Nega a persistência (nem incrementa nem confirma)
  void denyProblem(String id) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            confirmedByCurrentUser: true,
            updatedAt: DateTime.now(),
          )
        else
          p,
    ];
  }

  /// Retorna o próximo problema ativo que o usuário NÃO confirmou ainda
  /// (para o QuickConfirmCard)
  ProblemReport? get nextUnconfirmedProblem {
    try {
      return state.firstWhere(
        (p) =>
            p.status == ProblemStatus.active &&
            !p.confirmedByCurrentUser,
      );
    } catch (_) {
      return null;
    }
  }
}
