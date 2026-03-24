import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/problem_report.dart';
import '../../widgets/floating_search_bar.dart';
import 'widgets/map_view.dart';
import 'widgets/problem_detail_sheet.dart';
import 'widgets/report_problem_sheet.dart';
import 'widgets/quick_confirm_card.dart';
import '../../data/mock_problems.dart';
import '../../core/constants/app_strings.dart';
import '../search/search_screen.dart';
import '../profile/profile_screen.dart';

/// Tela principal — Mapa com overlays estilo Waze
/// Stack fullscreen: mapa + barra de pesquisa + FABs
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  String? _selectedProblemId;
  bool _showQuickConfirm = true;

  // Animação de entrada do QuickConfirmCard
  late final AnimationController _quickConfirmAnimController;
  late final Animation<Offset> _quickConfirmSlide;
  late final Animation<double> _quickConfirmFade;

  // Animation controller para o FAB
  late final AnimationController _fabAnimController;
  late final Animation<double> _fabScaleAnim;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScaleAnim = CurvedAnimation(
      parent: _fabAnimController,
      curve: Curves.elasticOut,
    );

    // Animação de entrada do QuickConfirmCard
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

    // Dispara animação de entrada dos FABs
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fabAnimController.forward();
    });
    // Dispara animação de entrada do QuickConfirmCard
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _quickConfirmAnimController.forward();
    });
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    _quickConfirmAnimController.dispose();
    super.dispose();
  }

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
      builder: (_) => ProblemDetailSheet(problem: problem),
    ).whenComplete(() {
      setState(() {
        _selectedProblemId = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Status bar transparente para fullscreen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // ── Camada 1: Mapa ─────────────────────────────────
          MapView(
            selectedProblemId: _selectedProblemId,
            onMarkerTap: _onMarkerTap,
          ),

          // ── Camada 2: Barra de pesquisa flutuante ──────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: FloatingSearchBar(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SearchScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 250),
                  ),
                );
              },
              onAvatarTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              onFilterTap: () {
                // TODO: Implementar filtros
              },
            ),
          ),

          // ── Camada 3: FABs (canto inferior direito) ────────
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
                    onPressed: () {
                      // TODO: Centralizar mapa na localização
                    },
                    heroTag: 'location_fab',
                  ),
                  const SizedBox(height: 12),
                  // FAB de reportar problema
                  _buildMainFab(
                    icon: Icons.add_rounded,
                    tooltip: 'Reportar problema',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        transitionAnimationController: AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 400),
                        ),
                        builder: (_) => const ReportProblemSheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Camada 4: Legenda ou QuickConfirmCard ──────────
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: _showQuickConfirm
                ? SlideTransition(
                    position: _quickConfirmSlide,
                    child: FadeTransition(
                      opacity: _quickConfirmFade,
                      child: QuickConfirmCard(
                        problem: mockProblems[2],
                        onYes: () {
                          setState(() => _showQuickConfirm = false);
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
                          setState(() => _showQuickConfirm = false);
                        },
                        onDismiss: () {
                          setState(() => _showQuickConfirm = false);
                        },
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: _buildLegend(),
                  ),
          ),
        ],
      ),
    );
  }

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
