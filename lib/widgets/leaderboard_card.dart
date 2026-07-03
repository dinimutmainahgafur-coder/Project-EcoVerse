import 'package:flutter/material.dart';
import '../core/colors.dart';

/// Widget kartu leaderboard yang reusable
class LeaderboardCard extends StatelessWidget {
  final int rank;
  final String name;
  final int point;
  final int level;
  final bool isCurrentUser;

  const LeaderboardCard({
    super.key,
    required this.rank,
    required this.name,
    required this.point,
    required this.level,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? EcoColors.primary.withOpacity(0.08)
            : EcoColors.card,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: EcoColors.primary, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: isTop3 ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: rank == 1
                    ? EcoColors.gold
                    : rank == 2
                        ? Colors.grey
                        : rank == 3
                            ? Colors.brown
                            : EcoColors.text,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(rank).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getRankColor(rank),
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
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCurrentUser
                        ? EcoColors.primary
                        : EcoColors.text,
                  ),
                ),
                Text(
                  'Level $level',
                  style: const TextStyle(
                    fontSize: 12,
                    color: EcoColors.subtitle,
                  ),
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
              '$point pts',
              style: const TextStyle(
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

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return EcoColors.gold;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return EcoColors.text;
    }
  }
}
