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
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? (color ?? Colors.grey.shade700)
                  : (color?.withOpacity(0.12) ?? Colors.grey.shade100),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? (color ?? Colors.grey.shade700)
                    : (color?.withOpacity(0.3) ?? Colors.grey.shade300),
                width: isSelected ? 0 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: (color ?? Colors.grey).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : (color ?? Colors.grey.shade700),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : (color ?? Colors.grey.shade700),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
