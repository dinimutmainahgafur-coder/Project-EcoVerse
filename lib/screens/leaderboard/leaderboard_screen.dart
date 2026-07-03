import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../providers/leaderboard_provider.dart';
import '../../widgets/bottom_navbar.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaderboardProvider>();
    final data = provider.leaderboardData;

    return Scaffold(
      backgroundColor: EcoColors.background,
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: EcoColors.text),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: EcoColors.text),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFilterChips(provider),
            const SizedBox(height: 24),
            _buildPodium(data),
            const SizedBox(height: 20),
            ...data.skip(3).map((d) => _buildRankItem(d, false)),
          ],
        ),
      ),
      bottomNavigationBar: EcoBottomNavbar(
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (i == 1) Navigator.pushNamed(context, '/journal');
          if (i == 2) Navigator.pushNamed(context, '/mission');
          if (i == 4) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  Widget _buildFilterChips(LeaderboardProvider provider) {
    final filters = ['Mingguan', 'Bulanan', 'Semua Mata'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: EcoColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: filters.map((f) {
          final selected = provider.selectedFilter == f ||
              (f == 'Semua Mata' && provider.selectedFilter == 'Semua');
          return Expanded(
            child: GestureDetector(
              onTap: () => provider.filterLeaderboard(f == 'Semua Mata' ? 'Semua' : f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? EcoColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  f,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : EcoColors.subtitle,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPodium(List<Map<String, dynamic>> data) {
    if (data.length < 3) return const SizedBox();

    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumItem(data[1], 2, 100),
          _buildPodiumItem(data[0], 1, 130),
          _buildPodiumItem(data[2], 3, 80),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(Map<String, dynamic> data, int rank, double barHeight) {
    final colors = {
      1: const Color(0xFFFFD54F),
      2: const Color(0xFFB0BEC5),
      3: const Color(0xFFA1887F),
    };

    return Container(
      width: 95,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (rank == 1)
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD54F),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.emoji_events_rounded, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors[rank]!.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: colors[rank]!, width: 2),
            ),
            child: Center(
              child: Text(
                data['name'].toString()[0],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors[rank],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data['name'].toString().split(' ').first,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: EcoColors.text,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '${data['point']} Poin',
            style: GoogleFonts.poppins(fontSize: 11, color: EcoColors.subtitle),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: barHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors[rank]!, colors[rank]!.withValues(alpha: 0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankItem(Map<String, dynamic> data, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${data['rank']}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: EcoColors.text,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: EcoColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                data['name'].toString()[0],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: EcoColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: EcoColors.text,
                  ),
                ),
                Text(
                  'Level ${data['level']}',
                  style: GoogleFonts.poppins(fontSize: 12, color: EcoColors.subtitle),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: EcoColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${data['point']} Poin',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: EcoColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
