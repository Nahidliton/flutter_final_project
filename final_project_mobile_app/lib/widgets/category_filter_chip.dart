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
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        onSelected: (_) => onTap(),
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : (color ?? Colors.grey),
              ),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        backgroundColor: color?.withOpacity(0.2) ?? Colors.grey.shade200,
        selectedColor: color ?? Colors.grey,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
