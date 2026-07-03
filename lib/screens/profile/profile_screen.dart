import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/bottom_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: EcoColors.background,
      appBar: AppBar(
        title: Text(
          'EcoVerse',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: EcoColors.text),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: EcoColors.text),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22, color: EcoColors.text),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 20),
            _buildStatsRow(user),
            const SizedBox(height: 20),
            _buildBadgeSection(),
            const SizedBox(height: 20),
            _buildActivityHistory(),
            const SizedBox(height: 20),
            _buildLogoutButton(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: EcoBottomNavbar(
        currentIndex: 4,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (i == 1) Navigator.pushNamed(context, '/journal');
          if (i == 2) Navigator.pushNamed(context, '/mission');
          if (i == 3) Navigator.pushNamed(context, '/leaderboard');
        },
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
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
            color: EcoColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
            ),
            child: Center(
              child: Text(
                (user?.name ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.name ?? 'User',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${user?.username ?? 'user'}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(dynamic user) {
    return Row(
      children: [
        _buildStatItem('${user?.ecoPoint ?? 0}', 'Eco Points', EcoColors.primary),
        const SizedBox(width: 12),
        _buildStatItem('${user?.level ?? 1}', 'Level', EcoColors.gold),
        const SizedBox(width: 12),
        _buildStatItem('${user?.badges?.length ?? 1}', 'Badge', const Color(0xFF29B6F6)),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, color: EcoColors.subtitle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeSection() {
    final badges = [
      {'icon': Icons.eco_rounded, 'label': 'Pemula\nHijau', 'unlocked': true},
      {'icon': Icons.public_rounded, 'label': 'Pejuang\nBumi', 'unlocked': true},
      {'icon': Icons.shield_rounded, 'label': 'Eco\nWarrior', 'unlocked': false},
      {'icon': Icons.verified_user_rounded, 'label': 'Planet\nGuardian', 'unlocked': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Badge',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: EcoColors.text,
              ),
            ),
            Text(
              'Lihat semua',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: EcoColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: badges.map((b) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: b['unlocked'] == true ? EcoColors.card : EcoColors.greyLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: b['unlocked'] == true
                        ? EcoColors.gold.withValues(alpha: 0.5)
                        : EcoColors.divider,
                    width: b['unlocked'] == true ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      b['icon'] as IconData,
                      size: 28,
                      color: b['unlocked'] == true ? EcoColors.gold : EcoColors.subtitle.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      b['label'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: b['unlocked'] == true ? EcoColors.text : EcoColors.subtitle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActivityHistory() {
    final activities = [
      {'title': 'Bawa Tumbler Sendiri', 'point': '+20 Poin', 'time': 'Hari ini'},
      {'title': 'Memilah Sampah', 'point': '+15 Poin', 'time': 'Kemarin'},
      {'title': 'Hemat Air', 'point': '+10 Poin', 'time': '2 hari lalu'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Riwayat Aktivitas',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: EcoColors.text,
              ),
            ),
            Text(
              'Lihat semua',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: EcoColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...activities.map((a) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: EcoColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eco_rounded, color: EcoColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['title']!,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: EcoColors.text,
                      ),
                    ),
                    Text(
                      a['time']!,
                      style: GoogleFonts.poppins(fontSize: 11, color: EcoColors.subtitle),
                    ),
                  ],
                ),
              ),
              Text(
                a['point']!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: EcoColors.primary,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              content: Text(
                'Apakah kamu yakin ingin logout?',
                style: GoogleFonts.poppins(fontSize: 14, color: EcoColors.subtitle),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Batal', style: GoogleFonts.poppins(color: EcoColors.subtitle)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.poppins(color: EcoColors.error, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
          if (confirmed == true && context.mounted) {
            await context.read<AuthProvider>().logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          }
        },
        icon: const Icon(Icons.logout_rounded, color: EcoColors.error, size: 20),
        label: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: EcoColors.error,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: EcoColors.error, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
