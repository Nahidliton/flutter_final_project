// lib/widgets/category_filter_chip.dart

import 'package:flutter/material.dart';

class CategoryFilterChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterChip({
    required this.label,
    this.color,
    this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        onSelected: (_) => onTap(),
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : (color ?? Colors.grey),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: color?.withOpacity(0.15) ?? Colors.grey.shade100,
        selectedColor: color ?? Colors.grey.shade700,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        side: isSelected
            ? BorderSide.none
            : BorderSide(
                color: (color?.withOpacity(0.3) ?? Colors.grey.shade300),
                width: 1,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
