/// Strings centralizadas do app Reconstrói Jacareí (PT-BR)
class AppStrings {
  AppStrings._();

  // ── Geral ──────────────────────────────────────────────────────────────────
  static const String appName = 'Reconstrói Jacareí';
  static const String appVersion = 'Versão 1.0.0';
  static const String appSubtitle = 'Relatório de Problemas';

  // ── Home / Mapa ────────────────────────────────────────────────────────────
  static const String searchHint = 'Buscar endereço ou problema...';
  static const String filterAll = 'Todos';
  static const String filterActive = 'Ativos';
  static const String filterAnalysis = 'Em Análise';
  static const String filterResolved = 'Resolvidos';

  // ── Status ─────────────────────────────────────────────────────────────────
  static const String statusActive = 'Ativo';
  static const String statusAnalysis = 'Em Análise';
  static const String statusResolved = 'Resolvido';

  // ── Problema — detalhe ─────────────────────────────────────────────────────
  static const String location = 'Localização';
  static const String date = 'Data';
  static const String reportedBy = 'Reportado por';
  static const String severity = 'Nível de Gravidade';
  static const String description = 'Descrição';
  static const String confirmations = 'pessoas confirmaram este problema';
  static const String markResolved = 'Marcar como Resolvido';

  // ── Problema — reportar ────────────────────────────────────────────────────
  static const String reportTitle = 'Reportar Problema';
  static const String detectedAddress = 'Endereço detectado';
  static const String problemType = 'Tipo de problema';
  static const String confirm = 'Confirmar';
  static const String cancel = 'Cancelar';

  // ── Tipos de problema ──────────────────────────────────────────────────────
  static const String typeHole = 'Buraco';
  static const String typeCrack = 'Rachadura';
  static const String typeUnevenness = 'Desnível';
  static const String typeSignage = 'Sinalização';
  static const String typeOther = 'Outro';

  // ── Gravidade ──────────────────────────────────────────────────────────────
  static const String severityLow = 'Baixa';
  static const String severityMedium = 'Média';
  static const String severityHigh = 'Alta';

  // ── Confirmação rápida ─────────────────────────────────────────────────────
  static const String quickConfirmQuestion = 'continua com problema?';
  static const String yes = 'Sim';
  static const String no = 'Não';

  // ── Pesquisa ───────────────────────────────────────────────────────────────
  static const String recentSearches = 'Buscas Recentes';
  static const String suggestions = 'Sugestões';

  // ── Perfil ─────────────────────────────────────────────────────────────────
  static const String profile = 'Perfil';
  static const String activeContributor = 'Contribuidor Ativo';
  static const String settings = 'Configurações';
  static const String logout = 'Sair';

  // ── Feedback ───────────────────────────────────────────────────────────────
  static const String reportSent = 'Problema reportado com sucesso!';
  static const String markedResolved = 'Problema marcado como resolvido.';
  static const String confirmationRecorded = 'Confirmação registrada!';
}
