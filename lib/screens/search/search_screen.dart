import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';

/// Tela de Pesquisa — Sprint 5
/// Busca com autofocus, histórico recente e sugestões de endereços
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  // ── Dados mock de buscas recentes ──────────────────────────────────────────
  final List<String> _recentSearches = [
    'Rua Alfredo Bueno, 155',
    'Praça dos Três Poderes',
    'Av. Major Acácio',
    'Buraco na Rua 7 de Setembro',
  ];

  // ── Dados mock de sugestões ────────────────────────────────────────────────
  final List<_SuggestionItem> _suggestions = [
    _SuggestionItem(
      address: 'Rua Alfredo Bueno, 250',
      neighborhood: 'Centro, Jacareí - SP',
    ),
    _SuggestionItem(
      address: 'Av. Presidente Vargas, 1200',
      neighborhood: 'Jardim Paraíso, Jacareí - SP',
    ),
    _SuggestionItem(
      address: 'Rua Barão de Jacareí, 48',
      neighborhood: 'Vila Maria, Jacareí - SP',
    ),
    _SuggestionItem(
      address: 'Praça Conselheiro Rodrigues Alves',
      neighborhood: 'Centro, Jacareí - SP',
    ),
    _SuggestionItem(
      address: 'Rua São João, 310',
      neighborhood: 'Jardim das Flores, Jacareí - SP',
    ),
  ];

  // Resultados filtrados com base no texto digitado
  List<String> _filteredRecent = [];
  List<_SuggestionItem> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();

    _filteredRecent = List.from(_recentSearches);
    _filteredSuggestions = List.from(_suggestions);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredRecent = List.from(_recentSearches);
        _filteredSuggestions = List.from(_suggestions);
      } else {
        _filteredRecent = _recentSearches
            .where((s) => s.toLowerCase().contains(query))
            .toList();
        _filteredSuggestions = _suggestions
            .where((s) =>
                s.address.toLowerCase().contains(query) ||
                s.neighborhood.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── Barra de pesquisa ativa ──────────────────────────────────
            _buildSearchHeader(topPadding),

            // ── Conteúdo: buscas recentes + sugestões ───────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Buscas Recentes
                  if (_filteredRecent.isNotEmpty) ...[
                    _buildSectionTitle(AppStrings.recentSearches),
                    ..._filteredRecent.map(_buildRecentItem),
                    const SizedBox(height: 8),
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.divider,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Sugestões
                  if (_filteredSuggestions.isNotEmpty) ...[
                    _buildSectionTitle(AppStrings.suggestions),
                    ..._filteredSuggestions.map(_buildSuggestionItem),
                  ],

                  // Sem resultados
                  if (_filteredRecent.isEmpty &&
                      _filteredSuggestions.isEmpty &&
                      _searchController.text.isNotEmpty)
                    _buildEmptyState(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Barra de pesquisa no topo ──────────────────────────────────────────────

  Widget _buildSearchHeader(double topPadding) {
    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 8,
        left: 8,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botão voltar
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            splashRadius: 22,
          ),

          // Campo de texto
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                autofocus: true,
                style: AppTextStyles.bodyMedium,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  hintStyle: AppTextStyles.searchHint,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          splashRadius: 16,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Título de seção ────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Item de busca recente ──────────────────────────────────────────────────

  Widget _buildRecentItem(String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navegar de volta para o mapa com localização selecionada
          _searchController.text = text;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.north_west_rounded,
                color: AppColors.textHint,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Item de sugestão ───────────────────────────────────────────────────────

  Widget _buildSuggestionItem(_SuggestionItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navegar de volta para o mapa com localização selecionada
          _searchController.text = item.address;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.address,
                      style: AppTextStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.neighborhood,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.north_west_rounded,
                color: AppColors.textHint,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Estado vazio (sem resultados) ──────────────────────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum resultado encontrado',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar por um endereço ou tipo de problema',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Modelo auxiliar para sugestões ────────────────────────────────────────────

class _SuggestionItem {
  final String address;
  final String neighborhood;

  const _SuggestionItem({
    required this.address,
    required this.neighborhood,
  });
}
