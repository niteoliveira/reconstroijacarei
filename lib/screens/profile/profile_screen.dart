import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';

/// Tela de Perfil — Sprint 6
/// Avatar, nome, email, badge de contribuidor, configurações e sair
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ── Dados mock do usuário ──────────────────────────────────────────────────
  static const String _userName = 'Leonardo Oliveira';
  static const String _userEmail = 'leonardo@email.com';
  static const int _reportsCount = 12;
  static const int _confirmationsCount = 34;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          AppStrings.profile,
          style: AppTextStyles.heading3,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            // ── Card do usuário ──────────────────────────────────────
            _buildUserCard(),

            const SizedBox(height: 16),

            // ── Banner contribuidor ativo ────────────────────────────
            _buildContributorBanner(),

            const SizedBox(height: 16),

            // ── Estatísticas ─────────────────────────────────────────
            _buildStatsRow(),

            const SizedBox(height: 24),

            // ── Menu de opções ───────────────────────────────────────
            _buildMenuSection(context),

            const SizedBox(height: 32),

            // ── Rodapé ───────────────────────────────────────────────
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ── Card principal do usuário ──────────────────────────────────────────────

  Widget _buildUserCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.onPrimary,
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          // Nome
          Text(
            _userName,
            style: AppTextStyles.heading2,
          ),

          const SizedBox(height: 4),

          // Email
          Text(
            _userEmail,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Banner "Contribuidor Ativo" ────────────────────────────────────────────

  Widget _buildContributorBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.activeContributor,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Obrigado por ajudar Jacareí!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Estatísticas ───────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.flag_rounded,
              value: '$_reportsCount',
              label: 'Reportes',
              color: AppColors.statusActive,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.check_circle_rounded,
              value: '$_confirmationsCount',
              label: 'Confirmações',
              color: AppColors.statusResolved,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  // ── Menu de opções ─────────────────────────────────────────────────────────

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.settings_rounded,
            label: AppStrings.settings,
            onTap: () {
              // TODO: navegar para configurações
            },
          ),
          const Divider(height: 1, indent: 56, color: AppColors.divider),
          _buildMenuItem(
            icon: Icons.help_outline_rounded,
            label: 'Ajuda',
            onTap: () {
              // TODO: navegar para ajuda
            },
          ),
          const Divider(height: 1, indent: 56, color: AppColors.divider),
          _buildMenuItem(
            icon: Icons.logout_rounded,
            label: AppStrings.logout,
            color: AppColors.error,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: itemColor, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyLarge.copyWith(color: itemColor),
                ),
              ),
              if (color == null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Diálogo de logout ──────────────────────────────────────────────────────

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sair do app', style: AppTextStyles.heading3),
        content: Text(
          'Tem certeza que deseja sair?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppStrings.cancel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: implementar logout real
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout simulado')),
              );
            },
            child: Text(
              AppStrings.logout,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Rodapé ─────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Text(
      '${AppStrings.appVersion} • ${AppStrings.appSubtitle}',
      style: AppTextStyles.caption,
      textAlign: TextAlign.center,
    );
  }
}
