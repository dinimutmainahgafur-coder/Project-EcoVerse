import 'package:flutter/material.dart';
import '../core/colors.dart';

/// Widget badge card yang reusable
class BadgeCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isUnlocked;
  final IconData icon;

  const BadgeCard({
    super.key,
    required this.title,
    this.description = '',
    this.isUnlocked = false,
    this.icon = Icons.emoji_events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? EcoColors.card : EcoColors.greyLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? EcoColors.gold : EcoColors.divider,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: EcoColors.gold.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? EcoColors.gold.withOpacity(0.1)
                  : EcoColors.divider.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isUnlocked ? EcoColors.gold : EcoColors.subtitle,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? EcoColors.text : EcoColors.subtitle,
            ),
            textAlign: TextAlign.center,
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: EcoColors.subtitle.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
