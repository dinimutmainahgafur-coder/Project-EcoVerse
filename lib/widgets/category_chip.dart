import 'package:flutter/material.dart';
import '../core/colors.dart';

/// Widget chip kategori yang reusable
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? EcoColors.primary : EcoColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? EcoColors.primary : EcoColors.divider,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: EcoColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : EcoColors.text,
          ),
        ),
      ),
    );
  }
}
