import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/problem_report.dart';
import '../../providers/problems_provider.dart';
import '../../widgets/floating_search_bar.dart';
import '../../widgets/location_pin.dart';
import 'widgets/map_view.dart';
import 'widgets/problem_detail_sheet.dart';
import 'widgets/report_problem_sheet.dart';
import 'widgets/quick_confirm_card.dart';
import 'widgets/location_picker_card.dart';
import 'widgets/filter_sheet.dart';
import '../../data/mock_addresses.dart';
import '../../core/constants/app_strings.dart';

/// Tela principal — Mapa real com overlays estilo Waze
class HomeScreen extends ConsumerStatefulWidget {
  /// ID do problema para abrir direto (deep link)
  final String? initialProblemId;

  const HomeScreen({super.key, this.initialProblemId});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  String? _selectedProblemId;

  // ── MapController do flutter_map ───────────────────────────
  final MapController _mapController = MapController();

  // ── Location Picker state ──────────────────────────────────
  bool _isSelectingLocation = false;
  bool _isMapDragging = false;
  String _selectedAddress = 'R. Barão de Jacarehy, 200 — Centro';

  // Animation controllers
  late final AnimationController _fabAnimController;
  late final Animation<double> _fabScaleAnim;

  late final AnimationController _quickConfirmAnimController;
  late final Animation<Offset> _quickConfirmSlide;
  late final Animation<double> _quickConfirmFade;

  // Animação de entrada/saída do location picker
  late final AnimationController _pickerAnimController;
  late final Animation<Offset> _pickerSlideAnim;
  late final Animation<double> _pickerFadeAnim;
  late final Animation<double> _pinScaleAnim;

    Future<void> testRead() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .get();

    for (var doc in snapshot.docs) {
      print(doc.data());
    }
  }

  Future<void> testWrite() async {
  await FirebaseFirestore.instance.collection('reports').add({
    'type': 'Teste Flutter',
    'status': 'active',
    'confirmationsCount': 0,
    'createdBy': 'flutter_user',
    'createdAt': FieldValue.serverTimestamp(),
    'location': GeoPoint(-23.30, -45.96),
  });
  }

  @override
  void initState() {
    super.initState();
    testRead();
    testWrite();

    // FAB animation
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScaleAnim = CurvedAnimation(
      parent: _fabAnimController,
      curve: Curves.elasticOut,
    );

    // QuickConfirm animation
    _quickConfirmAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _quickConfirmSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _quickConfirmAnimController,
      curve: Curves.easeOutCubic,
    ));
    _quickConfirmFade = CurvedAnimation(
      parent: _quickConfirmAnimController,
      curve: Curves.easeOut,
    );

    // Location picker animation
    _pickerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pickerSlideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pickerAnimController,
      curve: Curves.easeOutCubic,
    ));
    _pickerFadeAnim = CurvedAnimation(
      parent: _pickerAnimController,
      curve: Curves.easeOut,
    );
    _pinScaleAnim = CurvedAnimation(
      parent: _pickerAnimController,
      curve: Curves.elasticOut,
    );

    // Trigger entrance animations
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fabAnimController.forward();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _quickConfirmAnimController.forward();
    });

    // Deep link: abrir problema existente
    if (widget.initialProblemId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final problems = ref.read(problemsProvider);
        try {
          final problem = problems.firstWhere(
            (p) => p.id == widget.initialProblemId,
          );
          _onMarkerTap(problem);
        } catch (_) {
          // Problema não encontrado — ignora
        }
      });
    }
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    _quickConfirmAnimController.dispose();
    _pickerAnimController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ── Interações ─────────────────────────────────────────────

  void _onMarkerTap(ProblemReport problem) {
    setState(() {
      _selectedProblemId = problem.id;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
      builder: (sheetContext) => ProblemDetailSheet(problem: problem),
    ).whenComplete(() {
      setState(() {
        _selectedProblemId = null;
      });
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
      builder: (sheetContext) => const FilterSheet(),
    );
  }

  void _enterLocationPicker() {
    setState(() {
      _isSelectingLocation = true;
      _selectedAddress = 'R. Barão de Jacarehy, 200 — Centro';
    });
    _pickerAnimController.forward();
  }

  void _exitLocationPicker() {
    _pickerAnimController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isSelectingLocation = false;
          _isMapDragging = false;
        });
      }
    });
  }

  void _confirmLocation() {
    _pickerAnimController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isSelectingLocation = false;
          _isMapDragging = false;
        });
        // Abre o formulário com o endereço selecionado
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          transitionAnimationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 400),
          ),
          builder: (_) => ReportProblemSheet(
            initialAddress: _selectedAddress,
          ),
        );
      }
    });
  }

  /// Calcula um endereço mock baseado na posição central do mapa
  void _updateAddressFromMapCenter() {
    final center = _mapController.camera.center;

    const latMin = -23.32;
    const latMax = -23.29;
    const lngMin = -45.98;
    const lngMax = -45.95;

    final relX =
        ((center.longitude - lngMin) / (lngMax - lngMin)).clamp(0.0, 0.999);
    final relY =
        ((center.latitude - latMin) / (latMax - latMin)).clamp(0.0, 0.999);

    setState(() {
      _selectedAddress = getAddressForPosition(relX, relY);
      _isMapDragging = false;
    });
  }

  /// Ouve eventos do mapa para controlar o estado do picker
  void _onMapEvent(MapEvent event) {
    if (!_isSelectingLocation) return;

    if (event is MapEventMoveStart) {
      if (!_isMapDragging) {
        setState(() => _isMapDragging = true);
      }
    } else if (event is MapEventMoveEnd) {
      _updateAddressFromMapCenter();
    }
  }

  void _centerOnJacarei() {
    _mapController.move(kJacareiCenter, kDefaultZoom);
  }

  /// Move o mapa para coordenadas específicas (usado pelo retorno da busca)
  void _moveToCoordinates(double lat, double lng) {
    _mapController.move(
      latlong2.LatLng(lat, lng),
      16.5, // zoom mais próximo para ver o local
    );
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final filteredProblems = ref.watch(filteredProblemsProvider);
    final filter = ref.watch(filterProvider);
    final problemsNotifier = ref.read(problemsProvider.notifier);
    final nextUnconfirmed = problemsNotifier.nextUnconfirmedProblem;

    return Scaffold(
      body: Stack(
        children: [
          // ── Camada 1: Mapa real ─────────────────────────────
          MapView(
            problems: filteredProblems,
            selectedProblemId: _selectedProblemId,
            onMarkerTap: _onMarkerTap,
            isSelectionMode: _isSelectingLocation,
            mapController: _mapController,
            onMapEvent: _onMapEvent,
          ),

          // ── Camada 2: Barra de pesquisa (oculta no picker) ─
          if (!_isSelectingLocation)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              child: FloatingSearchBar(
                filterCount: filter.activeCount,
                onTap: () async {
                  final result = await context.push<Map<String, dynamic>>(
                    '/search',
                  );
                  // Se voltou com coordenadas, move o mapa
                  if (result != null && mounted) {
                    _moveToCoordinates(
                      result['latitude'] as double,
                      result['longitude'] as double,
                    );
                  }
                },
                onAvatarTap: () {
                  context.push('/profile');
                },
                onFilterTap: _openFilterSheet,
              ),
            ),

          // ── Camada 2b: Botão voltar (visível no picker) ────
          if (_isSelectingLocation)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: FadeTransition(
                opacity: _pickerFadeAnim,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _exitLocationPicker,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

          // ── Camada 3: Pin Central (visível no picker) ──────
          if (_isSelectingLocation)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: ScaleTransition(
                  scale: _pinScaleAnim,
                  child: LocationPin(isDragging: _isMapDragging),
                ),
              ),
            ),

          // ── Camada 4: FABs (ocultos no picker) ─────────────
          if (!_isSelectingLocation)
            Positioned(
              bottom: 24,
              right: 16,
              child: ScaleTransition(
                scale: _fabScaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // FAB de localização
                    _buildSmallFab(
                      icon: Icons.my_location_rounded,
                      tooltip: 'Minha localização',
                      onPressed: _centerOnJacarei,
                      heroTag: 'location_fab',
                    ),
                    const SizedBox(height: 12),
                    // FAB de reportar problema → abre location picker
                    _buildMainFab(
                      icon: Icons.add_rounded,
                      tooltip: 'Reportar problema',
                      onPressed: _enterLocationPicker,
                    ),
                  ],
                ),
              ),
            ),

          // ── Camada 5: QuickConfirmCard (oculto no picker) ──
          if (!_isSelectingLocation)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: nextUnconfirmed != null
                  ? SlideTransition(
                      position: _quickConfirmSlide,
                      child: FadeTransition(
                        opacity: _quickConfirmFade,
                        child: QuickConfirmCard(
                          problem: nextUnconfirmed,
                          onYes: () {
                            ref
                                .read(problemsProvider.notifier)
                                .confirmProblem(nextUnconfirmed.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text(AppStrings.confirmationRecorded),
                                  ],
                                ),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          },
                          onNo: () {
                            ref
                                .read(problemsProvider.notifier)
                                .denyProblem(nextUnconfirmed.id);
                          },
                          onDismiss: () {
                            ref
                                .read(problemsProvider.notifier)
                                .denyProblem(nextUnconfirmed.id);
                          },
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomLeft,
                      child: _buildLegend(),
                    ),
            ),

          // ── Camada 6: LocationPickerCard (visível no picker)─
          if (_isSelectingLocation)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _pickerSlideAnim,
                child: FadeTransition(
                  opacity: _pickerFadeAnim,
                  child: LocationPickerCard(
                    currentAddress: _selectedAddress,
                    isDragging: _isMapDragging,
                    onConfirm: _confirmLocation,
                    onSearchTap: () async {
                      final result =
                          await context.push<Map<String, dynamic>>(
                        '/search',
                      );
                      if (result != null && mounted) {
                        _moveToCoordinates(
                          result['latitude'] as double,
                          result['longitude'] as double,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Widgets auxiliares ──────────────────────────────────────

  Widget _buildMainFab({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: 'main_fab',
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: AppColors.primary,
        elevation: 0,
        child: Icon(icon, size: 28),
      ),
    );
  }

  Widget _buildSmallFab({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: FloatingActionButton.small(
        heroTag: heroTag,
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: AppColors.surfaceCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        child: Icon(icon, size: 22),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendItem(AppColors.statusActive, 'Ativo'),
          const SizedBox(height: 4),
          _legendItem(AppColors.statusAnalysis, 'Em análise'),
          const SizedBox(height: 4),
          _legendItem(AppColors.statusResolved, 'Resolvido'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
