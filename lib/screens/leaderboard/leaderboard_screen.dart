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
            
            if (data.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'Belum ada data peringkat',
                    style: GoogleFonts.poppins(color: EcoColors.subtitle),
                  ),
                ),
              )
            else ...[
              _buildPodium(data),
              const SizedBox(height: 20),
              // Menampilkan sisa list peringkat mulai dari urutan ke-4 ke bawah
              ...data.skip(3).map((d) => _buildRankItem(d, false)),
            ],
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
    if (data.length < 3) {
      return Column(
        children: data.map((d) => _buildRankItem(d, false)).toList(),
      );
    }

    return SizedBox(
      height: 240, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _buildPodiumItem(data[1], 2, 90)),  
          Expanded(child: _buildPodiumItem(data[0], 1, 120)), 
          Expanded(child: _buildPodiumItem(data[2], 3, 70)),  
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

    final String rawName = data['name']?.toString() ?? 'User';
    final String displayName = rawName.split(' ').first;
    final String initial = rawName.isNotEmpty ? rawName[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (rank == 1)
            const Icon(Icons.emoji_events_rounded, size: 20, color: Color(0xFFFFD54F))
          else
            const SizedBox(height: 20), 
          const SizedBox(height: 4),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors[rank]!.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: colors[rank]!, width: 2),
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors[rank],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            displayName,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: EcoColors.text,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            '${data['point'] ?? 0} Pts',
            style: GoogleFonts.poppins(fontSize: 10, color: EcoColors.subtitle, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            height: barHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors[rank]!, colors[rank]!.withOpacity(0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 24,
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
    final String rawName = data['name']?.toString() ?? 'User';
    final String initial = rawName.isNotEmpty ? rawName[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: EcoColors.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#${data['rank'] ?? '-'}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: EcoColors.text,
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: EcoColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.poppins(
                  fontSize: 15,
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
                  rawName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: EcoColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Level ${data['level'] ?? 1}',
                  style: GoogleFonts.poppins(fontSize: 11, color: EcoColors.subtitle),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: EcoColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${data['point'] ?? 0} Poin',
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