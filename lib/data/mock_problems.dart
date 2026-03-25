import '../models/problem_report.dart';

/// Dados mock para visualização das interfaces
/// Estes dados serão substituídos pela API real no futuro
final List<ProblemReport> mockProblems = [
  ProblemReport(
    id: '1',
    type: ProblemType.hole,
    status: ProblemStatus.active,
    severity: Severity.high,
    title: 'Buraco na Av. Nove de Julho',
    description:
        'Buraco grande na pista da direita, próximo ao cruzamento com a Rua Alfredo Guedes. '
        'Representa risco para veículos e pedestres. Já causou danos a pelo menos 3 carros.',
    address: 'Av. Nove de Julho, 1245',
    neighborhood: 'Centro',
    reportedBy: 'Maria Silva',
    reportedAt: DateTime(2026, 3, 5, 14, 30),
    confirmations: 23,
    relativeX: 0.35,
    relativeY: 0.42,
    latitude: -23.3020,
    longitude: -45.9670,
  ),
  ProblemReport(
    id: '2',
    type: ProblemType.signage,
    status: ProblemStatus.analysis,
    severity: Severity.medium,
    title: 'Problema na Sinalização',
    description:
        'Placa de "Pare" danificada no cruzamento da R. Barão de Jacarehy com a R. São João. '
        'A placa está torta e quase ilegível, dificultando a orientação dos motoristas.',
    address: 'R. Barão de Jacarehy, 480',
    neighborhood: 'Centro Histórico',
    reportedBy: 'Carlos Oliveira',
    reportedAt: DateTime(2026, 3, 7, 9, 15),
    confirmations: 8,
    relativeX: 0.62,
    relativeY: 0.28,
    latitude: -23.3055,
    longitude: -45.9620,
  ),
  ProblemReport(
    id: '3',
    type: ProblemType.crack,
    status: ProblemStatus.resolved,
    severity: Severity.low,
    title: 'Calçada Quebrada',
    description:
        'Calçada com rachadura extensa em frente ao número 312. '
        'Risco de tropeço para pedestres, especialmente idosos.',
    address: 'R. Cel. Carlos Porto, 312',
    neighborhood: 'Jardim Paraíba',
    reportedBy: 'Ana Pereira',
    reportedAt: DateTime(2026, 2, 20, 16, 45),
    confirmations: 15,
    relativeX: 0.78,
    relativeY: 0.65,
    latitude: -23.3090,
    longitude: -45.9560,
  ),
  ProblemReport(
    id: '4',
    type: ProblemType.unevenness,
    status: ProblemStatus.active,
    severity: Severity.medium,
    title: 'Desnível na Via',
    description:
        'Desnível acentuado na saída da rotatória da Av. Getúlio Vargas. '
        'Motociclistas e ciclistas estão em risco. O desnível tem aproximadamente 10 cm.',
    address: 'Av. Getúlio Vargas, s/n',
    neighborhood: 'Vila Industrial',
    reportedBy: 'Roberto Santos',
    reportedAt: DateTime(2026, 3, 9, 11, 0),
    confirmations: 5,
    relativeX: 0.20,
    relativeY: 0.75,
    latitude: -23.3110,
    longitude: -45.9720,
  ),
  ProblemReport(
    id: '5',
    type: ProblemType.hole,
    status: ProblemStatus.active,
    severity: Severity.high,
    title: 'Cratera na R. Prudente de Moraes',
    description:
        'Buraco enorme que ocupa quase meia faixa. Surgiu após as chuvas fortes da semana passada. '
        'Água acumulando dentro, impossível ver a profundidade.',
    address: 'R. Prudente de Moraes, 890',
    neighborhood: 'Centro',
    reportedBy: 'Fernanda Lima',
    reportedAt: DateTime(2026, 3, 8, 8, 20),
    confirmations: 31,
    relativeX: 0.50,
    relativeY: 0.52,
    latitude: -23.3045,
    longitude: -45.9650,
  ),
];
