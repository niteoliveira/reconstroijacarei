import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reconstroijacarei/providers/problems_provider.dart';
import 'package:reconstroijacarei/models/problem_report.dart';
import 'package:reconstroijacarei/models/filter_state.dart';

void main() {
  group('ProblemsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts with mock problems', () {
      final problems = container.read(problemsProvider);
      expect(problems.length, 5);
    });

    test('markResolved changes status', () {
      container.read(problemsProvider.notifier).markResolved('1');
      final problem = container
          .read(problemsProvider)
          .firstWhere((p) => p.id == '1');
      expect(problem.status, ProblemStatus.resolved);
      expect(problem.resolvedAt, isNotNull);
    });

    test('confirmProblem increments count and marks user', () {
      container.read(problemsProvider.notifier).confirmProblem('1');
      final problem = container
          .read(problemsProvider)
          .firstWhere((p) => p.id == '1');
      expect(problem.confirmations, 24); // was 23
      expect(problem.confirmedByCurrentUser, true);
    });

    test('nextUnconfirmedProblem skips confirmed ones', () {
      final notifier = container.read(problemsProvider.notifier);

      // Problema 1 é active e não confirmado
      var next = notifier.nextUnconfirmedProblem;
      expect(next?.id, '1');

      // Confirma problema 1
      notifier.confirmProblem('1');

      // Agora deve pular pro próximo ativo não confirmado (4)
      next = notifier.nextUnconfirmedProblem;
      expect(next?.id, '4');
    });
  });

  group('FilterState', () {
    test('empty filter matches everything', () {
      const filter = FilterState();
      expect(filter.isEmpty, true);
    });

    test('filters by status', () {
      final filter = FilterState(
        statuses: {ProblemStatus.active},
      );
      expect(filter.activeCount, 1);
    });
  });

  group('filteredProblemsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('returns all problems when no filter', () {
      final filtered = container.read(filteredProblemsProvider);
      expect(filtered.length, 5);
    });

    test('filters by status active', () {
      container
          .read(filterProvider.notifier)
          .toggleStatus(ProblemStatus.active);
      final filtered = container.read(filteredProblemsProvider);
      // mock has 3 active problems (ids 1, 4, 5)
      expect(filtered.every((p) => p.status == ProblemStatus.active), true);
      expect(filtered.length, 3);
    });

    test('filters by type', () {
      container
          .read(filterProvider.notifier)
          .toggleType(ProblemType.hole);
      final filtered = container.read(filteredProblemsProvider);
      expect(filtered.every((p) => p.type == ProblemType.hole), true);
      expect(filtered.length, 2);
    });
  });
}
