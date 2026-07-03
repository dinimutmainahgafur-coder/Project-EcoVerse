import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import '../../widgets/progress_card.dart';

/// Halaman Eco Challenge
class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eco Challenge',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Challenge Mingguan',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: EcoColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildWeeklyChallenges(),
            const SizedBox(height: 24),
            Text(
              'Challenge Bulanan',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: EcoColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildMonthlyChallenges(),
            const SizedBox(height: 24),
            Text(
              'Reward',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: EcoColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildRewards(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChallenges() {
    final challenges = [
      {
        'title': 'Zero Waste Week',
        'description': 'Kurangi sampah plastik selama 7 hari',
        'progress': 0.6,
        'reward': '500 pts',
        'status': 'Berlangsung',
      },
      {
        'title': 'Water Saver',
        'description': 'Hemat air selama 5 hari berturut-turut',
        'progress': 0.3,
        'reward': '300 pts',
        'status': 'Berlangsung',
      },
      {
        'title': 'Go Green Commuter',
        'description': 'Gunakan transportasi ramah lingkungan',
        'progress': 0.0,
        'reward': '400 pts',
        'status': 'Tersedia',
      },
    ];

    return Column(
      children: challenges.map((challenge) {
        final statusColor = challenge['status'] == 'Berlangsung'
            ? EcoColors.blue
            : EcoColors.primary;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: EcoColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: EcoColors.primary.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['title'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: EcoColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          challenge['description'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: EcoColors.subtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      challenge['status'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ProgressCard(
                title: 'Progress',
                progress: challenge['progress'] as double,
                subtitle: 'Reward: ${challenge['reward']}',
                color: statusColor,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthlyChallenges() {
    final challenges = [
      {
        'title': 'Plastic Free July',
        'description': 'Hindari penggunaan plastik sebulan penuh',
        'progress': 0.25,
        'reward': '2000 pts',
        'status': 'Berlangsung',
      },
      {
        'title': 'Energy Conservation',
        'description': 'Kurangi konsumsi energi 30% dari bulan lalu',
        'progress': 0.1,
        'reward': '1500 pts',
        'status': 'Berlangsung',
      },
    ];

    return Column(
      children: challenges.map((challenge) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: EcoColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: EcoColors.gold.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['title'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: EcoColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          challenge['description'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: EcoColors.subtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: EcoColors.gold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      challenge['status'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ProgressCard(
                title: 'Progress',
                progress: challenge['progress'] as double,
                subtitle: 'Reward: ${challenge['reward']}',
                color: EcoColors.gold,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRewards() {
    final rewards = [
      {'title': 'Badge: Eco Warrior', 'icon': Icons.emoji_events, 'unlocked': true},
      {'title': 'Badge: Water Saver', 'icon': Icons.water_drop, 'unlocked': true},
      {'title': 'Badge: Zero Hero', 'icon': Icons.recycling, 'unlocked': false},
      {'title': 'Badge: Green Master', 'icon': Icons.forest, 'unlocked': false},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final isUnlocked = reward['unlocked'] as bool;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnlocked ? EcoColors.card : EcoColors.greyLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnlocked ? EcoColors.gold : EcoColors.divider,
              width: isUnlocked ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                reward['icon'] as IconData,
                size: 32,
                color: isUnlocked ? EcoColors.gold : EcoColors.subtitle,
              ),
              const SizedBox(height: 8),
              Text(
                reward['title'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? EcoColors.text : EcoColors.subtitle,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
