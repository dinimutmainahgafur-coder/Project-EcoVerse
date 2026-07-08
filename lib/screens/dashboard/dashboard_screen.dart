import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/mission_provider.dart';
import '../../widgets/bottom_navbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MissionProvider>().fetchMissions();
    });
  }

  void _onTabChanged(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/journal');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/mission');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/leaderboard');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final missionProvider = context.watch<MissionProvider>();
    final missions = missionProvider.missions.where((m) => !m.isCompleted).take(2).toList();

    return Scaffold(
      backgroundColor: EcoColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => missionProvider.refreshMissions(),
          color: EcoColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildHeader(user?.name ?? 'User'),
                const SizedBox(height: 16),
                _buildEcoScoreCard(user),
                const SizedBox(height: 20),
                _buildDailyMissionSection(missions, missionProvider),
                const SizedBox(height: 20),
                _buildShortcutMenu(),
                const SizedBox(height: 20),
                _buildWeeklyProgress(missionProvider),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: EcoBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: EcoColors.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Halo, $name',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: EcoColors.text,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: EcoColors.card,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: EcoColors.text,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildEcoScoreCard(dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: EcoColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eco Score',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield_rounded, size: 14, color: EcoColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      'Eco Warrior',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user?.ecoPoint ?? 0}',
                style: GoogleFonts.poppins(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Eco Points',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${user?.level ?? 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '${user?.xp ?? 0} / ${user?.maxXp ?? 100} XP',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: user?.xpProgress ?? 0.0,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(EcoColors.gold),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMissionSection(List missions, MissionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Mission',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: EcoColors.text,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/mission').then((_) => provider.refreshMissions()),
              child: Text(
                'Lihat semua',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: EcoColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: EcoColors.primary),
            ),
          )
        else if (missions.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: EcoColors.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Semua misi sudah selesai hari ini! 🎉',
                style: GoogleFonts.poppins(fontSize: 13, color: EcoColors.subtitle),
              ),
            ),
          )
        else
          ...missions.map((m) => _buildMissionCard(m)),
      ],
    );
  }

  Widget _buildMissionCard(dynamic mission) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/mission_detail', arguments: mission)
            .then((_) => context.read<MissionProvider>().refreshMissions());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: EcoColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: mission.image ?? '',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 64,
                  height: 64,
                  color: EcoColors.greyLight,
                  child: const Icon(Icons.eco_rounded, color: EcoColors.accent, size: 28),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: EcoColors.greyLight,
                  child: const Icon(Icons.eco_rounded, color: EcoColors.accent, size: 28),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title ?? 'Misi',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: EcoColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.description ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: EcoColors.subtitle,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: EcoColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '+${mission.point ?? 0} Poin',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: EcoColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mission_detail', arguments: mission)
                    .then((_) => context.read<MissionProvider>().refreshMissions());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: EcoColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Mulai',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: EcoColors.text,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildShortcutItem(
                icon: Icons.eco_rounded,
                label: 'Misi',
                color: EcoColors.primary,
                onTap: () => Navigator.pushNamed(context, '/mission').then((_) => context.read<MissionProvider>().refreshMissions()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildShortcutItem(
                icon: Icons.book_rounded,
                label: 'Jurnal',
                color: const Color(0xFF29B6F6),
                onTap: () => Navigator.pushNamed(context, '/journal'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildShortcutItem(
                icon: Icons.emoji_events_rounded,
                label: 'Tantangan',
                color: EcoColors.gold,
                onTap: () => Navigator.pushNamed(context, '/challenge'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildShortcutItem(
                icon: Icons.school_rounded,
                label: 'Akademi',
                color: const Color(0xFF66BB6A),
                onTap: () => Navigator.pushNamed(context, '/academy'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShortcutItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: EcoColors.card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: EcoColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress(MissionProvider missionProvider) {
    final int currentDayIndex = DateTime.now().weekday;
    final daysLabels = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Mingguan',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: EcoColors.text,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: EcoColors.card,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              bool isDayActive = (index + 1) <= currentDayIndex;
              return _buildDayItem(daysLabels[index], isDayActive);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDayItem(String label, bool active) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? EcoColors.primary : EcoColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: active
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: EcoColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}