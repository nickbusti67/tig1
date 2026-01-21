import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/theme.dart';
import '../models/models.dart';
import '../services/ritual_service.dart';
import '../widgets/glowing_sigil.dart';
import '../widgets/ritual_card.dart';
import '../utils/responsive_layout.dart';
import 'ritual_flow_screen.dart';
import 'codex_screen.dart';

class RitualDashboardScreen extends StatefulWidget {
  const RitualDashboardScreen({super.key});

  @override
  State<RitualDashboardScreen> createState() => _RitualDashboardScreenState();
}

class _RitualDashboardScreenState extends State<RitualDashboardScreen>
    with SingleTickerProviderStateMixin {
  final RitualService _ritualService = RitualService();
  late User _currentUser;
  late User _partner;
  DailyRitual? _currentRitual;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _currentUser = _ritualService.getCurrentUser();
    _partner = _ritualService.getPartner();
    _currentRitual = _ritualService.getCurrentRitual();
  }

  void _navigateToRitualFlow() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RitualFlowScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buongiorno';
    if (hour < 18) return 'Buon pomeriggio';
    return 'Buonasera';
  }

  String _getDateString() {
    final now = DateTime.now();
    final weekdays = [
      'Lunedì',
      'Martedì',
      'Mercoledì',
      'Giovedì',
      'Venerdì',
      'Sabato',
      'Domenica'
    ];
    final months = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre'
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
          ),

          // Subtle particles
          const Positioned.fill(
            child: FloatingParticles(
              particleCount: 15,
              color: AppTheme.goldPrimary,
              maxSize: 2,
            ),
          ),

          // Main content based on navigation
          SafeArea(
            child: IndexedStack(
              index: _selectedNavIndex,
              children: [
                _buildDashboardContent(),
                const CodexScreen(),
                _buildSettingsPlaceholder(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDashboardContent() {
    final isMobile = ResponsiveLayout.isMobileLayout(context);
    final spacing = ResponsiveLayout.getSpacing(context);

    return SingleChildScrollView(
      padding: ResponsiveLayout.getPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getMaxContentWidth(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),

              SizedBox(height: spacing * 1.5),

              // Partner status cards
              _buildPartnerSection()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms),

              SizedBox(height: spacing * 1.5),

              // Today's ritual card
              _buildTodayRitualCard()
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

              SizedBox(height: spacing * 1.5),

              // Ritual phases
              _buildPhasesSection()
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms),

              SizedBox(height: spacing * 1.5),

              // Statistics
              _buildStatisticsSection()
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 600.ms),

              SizedBox(height: isMobile ? 80 : 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _currentUser.roleEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentUser.displayName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.goldLight,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.primaryMedium.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '7 giorni',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _getDateString(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textMuted,
                letterSpacing: 1,
              ),
        ),
      ],
    );
  }

  Widget _buildPartnerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.favorite,
              color: AppTheme.roseDeep,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'I Custodi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.goldLight,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PartnerStatusCard(
                  user: _currentUser,
                  isOnline: true,
                  hasAnswered: false,
                  statusText: 'Tu',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PartnerStatusCard(
                  user: _partner,
                  isOnline: true,
                  hasAnswered: false,
                  statusText: 'In attesa...',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodayRitualCard() {
    final isWeekend = _currentRitual?.isWeekendExtended ?? false;

    return GestureDetector(
      onTap: _navigateToRitualFlow,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryDeep,
              AppTheme.primaryMedium.withValues(alpha: 0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: AppTheme.goldPrimary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: AppTheme.glowShadow,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isWeekend)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: AppTheme.goldPrimary,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Rito Lungo Fig-End',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.goldPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        'Il Rituale di Oggi',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.goldLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Il Velo attende di essere sollevato...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
                const GlowingSigil(
                  size: 80,
                  animate: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const MysticalDivider(width: double.infinity),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldShimmer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'INIZIA IL RITUALE',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppTheme.primaryDark,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhasesSection() {
    final currentPhase = _currentRitual?.currentPhase ?? RitualPhase.ilVelo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.timeline,
              color: AppTheme.goldPrimary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Le Fasi del Rituale',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.goldLight,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...RitualPhase.values
            .where((p) => p != RitualPhase.completed)
            .map((phase) {
          final isActive = phase == currentPhase;
          final isCompleted = phase.index < currentPhase.index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RitualPhaseCard(
              phase: phase,
              isActive: isActive,
              isCompleted: isCompleted,
              onTap: isActive ? _navigateToRitualFlow : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    final stats = _ritualService.getStatistics();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.insights,
              color: AppTheme.goldPrimary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Il Vostro Viaggio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.goldLight,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatisticTile(
                  label: 'Rituali\ncompletati',
                  value: '${stats['totalRituals']}',
                  icon: Icons.auto_awesome,
                  color: AppTheme.goldPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticTile(
                  label: 'Media\ncompatibilità',
                  value: '${stats['averageCompatibility']}%',
                  icon: Icons.favorite,
                  color: AppTheme.roseDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticTile(
                  label: 'Pagine\nCodex',
                  value: '${stats['totalCodexPages']}',
                  icon: Icons.menu_book,
                  color: AppTheme.teal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.goldPrimary.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: AppTheme.goldLight,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Impostazioni',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.goldLight,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Prossimamente...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Qui potrai gestire la modalità intimità,\nFig-End e le notifiche.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryMedium.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Rituale'),
              _buildNavItem(1, Icons.menu_book_outlined, Icons.menu_book, 'Codex'),
              _buildNavItem(
                  2, Icons.settings_outlined, Icons.settings, 'Impostazioni'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.goldPrimary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppTheme.goldPrimary : AppTheme.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.goldPrimary : AppTheme.textMuted,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
